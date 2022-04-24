local function execute_teleport(player, beacon_pos)
    local meta = minetest.get_meta(beacon_pos)
    local target_pos = {
        x = meta:get_int("tpx"),
        y = meta:get_int("tpy"),
        z = meta:get_int("tpz")
    }

    player:set_pos(vector.add(target_pos, super_sam.player_offset))
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
        local control = player:get_player_control()
        local is_builder = minetest.check_player_privs(player:get_player_name(), "super_sam_builder")
        if not control.sneak and is_builder then
            -- only teleport if sneak _not_ pressed and in builder/edit mode
            execute_teleport(player, pos)
        end
    end,
    on_rightclick = function(pos, _, player)
        if minetest.check_player_privs(player:get_player_name(), "super_sam_builder") then
            super_sam.show_level_end_formspec(pos, player:get_player_name())
        end
    end
})

local function finish_level(player, beacon_pos)
    if not super_sam.get_current_level(player) then
        -- not in a level
        return
    end
    super_sam.finalize_level(player)
    execute_teleport(player, beacon_pos)
end

minetest.register_abm({
    label = "Level end beacon",
    nodenames = "super_sam:level_end_beacon",
    interval = 1,
    chance = 1,
    action = function(beacon_pos)
        for _, player in ipairs(minetest.get_connected_players()) do
            local distance = vector.distance(player:get_pos(), beacon_pos)
            if distance <= super_sam.beacon_teleport_distance then
                finish_level(player, beacon_pos)
            end
        end
    end
})