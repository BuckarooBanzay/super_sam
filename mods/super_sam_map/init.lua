mapsync.register_backend("default", {
    type = "fs",
    path = minetest.get_modpath("super_sam_map") .. "/map"
})

mapsync.register_data_backend({
    type = "fs",
    path = minetest.get_modpath("super_sam_map") .. "/data"
})

-- only builders can use travelnets
function travelnet.allow_travel(player_name)
    return minetest.check_player_privs(player_name, "super_sam_builder")
end