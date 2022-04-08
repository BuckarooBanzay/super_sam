
-- level player-capture and shift-to-next
minetest.register_node("super_sam:level_beacon", {
    description = "Level beacon",
    tiles = {
        "super_sam_beacon_grey.png",
        "super_sam_beacon_side.png"
    },
    groups = { cracky = 1 },
    on_rightclick = function(pos, _, player)
        super_sam.show_level_formspec(pos, player:get_player_name())
    end,
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)

        -- position offsets
        meta:set_int("xplus", 0)
		meta:set_int("yplus", 0)
		meta:set_int("zplus", 0)
        meta:set_int("xminus", 0)
        meta:set_int("yminus", 0)
        meta:set_int("zminus", 0)

        meta:set_int("time", 120)
        meta:set_string("name", "My level")

        super_sam.register_level_beacon(pos)
    end,
})

minetest.register_lbm({
    label = "Level beacon register",
    name = "super_sam:level_beacon",
    nodenames = "super_sam:level_beacon",
    run_at_every_load = true,
    action = super_sam.register_level_beacon
})
