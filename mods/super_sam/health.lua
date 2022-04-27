
minetest.register_on_respawnplayer(function(player)
	super_sam.abort_level(player)
	return true
end)

super_sam.register_on_pickup("super_sam:heart", function(player)
	player:set_hp(math.min(super_sam.max_hp, player:get_hp() + 1), "set_hp")
	player:set_breath(minetest.PLAYER_MAX_BREATH_DEFAULT)
	super_sam.update_player_hud(player)
	super_sam.sound_health_bonus(player)
end)

-- game over sound
minetest.register_on_dieplayer(super_sam.sound_play_gameover)

minetest.register_on_player_hpchange(function(player, hp_change)
	local playername = player:get_player_name()
	minetest.log("action", "[super_sam] hp_change for player '" .. playername .. "' with change: " .. hp_change)
	super_sam.update_player_hud(player)

	if hp_change == (-20 + super_sam.max_hp) then
		-- special case: initial join and set_hp call for default hp, ignore
		return
	elseif hp_change < 0 then
		-- damage sound
		super_sam.sound_play_gameover(player)
	end
end)