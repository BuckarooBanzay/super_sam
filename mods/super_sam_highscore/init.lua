super_sam_highscore = {
    storage = minetest.get_mod_storage(),
}

local MP = minetest.get_modpath(minetest.get_current_modname())

dofile(MP .. "/format.lua")
dofile(MP .. "/highscore.lua")
dofile(MP .. "/node.lua")
