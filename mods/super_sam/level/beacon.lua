
local function execute_teleport(player, beacon_pos)
    local playername = player:get_player_name()
    local meta = minetest.get_meta(beacon_pos)
    local target_pos = {
        x = meta:get_int("tpx"),
        y = meta:get_int("tpy"),
        z = meta:get_int("tpz")
    }

    if not vector.equals(target_pos, super_sam.zero_pos) and minetest.check_player_privs(playername, "super_sam_builder") then
        -- move the editor to the target coords
        player:set_pos(vector.add(target_pos, super_sam.player_offset))
    end
end

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
    on_punch = function(pos, _, player)
        execute_teleport(player, pos)
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
