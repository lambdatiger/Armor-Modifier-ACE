[b]Armor Modifier - ACE[/b] is required on all clients and server and adds the ability to tweak armor effectiveness.

[h2]CBA Settings[/h2]
Inputs are arrays of numbers, in the form of: '[armorMultiplier, minimumArmor, maximumArmor]'
[list]
[*] [b]armorMultiplier:[/b] Interval: '[0.001 - infinite]'. If '=1', this setting has no effect.
[*] [b]minimumArmor:[/b] Interval: '[0 - infinite]'. If '<1', this setting has no effect.
[*] [b]maximumArmor:[/b] Interval: '[0 - infinite]'. If '<1', this setting has no effect.
[/list]

No settings depend of each other, except for that that 'minimumArmor' should be smaller or equal than 'maximumArmor'.

These settings are available for players and AI separately:
[list]
[*] [b]Hitpoint damage reduction - head:[/b] Allows the modification of damage reduction on head hitpoints.
[*] [b]Hitpoint damage reduction - chest:[/b] Allows the modification of damage reduction on chest hitpoints.
[*] [b]Hitpoint damage reduction - limb:[/b] Allows the modification of damage reduction on all limb hitpoints.
[/list]

If mission makers wish to set coefficients on individual units, you can use the following:
[code]
// For head coefficients
_unit setVariable ["armor_modifier_ace_main_hitPointMultiplier_head", [armorMultiplier, minimumArmor, maximumArmor], true];

// For chest coefficients
_unit setVariable ["armor_modifier_ace_main_hitPointMultiplier_chest", [armorMultiplier, minimumArmor, maximumArmor], true];

// For limb coefficients
_unit setVariable ["armor_modifier_ace_main_hitPointMultiplier_limb", [armorMultiplier, minimumArmor, maximumArmor], true];
[/code]

[h2]Examples[/h2]
[list]
[*] If [b]Player hitpoint damage reduction - chest[/b] is set to '[10, 0, 0]', it means that you take a 10th of the damage to the chest.
[*] If [b]Player hitpoint damage reduction - chest[/b] is set to '[1, 10, 0]', it means that the minimum chest armor you have is 10. This means that if you have chest armor below 10, it will act as if you had 10 chest armor hitpoints and reduce the damage accordingly.
[*] If [b]Player hitpoint damage reduction - chest[/b] is set to '[0.1, 10, 0]', it means that the minimum chest armor you have is 10 and you will take 10 times the damage. This means that if you have chest armor below 10, it will act as if you had 10 chest armor hitpoints and reduce the damage accordingly. Furthermore, it will multiply the damage by 10.
[/list]

[h2]Warning[/h2]
This mod might conflict with other mods. If you find an incompatibility, please report it.

[h2]Links[/h2]
[list]
[*] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2930736286]Steam Workshop[/url]
[*] [url=https://github.com/johnb432/Armor-Modifier-ACE]GitHub[/url]
[/list]

[h2]Credit[/h2]
[list]
[*] Inspired by [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2849354160]ACE Armor Adjuster[/url]
[*] Mod by johnb43
[/list]

[h2]License[/h2]
See LICENSE.
