-- jump sound effect

controls.register_on_press(function(player, control_name)
	if control_name ~= "jump" then
		return
	end

	if minetest.check_player_privs(player, "fly") then
		-- only play if not in fly mode
		return
	end

	super_sam.sound_play_jump(player)
end)
