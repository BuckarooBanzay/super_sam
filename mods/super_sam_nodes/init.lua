local MP = minetest.get_modpath(minetest.get_current_modname())

-- namespace
super_sam_nodes = {}

-- sounds
dofile(MP .. "/sounds.lua")

-- nodes, items, etc
dofile(MP .. "/nodes.lua")
dofile(MP .. "/trap_nodes.lua")
dofile(MP .. "/lights.lua")
dofile(MP .. "/spikes.lua")
dofile(MP .. "/fire.lua")
dofile(MP .. "/liquids.lua")
dofile(MP .. "/bakedclay.lua")
dofile(MP .. "/plants.lua")
