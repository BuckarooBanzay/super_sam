super_sam = {
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
dofile(MP .. "/startpos.lua")
dofile(MP .. "/protection.lua")
dofile(MP .. "/spawn.lua")
dofile(MP .. "/controls.lua")
dofile(MP .. "/privs.lua")
dofile(MP .. "/intro.lua")
dofile(MP .. "/register_hidden.lua")
dofile(MP .. "/animations.lua")

-- level stuff
dofile(MP .. "/level/finished_levels.lua")
dofile(MP .. "/level/formspec.lua")
dofile(MP .. "/level/start_formspec.lua")
dofile(MP .. "/level/end_formspec.lua")
dofile(MP .. "/level/level.lua")
dofile(MP .. "/level/level_check.lua")
dofile(MP .. "/level/beacon.lua")
dofile(MP .. "/level/start.lua")
dofile(MP .. "/level/end.lua")

-- item/node callbacks
dofile(MP .. "/itempickup.lua")

-- hud/player stuff
dofile(MP .. "/player_setup.lua")
dofile(MP .. "/time.lua")
dofile(MP .. "/score.lua")
dofile(MP .. "/coins.lua")
dofile(MP .. "/health.lua")
dofile(MP .. "/effects.lua")
dofile(MP .. "/hud.lua")
dofile(MP .. "/mode.lua")
dofile(MP .. "/jump.lua")
dofile(MP .. "/shoot.lua")

-- nodes, items, etc
dofile(MP .. "/items.lua")
dofile(MP .. "/itemspawner.lua")
dofile(MP .. "/platformspawner.lua")
dofile(MP .. "/projectilespawner.lua")
dofile(MP .. "/tools.lua")
dofile(MP .. "/highscore.lua")
