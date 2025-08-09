# PallyPowerTW for Turtle WOW

## Please note!
## 1) Use your Left mouse button to do a Greater Blessing!
## 2) Use your Right mouse button to do Normal (10 min) Blessings!

<img src="https://raw.githubusercontent.com/ivanovlk/PallyPowerTW/refs/heads/master/ScreenShot.png" float="left" align="left" width="100%">

### BuffBar horizontal layout with hidden default Aura frame
<img src="https://raw.githubusercontent.com/ivanovlk/PallyPowerTW/refs/heads/master/ScreenShotAura.png">

### How to install: Download the zip file and rename to PallyPowerTW or use Turtle WOW Launcher
### Hunter pets and Warrors share same class so if you use Greater blessings it will affect both Warriors and Pets ( not a bug )

## Additional info -> https://github.com/ivanovlk/PallyPowerTW/wiki/PallyPowerTW-Addon-Wiki

### Whats new:
- Allow to mark a player as a tank (and sync) in Assignment grid (middle mouse button click at player name below the class icon)
- When a paladin leaves the party assignment grid is adjusted
- Optional usage of PFUI HD Icons (option can be found in settings. Default use regular icons)
- Make use of UnitXP_SP3 line of sight check (if available) and mana check before cast (mana check still under construction)
- Allow saving Assignment presets like "All Salvation", "All Kings" and so on. Including Auras.
- Fixed nasty memory leak in Assignment grid
- /pp report to display full class/assignment list and aura
- Hide Blizzard aura frame option ( Why ? Bacuse, I like it hidden and use PallyPower for aura management )
- Allow change between horizontal or vertical layout for BuffBar
- Allow others to change your blessings without being Party Leader / Raid Assistant.
- Support for individual blessings
- Support for Auras
- Righteous fury on the buff bar
- Left click for Greater blessings / right click for "small" blessings. 
- If Individual blessings are selected small buffs are applied with Right click
- Don't allow Individual blessings without global blessings. Also do not allow Global and Individual blessings to be the same 
- Change Aura and Blessing assignment direclty via Buff Bar
- Play sound when blessings expire
- Included an option to change between Regular Blessings and Greater Blessings.
- Shows the buff frame when solo
- Included Pet in the buff table
- Show the max rank of each blessing each paladin has available + if they have talents that buff the blessing (specific to v+)
- Show the correct duration to each blessing based on v+ duration
- Added Spanish localization by Nuevemasnueve

### Changelog
09.08.25 - Warriors and hunter pets share same class so if they have same blessing assigned and you cast greater blessing PP marks both warriors and pets as blessed in buff bar
15.07.25 - Fix: When casting Greater Blessings and several targets are out of range addon assumes they got the buff and does not allow to re-cast GB. 
Now those targets are correctly marked as Need blessing and allow re-cast of GB.
15.07.25 - Aura assignment is also saved in Presets 
15.07.25 - Allow mark of player as a tank and sync with other paladins
