**Armor Modifier - ACE** is required on all clients and server and adds the ability to tweak armor effectiveness. This is not an official ACE mod.

<h2>CBA Settings</h2>

Inputs are arrays of numbers, in the form of: `[armorMultiplier, minimumArmor, maximumArmor]`
* **armorMultiplier:** Interval: `[0.001 - infinite]`. If `=1`, this setting has no effect.
* **minimumArmor:** Interval: `[0 - infinite]`. If `<1`, this setting has no effect.
* **maximumArmor:** Interval: `[0 - infinite]`. If `<1`, this setting has no effect.

No settings depend of each other, except for that that `minimumArmor` should be smaller or equal than `maximumArmor`.

These settings are available for players and AI separately:
* **Hitpoint damage reduction - head:** Allows the modification of damage reduction on head hitpoints.
* **Hitpoint damage reduction - chest:** Allows the modification of damage reduction on chest hitpoints.
* **Hitpoint damage reduction - limb:** Allows the modification of damage reduction on all limb hitpoints.

If mission makers wish to set coefficients on individual units, you can use the following:
```sqf
// For head coefficients
_unit setVariable ["armor_modifier_ace_main_hitPointMultiplier_head", [armorMultiplier, minimumArmor, maximumArmor], true];

// For chest coefficients
_unit setVariable ["armor_modifier_ace_main_hitPointMultiplier_chest", [armorMultiplier, minimumArmor, maximumArmor], true];

// For limb coefficients
_unit setVariable ["armor_modifier_ace_main_hitPointMultiplier_limb", [armorMultiplier, minimumArmor, maximumArmor], true];
```

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

<h2>How to create PBOs</h2>

* Download and install hemtt from [here](https://github.com/BrettMayson/HEMTT)
* Open command terminal, navigate to said folder (Windows: cd 'insert path')
* Type "hemtt build" for pbo, "hemtt build --release" for entire release
