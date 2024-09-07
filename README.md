**Armor Modifier - ACE** is required on all clients and server and adds the ability to tweak armor effectiveness. This is not an official ACE mod.

<h2>CBA Settings</h2>

Inputs are arrays of numbers, in the form of: `[armorMultiplier, minimumArmor, maximumArmor]`
* **armorMultiplier:** Interval: `[0.001 - infinite]`. If `=1`, this setting has no effect.
* **minimumArmor:** Interval: `[0 - infinite]`. If `<1`, this setting has no effect.
* **maximumArmor:** Interval: `[0 - infinite]`. If `<1`, this setting has no effect.

No settings depend of each other, except for that that `minimumArmor` should be smaller or equal than `maximumArmor`.In addition, two is usually the minimum hitpoint armor a unit has without any equipment on.

There are two main modes of operation. The first relies on a division between players and AI. The second relies on a division between sides (i.e., `west`, `east`, `resistance`, and `civilian`). In both cases, individual units can have their own settings

These settings are available for players and AI separately:
* **Hitpoint damage reduction - head:** Allows the modification of damage reduction on head hitpoints.
* **Hitpoint damage reduction - chest:** Allows the modification of damage reduction on chest hitpoints.
* **Hitpoint damage reduction - limb:** Allows the modification of damage reduction on all limb hitpoints.

If mission makers wish to set coefficients on individual units, you can use the following:
```sqf
// For head coefficient
[_unit, "hitHead", [armorMultiplier, minimumArmor, maximumArmor]] call armor_modifier_ace_main_fnc_setUnitArmor;

// For torso coefficients
[_unit, "ama_hitTorso", [armorMultiplier, minimumArmor, maximumArmor]] call armor_modifier_ace_main_fnc_setUnitArmor;
```

If mission makers wish to set coefficients on class names, you can use the following:
```sqf
// For head coefficient
[typeOf _unit, "hitHead", [armorMultiplier, minimumArmor, maximumArmor]] call armor_modifier_ace_main_fnc_setClassArmor;

// For torso coefficients
[typeOf _unit, "ama_hitTorso", [armorMultiplier, minimumArmor, maximumArmor]] call armor_modifier_ace_main_fnc_setClassArmor;
```
Hit points can be one of the following
* Standard hit points including:
  * Head hit points - "hitHead", "hitNeck", "hitFace"
  * Body hit points - "hitAbdomen", "hitDiaphragm", "hitChest", "hitPelvis"
  * Limb hit points - "hitLeftArm", "hitRightArm", "hitLeftLeg", "hitRightLeg"
* Hit point groups such as
  * "ama_hitTorso" - combination of the "hitAbdomen", "hitDiaphragm", and "hitChest" hit points
  * "ama_hitBody" - combination of the "hitPelvis", "hitAbdomen", "hitDiaphragm", and "hitChest" hit points
  * "ama_hitArms" - combination of the "hitLeftArm" and "hitRightArm" hit points
  * "ama_hitLegs" - combination of the "hitLeftLeg" and "hitRightLeg" hit points
  * "ama_hitLimbs" - combination of the "ama_hitArms" and "ama_hitLegs" hit points

<h2>Examples</h2>

* If **Player hitpoint damage reduction - chest** is set to `[10, 0, 0]`, it means that you take a 10th of the damage to the chest.
* If **Player hitpoint damage reduction - chest** is set to `[1, 10, 0]`, it means that the minimum chest armor you have is 10. This means that if you have chest armor below 10, it will act as if you had 10 chest armor hitpoints and reduce the damage accordingly.
* If **Player hitpoint damage reduction - chest** is set to `[0.1, 10, 0]`, it means that the minimum chest armor you have is 10 and you will take 10 times the damage. This means that if you have chest armor below 10, it will act as if you had 10 chest armor hitpoints and reduce the damage accordingly. Furthermore, it will multiply the damage by 10.

<h2>Warning</h2>
This mod might conflict with other mods. If you find an incompatibility, please report it.

<h3>List of known incompatibility:</h3>

* [ACE Armor Adjuster](https://steamcommunity.com/sharedfiles/filedetails/?id=2849354160)

<h2>Links</h2>

* [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=2930736286)
* [GitHub](https://github.com/johnb432/Armor-Modifier-ACE)

<h2>Credit</h2>

* Inspired by [ACE Armor Adjuster](https://steamcommunity.com/sharedfiles/filedetails/?id=2849354160)
* Code from ACE3
* Mod by johnb43

<h2>License</h2>

See LICENSE.
