-- jump sound effect

super_sam.register_control("jump", function(player, state)
    if minetest.check_player_privs(player, "fly") then
        -- only play if not in fly mode
        return
    end

    if not state then
        -- true -> false
        return
    end

    local playername = player:get_player_name()
    minetest.sound_play({ name = "super_sam_jump", gain = 0.7 }, { to_player = playername }, true)
end)
