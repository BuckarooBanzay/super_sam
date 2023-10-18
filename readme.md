Super sam adventures

![](https://github.com/BuckarooBanzay/super_sam/workflows/luacheck/badge.svg)
![GitHub repo size](https://img.shields.io/github/repo-size/buckaroobanzay/super_sam)
[![License](https://img.shields.io/badge/License-MIT%20and%20CC%20BY--SA%204.0-green.svg)](license.txt)
[![Download](https://img.shields.io/badge/Download-ContentDB-blue.svg)](https://content.minetest.net/packages/BuckarooBanzay/super_sam)

State: **Stable**

Guide sam through the various levels and score points

Built with [mapsync](https://github.com/Buckaroobanzay/mapsync)

Official discord server: https://discord.gg/JcyaETW3zz

# Commands

* `/ambience [on|off]` enable or disable ambient sounds
* `/mode [edit|play]` switch between play- and edit-mode (to edit the map)

# Map editing / contributing

* Fork the `super_sam` repository and add it as a game
* Grant yourself the needed privs for editing with `/grantme all`
* Set the `super_sam_editor_mode` setting to true
* Edit/add stuff
* Export the edited map part with `/mapsync_save <affected-chunk-range>` (the chunk range is usually 1 for a 240 nodes cubic diameter)
* **OR**: Enable autosave with `/mapsync_autosave on`
* Commit and create a PR to this repo
* Profit

In emergencies:
* Contact me on IRC (*BuckarooBanzai*) or discord (*BuckarooBanzai#6742*)

# License

* Code: MIT
* Textures: (unless otherwise noted) CC-BY SA 4.0
* `menu/icon.png` CC-BY SA 4.0 https://opengameart.org/content/mario-like-stuff
* `menu/theme.ogg` CC-BY SA 4.0 https://freesound.org/people/LagMusics/sounds/582027/
* Others: see the `readme.md` or `license.txt` files in the various `mods/*` folders
