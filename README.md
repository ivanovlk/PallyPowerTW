# PallyPowerTW

Paladin blessing, aura, and seal management addon for WoW 1.12 / TurtleWoW. Coordinates assignments across multiple Paladins in a raid, tracks buff status per class, and provides one-click Greater/regular blessing casting.

## Screenshots

<img src="https://raw.githubusercontent.com/ivanovlk/PallyPowerTW/refs/heads/master/ScreenShot.png" float="left" align="left" width="100%">

*Main assignment UI*

<img src="https://raw.githubusercontent.com/ivanovlk/PallyPowerTW/refs/heads/master/ScreenShotAura.png">

*BuffBar horizontal layout with hidden default Aura frame*

## Installation

Download the zip file and rename to PallyPowerTW, or use the Turtle WoW Launcher.

## Usage

Left-click a buff bar button to cast a Greater Blessing. Right-click to cast a normal (10 min) blessing. If individual blessings are assigned, right-click applies those instead.

## Slash Commands

| Command | Description |
|---------|-------------|
| `/pp` or `/pallypower` | Toggle the main assignment UI frame |
| `/pp report` | Print current blessing/aura assignments to raid or party chat |
| `/pp buff` or `/pp autobuff` | Auto-buff all assigned blessings on nearby players |
| `/pp lock` | Toggle locking/unlocking frame positions |
| `/pp debug` | Toggle debug mode (prints diagnostic info to chat) |

## Features

- Assign/clear raid icon when player is marked as tank (requires Raid Leader/Assist or party leader)
- Assign seals for each paladin -- useful for boss fights
- Greater Blessings not allowed on pets if pets and Warriors have different blessings assigned
- If Warriors and pets have the same assignment, mark both as blessed when using Greater Blessings
- Update tank assignment in pfUI (if available)
- Mark a player as a tank (and sync) in the assignment grid (middle mouse button click on player name below the class icon)
- When a paladin leaves the party, the assignment grid adjusts automatically
- Optional pfUI HD Icons (option in settings; defaults to regular icons)
- Line-of-sight checking via UnitXP_SP3 (if available) and mana check before cast
- Save assignment presets ("All Salvation", "All Kings", etc.) including auras
- `/pp report` displays full class/assignment list and aura
- Hide Blizzard aura frame option
- Switch between horizontal or vertical layout for the BuffBar
- Allow others to change your blessings without being Party Leader / Raid Assistant
- Support for individual blessings
- Support for auras
- Righteous Fury on the buff bar
- Individual blessings require a global blessing; global and individual cannot be the same
- Change aura and blessing assignment directly via the BuffBar
- Play sound when blessings expire
- Toggle between regular blessings and Greater Blessings
- Shows the buff frame when solo
- Pet support in the buff table
- Show max rank of each blessing per paladin + talent bonuses
- Show correct blessing duration based on Turtle WoW values
- Spanish localization by Nuevemasnueve

## Known Issues

- "[Patch FR] Turtle WoW en francais + Pack de voix francaise corrige pour VoiceOver" is not supported. PallyPowerTW does not work correctly when this mod is installed.

## Notes

- Hunter pets and Warriors share the same class ID, so Greater Blessings affect both (not a bug).

## Additional Resources

[PallyPowerTW Addon Wiki](https://github.com/ivanovlk/PallyPowerTW/wiki/PallyPowerTW-Addon-Wiki)

## Changelog

- 01.03.26 - Event-driven scanning replaces timer-based polling (zero CPU cost when idle). TurtleWoW realm detection for correct blessing durations (also vanilla 1.12.1 compatible). New `/pp lock` slash command for toggling frame positions. Scan frequency repurposed as UI debounce interval (clamped to max 2s). Removed obsolete "Poll Per Frame" setting. Slash commands documented in README.
- 25.08.25 - If Salvation is assigned, user is tank, and no individual blessings, do not count against need (so the BuffBar button stays green even with tank missing Salvation).
- 25.08.25 - Assign/clear raid icon when player is marked as tank if we are Raid Leader/Assist or party leader.
- 22.08.25 - Allow assignments of seals for each paladin.
- 22.08.25 - Mark as tank reflects to pfUI tank assignment (if available). Don't allow GB on pets if Warriors assignment differs from pets assignment. If same assignment, mark both as GB-blessed.
- 09.08.25 - Warriors and hunter pets share same class so if they have same blessing assigned and you cast Greater Blessing, PP marks both Warriors and pets as blessed in BuffBar.
- 15.07.25 - Fix: When casting Greater Blessings and several targets are out of range, addon assumes they got the buff and does not allow re-cast of GB. Now those targets are correctly marked as needing blessing and allow re-cast of GB.
- 15.07.25 - Aura assignment is also saved in presets.
- 15.07.25 - Allow marking a player as a tank and sync with other paladins.
