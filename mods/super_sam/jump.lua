-- jump sound effect

-- playername -> bits
local previous_state = {}

minetest.register_globalstep(function()
    for _, player in ipairs(minetest.get_connected_players()) do
        local playername = player:get_player_name()
        local control = player:get_player_control()
        local previous_control = previous_state[playername]
        if previous_control and not previous_control.jump and control.jump then
            -- jump [off -> on]
            minetest.sound_play({ name = "super_sam_jump", gain = 0.7 }, { to_player = playername }, true)
        end
        previous_state[playername] = control
    end
end)

minetest.register_on_leaveplayer(function(player)
    previous_state[player:get_player_name()] = nil
end)