#include "script_component.hpp"

/*
 * Author: commy2, SilentSpike, modified by johnb43
 * Original:
 * HandleDamage EH where wound events are raised based on incoming damage.
 * Be aware that for each source of damage, the EH can fire multiple times (once for each hitpoint).
 * We store these incoming damages and compare them on our final hitpoint: "ace_hdbracket".
 * Added:
 * Handling of damage to allow armor modifcation.
 *
 * Arguments:
 * Handle damage EH
 *
 * Return Value:
 * Damage to be inflicted <NUMBER>
 *
 * Public: No
 */

params ["_unit", "_selection", "_damage", "_shooter", "_ammo", "_hitPointIndex", "_instigator", "_hitpoint", "_directHit", ["_ignoreAllowDamageACE", false]];

// HD sometimes triggers for remote units - ignore.
if !(local _unit) exitWith {nil};

// Get missing meta info
private _oldDamage = 0;

if (_hitPoint isEqualTo "") then {
    _hitPoint = "#structural";
    _oldDamage = damage _unit;
} else {
    _oldDamage = _unit getHitIndex _hitPointIndex;
};

// Damage can be disabled with old variable or via sqf command allowDamage
if !(isDamageAllowed _unit && {_unit getVariable ["ace_medical_allowDamage", true] || {_ignoreAllowDamageACE}}) exitWith {_oldDamage};

private _newDamage = _damage - _oldDamage;
// Get armor value of hitpoint and calculate damage before armor
private _armor = [_unit, _hitpoint] call ace_medical_engine_fnc_getHitpointArmor;
private _realDamage = _newDamage * _armor;
TRACE_4("Received hit",_hitpoint,_ammo,_newDamage,_realDamage);

// Drowning doesn't fire the EH for each hitpoint so the "ace_hdbracket" code never runs
// Damage occurs in consistent increments
if (
    _hitPoint isEqualTo "#structural" &&
    {getOxygenRemaining _unit <= 0.5} &&
    {_damage isEqualTo (_oldDamage + 0.005)}
) exitWith {
    TRACE_5("Drowning",_unit,_shooter,_instigator,_damage,_newDamage);
    ["ace_medical_woundReceived", [_unit, [[_newDamage, "Body", _newDamage]], _unit, "drowning"]] call CBA_fnc_localEvent;

    0
};

// Crashing a vehicle doesn't fire the EH for each hitpoint so the "ace_hdbracket" code never runs
// It does fire the EH multiple times, but this seems to scale with the intensity of the crash
private _vehicle = vehicle _unit;
if (
    ace_medical_enableVehicleCrashes &&
    {_hitPoint isEqualTo "#structural"} &&
    {_ammo isEqualTo ""} &&
    {_vehicle != _unit} &&
    {vectorMagnitude (velocity _vehicle) > 5}
    // todo: no way to detect if stationary and another vehicle hits you
) exitWith {
    TRACE_5("Crash",_unit,_shooter,_instigator,_damage,_newDamage);
    ["ace_medical_woundReceived", [_unit, [[_newDamage, _hitPoint, _newDamage]], _unit, "vehiclecrash"]] call CBA_fnc_localEvent;

    0
};

// This hitpoint is set to trigger last, evaluate all the stored damage values
// to determine where wounds are applied
if (_hitPoint isEqualTo "ace_hdbracket") exitWith {
    _unit setVariable ["ace_medical_lastDamageSource", _shooter];
    _unit setVariable ["ace_medical_lastInstigator", _instigator];

    private _damageStructural = _unit getVariable ["ace_medical_engine_$#structural", [0,0,0,0]];

    // --- Head
    private _damageHead = [
        _unit getVariable ["ace_medical_engine_$HitFace", [0,0,0,0]],
        _unit getVariable ["ace_medical_engine_$HitNeck", [0,0,0,0]],
        _unit getVariable ["ace_medical_engine_$HitHead", [0,0,0,0]]
    ];
    _damageHead sort false;
    _damageHead = _damageHead select 0;

    // --- Body
    private _damageBody = [
        _unit getVariable ["ace_medical_engine_$HitPelvis", [0,0,0,0]],
        _unit getVariable ["ace_medical_engine_$HitAbdomen", [0,0,0,0]],
        _unit getVariable ["ace_medical_engine_$HitDiaphragm", [0,0,0,0]],
        _unit getVariable ["ace_medical_engine_$HitChest", [0,0,0,0]]
        // HitBody removed as it's a placeholder hitpoint and the high armor value (1000) throws the calculations off
    ];
    _damageBody sort false;
    _damageBody = _damageBody select 0;

    // --- Arms and Legs
    private _damageLeftArm = _unit getVariable ["ace_medical_engine_$HitLeftArm", [0,0,0,0]];
    private _damageRightArm = _unit getVariable ["ace_medical_engine_$HitRightArm", [0,0,0,0]];
    private _damageLeftLeg = _unit getVariable ["ace_medical_engine_$HitLeftLeg", [0,0,0,0]];
    private _damageRightLeg = _unit getVariable ["ace_medical_engine_$HitRightLeg", [0,0,0,0]];

    // Find hit point that received the maxium damage
    // Priority used for sorting if incoming damage is equal
    private _allDamages = [
        // Real damage (ignoring armor),                  Actual damage (with armor),                Real damage modified (ignoring armor), Modified damage (with armor)
        [_damageHead select 0,       PRIORITY_HEAD,       _damageHead select 1,       "Head",        _damageHead param [2, _damageHead select 0],               _damageHead param [3, _damageHead select 1]],
        [_damageBody select 0,       PRIORITY_BODY,       _damageBody select 1,       "Body",        _damageBody param [2, _damageBody select 0],               _damageBody param [3, _damageBody select 1]],
        [_damageLeftArm select 0,    PRIORITY_LEFT_ARM,   _damageLeftArm select 1,    "LeftArm",     _damageLeftArm param [2, _damageLeftArm select 0],         _damageLeftArm param [3, _damageLeftArm select 1]],
        [_damageRightArm select 0,   PRIORITY_RIGHT_ARM,  _damageRightArm select 1,   "RightArm",    _damageRightArm param [2, _damageRightArm select 0],       _damageRightArm param [3, _damageRightArm select 1]],
        [_damageLeftLeg select 0,    PRIORITY_LEFT_LEG,   _damageLeftLeg select 1,    "LeftLeg",     _damageLeftLeg param [2, _damageLeftLeg select 0],         _damageLeftLeg param [3, _damageLeftLeg select 1]],
        [_damageRightLeg select 0,   PRIORITY_RIGHT_LEG,  _damageRightLeg select 1,   "RightLeg",    _damageRightLeg param [2, _damageRightLeg select 0],       _damageRightLeg param [3, _damageRightLeg select 1]],
        [_damageStructural select 0, PRIORITY_STRUCTURAL, _damageStructural select 1, "#structural", _damageStructural param [2, _damageStructural select 0],   _damageStructural param [3, _damageStructural select 1]]
    ];
    TRACE_2("incoming",_allDamages,_damageStructural);

    _allDamages sort false;
    // Use modified damages instead of initial ones
    _allDamages = _allDamages apply {[_x select 5, _x select 3, _x select 4]};

    // Environmental damage sources all have empty ammo string
    // No explicit source given, we infer from differences between them
    if (_ammo isEqualTo "") then {
        // Any collision with terrain/vehicle/object has a shooter
        // Check this first because burning can happen at any velocity
        if !(isNull _shooter) then {
            /*
              If shooter != unit then they hit unit, otherwise it could be:
               - Unit hitting anything at speed
               - An empty vehicle hitting unit
               - A physX object hitting unit
               Assume fall damage for downward velocity because it's most common
            */
            if (_shooter == _unit && {(velocity _unit select 2) < -2}) then {
                _ammo = "falling";
                TRACE_5("Fall",_unit,_shooter,_instigator,_damage,_allDamages);
            } else {
                _ammo = "collision";
                TRACE_5("Collision",_unit,_shooter,_instigator,_damage,_allDamages);
            };
        } else {
            // Anything else is almost guaranteed to be fire damage
            _ammo = "fire";
            TRACE_5("Fire Damage",_unit,_shooter,_instigator,_damage,_allDamages);
        };
    };

    // No wounds for minor damage
    // TODO check if this needs to be changed for burning damage (occurs as lots of small events that we add together)
    if ((_allDamages select 0 select 0) > 1E-3) then {
        TRACE_1("received",_allDamages);
        ["ace_medical_woundReceived", [_unit, _allDamages, _shooter, _ammo]] call CBA_fnc_localEvent;
    };

    // Clear stored damages otherwise they will influence future damage events
    // (aka wounds will pile onto the historically most damaged hitpoint)
    {
        _unit setVariable [_x, nil];
    } forEach [
        "ace_medical_engine_$HitFace","ace_medical_engine_$HitNeck","ace_medical_engine_$HitHead",
        "ace_medical_engine_$HitPelvis","ace_medical_engine_$HitAbdomen","ace_medical_engine_$HitDiaphragm","ace_medical_engine_$HitChest","ace_medical_engine_$HitBody",
        "ace_medical_engine_$HitLeftArm","ace_medical_engine_$HitRightArm","ace_medical_engine_$HitLeftLeg","ace_medical_engine_$HitRightLeg",
        "ace_medical_engine_$#structural"
    ];

    0
};

// Get setting for particular unit
private _multiplierArray = switch (true) do {
    case (_hitPoint in ["hitface", "hitneck", "hithead"]): {
        _unit getVariable [QGVAR(hitPointMultiplier_head), [GVAR(hitPointMultiplier_ai_head), GVAR(hitPointMultiplier_player_head)] select (isPlayer _unit)]
    };
    case (_hitPoint in ["hitpelvis" ,"hitabdomen", "hitdiaphragm", "hitchest"]): {
        _unit getVariable [QGVAR(hitPointMultiplier_chest), [GVAR(hitPointMultiplier_ai_chest), GVAR(hitPointMultiplier_player_chest)] select (isPlayer _unit)]
    };
    case (_hitPoint in ["hitleftarm", "hitrightarm", "hitleftleg", "hitrightleg"]): {
        _unit getVariable [QGVAR(hitPointMultiplier_limb), [GVAR(hitPointMultiplier_ai_limb), GVAR(hitPointMultiplier_player_limb)] select (isPlayer _unit)]
    };
    default {
        DEFAULT_SETTINGS
    };
};

private _modifiedNewDamage = _newDamage;
private _modifiedRealDamage = _realDamage;

// If default settings, we don't need to change anything, so skip calculcations and let ace handle damage
if (_multiplierArray isNotEqualTo DEFAULT_SETTINGS) then {
    _multiplierArray params ["_hitPointMultiplier", "_armorMin", "_armorMax"];

    switch (true) do {
        case (_armorMin >= 1 && {_armor < _armorMin}): {
            // This will decrease damage
            _modifiedNewDamage = _newDamage * _armor / _armorMin;
            _modifiedRealDamage = _realDamage * _armor / _armorMin;

            TRACE_6("Under min armor",_armor,_armorMin,_newDamage,_modifiedNewDamage,_realDamage,_modifiedRealDamage);
        };
        case (_armorMax >= 1 && {_armor > _armorMax}): {
            // This will increase damage
            _modifiedNewDamage = _newDamage * _armor / _armorMax;
            _modifiedRealDamage = _realDamage * _armor / _armorMax;

            TRACE_6("Over max armor",_armor,_armorMax,_newDamage,_modifiedNewDamage,_realDamage,_modifiedRealDamage);
        };
    };

    _modifiedNewDamage = _modifiedNewDamage / _hitPointMultiplier;
    _modifiedRealDamage = _modifiedRealDamage / _hitPointMultiplier;

    TRACE_5("Hitpoint damage multiplied",_armor,_newDamage,_modifiedNewDamage,_realDamage,_modifiedRealDamage);
};

// Damages are stored for "ace_hdbracket" event triggered last
_unit setVariable [format ["ace_medical_engine_$%1", _hitPoint], [_realDamage, _newDamage, _modifiedRealDamage, _modifiedNewDamage]];

// Engine damage to these hitpoints controls blood visuals, limping, weapon sway
// Handled in fnc_damageBodyPart, persist here
if (_hitPoint in ["hithead", "hitbody", "hithands", "hitlegs"]) exitWith {_oldDamage};

// We store our own damage values so engine damage is unnecessary
0
