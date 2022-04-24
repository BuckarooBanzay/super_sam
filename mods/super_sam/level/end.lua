local function execute_teleport(player, beacon_pos)
    local control = player:get_player_control()
    if control.sneak then
        -- don't do anything if sneak is pressed
        return
    end

    local meta = minetest.get_meta(beacon_pos)
    local target_pos = {
        x = meta:get_int("tpx"),
        y = meta:get_int("tpy"),
        z = meta:get_int("tpz")
    }

    if not super_sam.check_play_mode(player) then
        -- either the level-requirements are met or the player is in edit-mode
        player:set_pos(vector.add(target_pos, super_sam.player_offset))
    end
end

-- level end beacon
minetest.register_node("super_sam:level_end_beacon", {
    description = "Level end beacon",
    tiles = {
        "super_sam_beacon_red.png",
        "super_sam_beacon_side.png"
    },
    groups = { cracky = 1 },
    on_punch = function(pos, _, player)
        execute_teleport(player, pos)
    end,
    on_rightclick = function(pos, _, player)
        if minetest.check_player_privs(player:get_player_name(), "super_sam_builder") then
            super_sam.show_level_end_formspec(pos, player:get_player_name())
        end
    end
})
