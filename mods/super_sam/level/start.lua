-- level start (lounge platform)
minetest.register_node("super_sam:level_start_beacon", {
    description = "Level start beacon",
    tiles = {
        "super_sam_beacon_lit.png",
        "super_sam_beacon_side.png"
    },
    groups = { cracky = 1 }
})
