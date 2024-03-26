#include "script_component.hpp"

// Compatibility for "1st MEU Aux Mod"
if (!isNil "NSM_jumppack_fnc_handle_damage") exitWith {
    ["CAManBase", "initPost", {
        params ["_unit"];

        private _ehID = _unit getVariable ["ace_medical_HandleDamageEHID", -1];

        // If no EH exists, don't add one
        if (_ehID == -1) exitWith {};

        // Replace existing ace medical damage event handlers
        _unit removeEventHandler ["HandleDamage", _ehID];

        _ehID = _unit addEventHandler ["HandleDamage", {
            params ["_unit", "", "_damage", "", "_projectile"];

            private _ignoreAllowDamageACE = false;

            if (!(_unit getVariable ["ace_medical_allowDamage", true]) && {_unit getVariable ["NSM_jumppack_isJumping", false]} && {_projectile isNotEqualTo ""}) then {
                (NSM_JUMPPACK_DAMAGE_MAP getOrDefault [backpack _unit, [NSM_JUMPPACK_DAMAGE_DEFAULT_CHANCE, NSM_JUMPPACK_DAMAGE_DEFAULT_DAMAGE], true]) params ["_chance", "_damageMultiplier"];

                // Check if chance to not receive damage
                if (random 100 > _chance) exitWith {};

                // Change damage received
                _this set [2, _damage * _damageMultiplier];

                // Ignore value of "ace_medical_allowDamage"
                _ignoreAllowDamageACE = true;
            };

            [_this, _ignoreAllowDamageACE] call FUNC(handleDamage)
        }];

        _unit setVariable ["ace_medical_HandleDamageEHID", _ehID];

        // Remove old EH after a delay (doesn't exist in post init)
        [{
            private _ehID = _this getVariable "NSM_Jumppack_handleDamageEHID";

            if (isNil "_ehID") exitWith {};

            _this removeEventHandler ["HandleDamage", _ehID];

            _this setVariable ["NSM_Jumppack_handleDamageEHID", nil];
        }, _unit, 0.5] call CBA_fnc_waitAndExecute;
    }, true, [], true] call CBA_fnc_addClassEventHandler;
};

// Call in post init, so that we are sure to overwrite default ACE damage handling and any other mods interfering with ACE medical
["CAManBase", "initPost", {
    params ["_unit"];

    private _ehID = _unit getVariable ["ace_medical_HandleDamageEHID", -1];

    // If no EH exists, don't add one
    if (_ehID == -1) exitWith {};

    // Replace existing ace medical damage event handler
    _unit removeEventHandler ["HandleDamage", _ehID];

    _ehID = _unit addEventHandler ["HandleDamage", {[_this] call FUNC(handleDamage)}];

    _unit setVariable ["ace_medical_HandleDamageEHID", _ehID];
}, true, [], true] call CBA_fnc_addClassEventHandler;
