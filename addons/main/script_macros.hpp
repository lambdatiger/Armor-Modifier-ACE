#include "\x\cba\addons\main\script_macros_common.hpp"

// This part includes parts of the CBA and ACE3 macro libraries
#define GETMVAR(var1,var2) (missionNamespace getVariable [ARR_2(var1,var2)])
#define SETMVAR(var1,var2,var3) (missionNamespace setVariable [ARR_3(var1,var2,var3)])

#define DEFAULT_SETTINGS [ARR_3(1,0,0)]
#define MINIMUM_SETTINGS [ARR_3(0.001,0,0)]
#define DEFAULT_HASH_SETTINGS createHashMapFromArray [["hithead",[1,0,0]],["hitdiaphragm",[1,0,0]],["hitleftarm",[1,0,0]],["hitleftleg",[1,0,0]],["hitneck",[1,0,0]],["hitpelvis",[1,0,0]],["hitrightleg",[1,0,0]],["hitchest",[1,0,0]],["hitabdomen",[1,0,0]],["hitrightarm",[1,0,0]],["hitface",[1,0,0]]]

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

// #include "\z\ace\addons\medical_engine\script_component.hpp"
#define PRIORITY_HEAD       3
#define PRIORITY_BODY       4
#define PRIORITY_LEFT_ARM   (1 + random 1)
#define PRIORITY_RIGHT_ARM  (1 + random 1)
#define PRIORITY_LEFT_LEG   (1 + random 1)
#define PRIORITY_RIGHT_LEG  (1 + random 1)
#define PRIORITY_STRUCTURAL 1

#define GET_NUMBER(config,default) (if (isNumber (config)) then {getNumber (config)} else {default})
