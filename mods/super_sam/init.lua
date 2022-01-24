super_sam = {
    max_hp = 3,
    storage = minetest.get_mod_storage()
}

local MP = minetest.get_modpath(minetest.get_current_modname())

-- basic functions
dofile(MP .. "/protection.lua")
dofile(MP .. "/spawn.lua")
dofile(MP .. "/privs.lua")
dofile(MP .. "/level.lua")
dofile(MP .. "/level_formspec.lua")
dofile(MP .. "/level_store.lua")
dofile(MP .. "/highscore.lua")
dofile(MP .. "/intro.lua")
dofile(MP .. "/update_check.lua")

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

-- nodes, items, etc
dofile(MP .. "/level_beacon.lua")
dofile(MP .. "/items.lua")
dofile(MP .. "/itemspawner.lua")
dofile(MP .. "/platformspawner.lua")
dofile(MP .. "/projectilespawner.lua")
dofile(MP .. "/tools.lua")
