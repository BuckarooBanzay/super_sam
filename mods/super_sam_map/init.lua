mapsync.register_backend("default", {
    type = "fs",
    path = minetest.get_modpath("super_sam_map") .. "/map"
})

mapsync.register_data_backend({
    type = "fs",
    path = minetest.get_modpath("super_sam_map") .. "/data"
})