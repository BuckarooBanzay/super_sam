super_sam = {}

local MP = minetest.get_modpath(minetest.get_current_modname())

-- basic functions
dofile(MP .. "/protection.lua")
dofile(MP .. "/hand.lua")
dofile(MP .. "/spawn.lua")
dofile(MP .. "/privs.lua")
dofile(MP .. "/skybox.lua")
dofile(MP .. "/sounds.lua")
dofile(MP .. "/itempickup.lua")
dofile(MP .. "/score.lua")
dofile(MP .. "/hud.lua")

-- nodes, items, etc
dofile(MP .. "/items.lua")
dofile(MP .. "/nodes.lua")
dofile(MP .. "/itemspawner.lua")
dofile(MP .. "/platformspawner.lua")
dofile(MP .. "/projectilespawner.lua")
dofile(MP .. "/liquids.lua")
dofile(MP .. "/bakedclay.lua")
dofile(MP .. "/plants.lua")
dofile(MP .. "/tools.lua")
