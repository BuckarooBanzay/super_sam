local MP = minetest.get_modpath("super_sam_map")

mapsync.register_backend("default", {
    type = "patch",
    path = MP .. "/map",
    patch_path = MP .. "/patch"
})

mapsync.register_data_backend({
    type = "fs",
    path = MP .. "/data"
})

-- only builders can use travelnets
function travelnet.allow_travel(player_name)
    return minetest.check_player_privs(player_name, "super_sam_builder")
end