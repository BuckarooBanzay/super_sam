
local function can_start_level(player, beacon_pos)
    local meta = minetest.get_meta(beacon_pos)
    local required_lvl = meta:get_string("required_lvl")
    return required_lvl == "" or super_sam.has_finished_level(player, required_lvl)
end

local function execute_teleport(player, beacon_pos)
    local playername = player:get_player_name()
    local meta = minetest.get_meta(beacon_pos)
    local target_pos = {
        x = meta:get_int("tpx"),
        y = meta:get_int("tpy"),
        z = meta:get_int("tpz")
    }

    if can_start_level(player, beacon_pos) or minetest.check_player_privs(playername, "super_sam_builder") then
        player:set_pos(vector.add(target_pos, super_sam.player_offset))
    else
        local required_lvl = meta:get_string("required_lvl")
        minetest.sound_play({ name = "super_sam_game_over", gain = 2 }, { to_player = playername }, true)
        minetest.chat_send_player(
            playername,
            "You haven't finished the required level for this yet: '" .. required_lvl .. "'"
        )
    end
end

minetest.register_abm({
    label = "Level start beacon effect",
    nodenames = "super_sam:level_start_beacon",
    interval = 5,
    chance = 1,
    action = function(beacon_pos)
        for _, player in ipairs(minetest.get_connected_players()) do
            local distance = vector.distance(player:get_pos(), beacon_pos)
            if distance < 50 and can_start_level(player, beacon_pos) then
                minetest.add_particlespawner({
                    amount = 50,
                    time = 5,
                    -- floor
                    minpos = vector.subtract(beacon_pos, {x=0.5, y=-0.5, z=0.5}),
                    maxpos = vector.add(beacon_pos, {x=0.5, y=0.5, z=0.5}),
                    minvel = {x=0, y=1, z=0},
                    maxvel = {x=0, y=2, z=0},
                    minsize = 2,
                    texture = "super_sam_items.png^[sheet:6x5:5,2",
                    playername = player:get_player_name()
                })
            end
        end
    end
})

-- level start (lounge platform)
minetest.register_node("super_sam:level_start_beacon", {
    description = "Level start beacon",
    tiles = {
        "super_sam_beacon_lit.png",
        "super_sam_beacon_side.png"
    },
    groups = { cracky = 1 },
    on_rightclick = function(pos, _, player)
        if minetest.check_player_privs(player:get_player_name(), "super_sam_builder") then
            super_sam.show_level_start_formspec(pos, player:get_player_name())
        else
            execute_teleport(player, pos)
        end
    end,
    on_punch = function(pos, _, player)
        execute_teleport(player, pos)
    end,
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("required_lvl", "my_level_name")
    end,
})
