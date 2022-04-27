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

    super_sam.sound_play_jump(player)
end)
