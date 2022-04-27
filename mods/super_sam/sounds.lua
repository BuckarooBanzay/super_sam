
function super_sam.sound_play_cash(player)
	local playername = player:get_player_name()
	minetest.sound_play({ name = "super_sam_cash", gain = 1.5 }, { to_player = playername }, true)
end

function super_sam.sound_play_coin(player)
	local playername = player:get_player_name()
	minetest.sound_play({ name = "super_sam_coin", gain = 0.3 }, { to_player = playername }, true)
end

function super_sam.sound_play_effect_on(player)
	local playername = player:get_player_name()
	minetest.sound_play({ name = "super_sam_effect_on", gain = 0.7 }, { to_player = playername }, true)
end

function super_sam.sound_play_effect_off(player)
	local playername = player:get_player_name()
	minetest.sound_play({ name = "super_sam_effect_off", gain = 0.7 }, { to_player = playername }, true)
end

function super_sam.sound_play_jump(player)
	local playername = player:get_player_name()
	minetest.sound_play({ name = "super_sam_jump", gain = 0.7 }, { to_player = playername }, true)
end

function super_sam.sound_health_bonus(player)
	local playername = player:get_player_name()
	minetest.sound_play({ name = "super_sam_heart", gain = 0.7 }, { to_player = playername }, true)
end

function super_sam.sound_play_gameover(player)
	local playername = player:get_player_name()
	minetest.sound_play({ name = "super_sam_game_over", gain = 2 }, { to_player = playername }, true)
end