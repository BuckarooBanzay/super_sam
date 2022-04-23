-- level end beacon
minetest.register_node("super_sam:level_end_beacon", {
    description = "Level end beacon",
    tiles = {
        "super_sam_beacon_red.png",
        "super_sam_beacon_side.png"
    },
    groups = { cracky = 1 },
    on_rightclick = function(pos, _, player)
        if minetest.check_player_privs(player:get_player_name(), "super_sam_builder") then
            super_sam.show_level_end_formspec(pos, player:get_player_name())
        end
    end
})
