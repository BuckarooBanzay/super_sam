super_sam = {
	editor_mode = minetest.settings:get_bool("super_sam_editor_mode"),
	max_hp = 3,
	storage = minetest.get_mod_storage(),
	beacon_teleport_distance = 4,
	player_offset = {x=0, y=0.5, z=0},
	zero_pos = {x=0, y=0, z=0},
	spawn_pos = { x=0, y=5.5, z=2004 },
	spawn_look_direction = math.pi
}

local MP = minetest.get_modpath(minetest.get_current_modname())

-- basic functions
dofile(MP .. "/events.lua")
dofile(MP .. "/startpos.lua")
dofile(MP .. "/protection.lua")
dofile(MP .. "/spawn.lua")
dofile(MP .. "/initial_emerge.lua")
dofile(MP .. "/privs.lua")
dofile(MP .. "/intro.lua")
dofile(MP .. "/register_hidden.lua")
dofile(MP .. "/animations.lua")
dofile(MP .. "/sounds.lua")

-- item/node callbacks
dofile(MP .. "/itempickup.lua")
dofile(MP .. "/creative.lua")

-- hud/player stuff
dofile(MP .. "/player_setup.lua")
dofile(MP .. "/time.lua")
dofile(MP .. "/score.lua")
dofile(MP .. "/coins.lua")
dofile(MP .. "/health.lua")
dofile(MP .. "/effects.lua")
dofile(MP .. "/mode.lua")
dofile(MP .. "/jump.lua")
dofile(MP .. "/shoot.lua")

-- nodes, items, etc
dofile(MP .. "/items.lua")
dofile(MP .. "/tools.lua")

if minetest.get_modpath("mtt") then
	dofile(MP .. "/mtt.lua")
end