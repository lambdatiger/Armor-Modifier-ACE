#include "script_component.hpp"

// Call in post init, so that we are sure to overwrite default ACE damage handling and any other mods interfering with ACE medical
["CAManBase", "initPost", {
    params ["_unit"];

    private _ehID = _unit getVariable ["ace_medical_HandleDamageEHID", -1];

    // If no EH exists, don't add one
    if (_ehID == -1) exitWith {};

    // Replace existing ace medical damage event handler
    _unit removeEventHandler ["HandleDamage", _ehID];

    _ehID = _unit addEventHandler ["HandleDamage", {_this call FUNC(handleDamage)}];

    _unit setVariable ["ace_medical_HandleDamageEHID", _ehID];
}, true, [], true] call CBA_fnc_addClassEventHandler;
