super_sam = {}

local MP = minetest.get_modpath(minetest.get_current_modname())

-- basic functions
dofile(MP .. "/protection.lua")
dofile(MP .. "/spawn.lua")
dofile(MP .. "/privs.lua")
dofile(MP .. "/skybox.lua")
dofile(MP .. "/sounds.lua")
dofile(MP .. "/level.lua")

-- item/node callbacks
dofile(MP .. "/itempickup.lua")
dofile(MP .. "/nodetouch.lua")

-- hud/player stuff
dofile(MP .. "/ambience.lua")
dofile(MP .. "/player.lua")
dofile(MP .. "/time.lua")
dofile(MP .. "/score.lua")
dofile(MP .. "/coins.lua")
dofile(MP .. "/health.lua")
dofile(MP .. "/effects.lua")
dofile(MP .. "/hud.lua")
dofile(MP .. "/mode.lua")
dofile(MP .. "/jump.lua")

-- nodes, items, etc
dofile(MP .. "/level_beacon.lua")
dofile(MP .. "/items.lua")
dofile(MP .. "/nodes.lua")
dofile(MP .. "/lights.lua")
dofile(MP .. "/spikes.lua")
dofile(MP .. "/itemspawner.lua")
dofile(MP .. "/platformspawner.lua")
dofile(MP .. "/projectilespawner.lua")
dofile(MP .. "/liquids.lua")
dofile(MP .. "/bakedclay.lua")
dofile(MP .. "/plants.lua")
dofile(MP .. "/tools.lua")
