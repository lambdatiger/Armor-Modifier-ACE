if (getNumber (configFile >> "CfgPatches" >> "ace_main" >> "version") >= 3.18) then {
    PREP(handleDamage,handleDamage);
} else {
    PREP(handleDamage,handleDamageOld);
};
