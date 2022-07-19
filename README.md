# RPCX Core
So basically this is the base... framework? of PolicingMP (or whatever it ends up turning into).
There's gonna be a bunch of experimental stuff and probably bad code in here and I want to use this as a learning experience for learning lua, github, etc.

I'm using some code from other people, admittedly. I try to add links to the original code commented above where I can.

Be sure to check out the extension for this script: https://github.com/OfficerBozza/RPCX-MapScripts which includes some extra content.

## What does it do?
In no particular order:

### Weapons:
- Persistent weapon flashlight (BetterFlashlight users need to enable a setting in the config)
- Weapons no longer automatically reload, or swap when empty
- Select fire for SMGs and Rifles
- Guns will randomly malfunction
- Hide weapon reticule and ammo HUD elements
- Decrease damage output of stungun, nightstick, as well as addon weapons WEAPON_BEANBAG and WEAPON_BATON
- Disable combat rolling and climbing while aiming
- Disable pistol whipping

### Vehicles:
- Wheel turn angle will be retained when getting out of cars
- Delete vehicle command (/dv, /delveh)
- Toggle engine command (/eng) with rebindable key (F6 by default)
- /door, /window, /trunk, /hood commands
- Holding the button to get out of a vehicle will leave the engine running

### Player:
- Command to heal yourself with cooldown (/heal)
- Command to give yourself armor (/armor, /armour)

### Misc:
- NPCs will remain calm in shootings, etc
- Disabled emergency services responses, wanted levels
- Blackout mode that keeps vehicle lights on (/blackout)
- Riot mode: NPCs will be given random guns and attack other NPCs and players (/riot). 
- Weapons you select in cars will be selected when you get out, and vice versa
- Hide map while on foot
- Hold Z/D-Pad-Down to zoom out minimap

## Credits
- https://github.com/TFNRP/framework
- https://github.com/TFNRP/WeaponControl
