
local coins = {}

function super_sam.set_coins(name, amount)
	coins[name] = amount
end

function super_sam.get_coins(name)
	return coins[name] or 0
end

function super_sam.add_coins(name, amount)
	coins[name] = (coins[name] or 0) + amount
end

super_sam.register_on_item_pickup("super_sam:coin", function(player)
	local playername = player:get_player_name()
	super_sam.add_coins(playername, 1)
	super_sam.update_player_hud(player)
	super_sam.sound_play_coin(player)
end)