#define HITPOINT_SETTINGS(TYPE,HITPOINT,TEXT)\
[\
    QGVAR(TRIPLES(hitPointMultiplierSetting,TYPE,HITPOINT)),\
    "EDITBOX",\
    [TEXT, "Allows the tuning the effectiveness of groups of armor hitpoints.\n[hitpoint multiplier, minimum armor, maximum armor]\nIf minimum or maximum armor value is below 1, they don't take effect."],\
    [COMPONENT_NAME, FORMAT_1("%1 settings", QUOTE(TYPE))],\
    QUOTE(DEFAULT_SETTINGS),\
    0,\
    {\
        private _newSettings = parseSimpleArray _this;\
        private _parsedSettings = [];\
        \
        {\
            if (_x isEqualType 0) then {\
                _parsedSettings pushBack (_x max (MINIMUM_SETTINGS select _forEachIndex));\
            } else {\
                _parsedSettings pushBack (DEFAULT_SETTINGS select _forEachIndex);\
            };\
        } forEach _newSettings;\
        \
        if (_parsedSettings isNotEqualTo _newSettings) then {\
            [ARR_2("A setting was set too low or otherwise incorrectly, reverting to default setting.",3)] call ace_common_fnc_displayTextStructured;\
        };\
        \
        GVAR(TRIPLES(hitPointMultiplier,TYPE,HITPOINT)) = _parsedSettings;\
    }\
] call CBA_fnc_addSetting

HITPOINT_SETTINGS(Player,head,"Player hitpoint damage reduction - head");
HITPOINT_SETTINGS(Player,chest,"Player hitpoint damage reduction - chest");
HITPOINT_SETTINGS(Player,limb,"Player hitpoint damage reduction - limb");

HITPOINT_SETTINGS(AI,head,"AI hitpoint damage reduction - head");
HITPOINT_SETTINGS(AI,chest,"AI hitpoint damage reduction - chest");
HITPOINT_SETTINGS(AI,limb,"AI hitpoint damage reduction - limb");
