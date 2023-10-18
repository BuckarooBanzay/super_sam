super_sam_highscore = {
	storage = minetest.get_mod_storage(),
}

local MP = minetest.get_modpath(minetest.get_current_modname())

dofile(MP .. "/highscore.lua")
dofile(MP .. "/node.lua")
dofile(MP .. "/board.lua")
dofile(MP .. "/intro.lua")
