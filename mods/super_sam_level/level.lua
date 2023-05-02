
-- name => level
local current_levels = {}

-- coords
local lookdir_to_rad = {
	["+x"] = math.pi / 2 * 3,
	["-x"] = math.pi / 2,
	["-z"] = math.pi,
	["+z"] = 0
}

function super_sam_level.start_level(player, level)
	local playername = player:get_player_name()
	local start_pos = vector.add(level.start, super_sam.player_offset)

	minetest.log("action", "[super_sam] starting level '" .. level.name .. "' for player '" .. playername .. "'")

	-- set start position
	local distance = vector.distance(level.start, player:get_pos())
	if distance > super_sam.beacon_teleport_distance then
		-- only move player if he's too far away
		player:set_pos(start_pos)
	end

	-- set look dir, if set
	if level.lookdir ~= "" then
		-- center vertical look
		player:set_look_vertical(0)
		local rad = lookdir_to_rad[level.lookdir]
		if rad then
			player:set_look_horizontal(rad)
		end
	end

	-- set timer
	super_sam.set_time(playername, level.time)

	-- store current level
	current_levels[playername] = level
end

function super_sam_level.get_current_level(player)
	local playername = player:get_player_name()
	return current_levels[playername]
end

function super_sam_level.finalize_level(player, highscore_name)
	local finished_level = super_sam_level.get_current_level(player)
	if not finished_level then
		-- nothing started, ignore
		return
	end

	local playername = player:get_player_name()

	minetest.log("action", "[super_sam] finalizing current level for player '" .. playername .. "'")

	-- update score and highscore
	local coins = super_sam.get_coins(playername)
	super_sam.set_coins(playername, 0)

	-- convert coins and remaining time to score
	local remaining_time = super_sam.get_time(playername)
	super_sam.add_score(playername, (coins * 100) + (remaining_time * 10))

	if highscore_name and highscore_name ~= nil then
		-- level collection done
		-- update highscore and reset player score
		local score = super_sam.get_score(playername)
		super_sam.set_score(playername, 0)
		super_sam_highscore.update_highscore(playername, score, highscore_name)

		local rank = super_sam_highscore.get_highscore_rank(playername, highscore_name)
		if rank then
			minetest.chat_send_player(
				playername,
				"Highscore rank for level '" .. highscore_name .. "': " .. minetest.colorize("#00FF00", rank)
			)
		end
	end

	-- effects
	super_sam.animation_cash(player, coins)

	-- Clear time
	super_sam.set_time(playername, nil)

	-- Clear current level name
	current_levels[playername] = nil
end

-- aborts the current level (used for edit mode or on death)
-- teleports the player to the last startpos if in play mode
function super_sam_level.abort_level(player)
	local playername = player:get_player_name()
	minetest.log("action", "[super_sam] aborting level for player '" .. playername .. "'")

	super_sam.set_coins(playername, 0)
	super_sam.set_time(playername, nil)

	current_levels[playername] = nil

	if super_sam.check_play_mode(player) then
		super_sam.teleport_player_startpos(player)
		super_sam.animation_failed(player)
	end
end

super_sam.on_event(super_sam.EVENT_MODE_CHANGE, function(player, mode)
	if mode == "edit" then
		super_sam_level.abort_level(player)
	end
end)

super_sam.on_event(super_sam.EVENT_TIMEOUT, function(player)
	super_sam_level.abort_level(player)
end)

minetest.register_on_respawnplayer(function(player)
	super_sam_level.abort_level(player)
	return true
end)

-- resets the level after the player is outside the defined level-area
function super_sam_level.reset_level(player)
	local playername = player:get_player_name()
	local level = current_levels[playername]
	if not level then
		return
	end

	minetest.log("action", "[super_sam] resetting level for player '" .. playername .. "'")

	-- clear level data
	super_sam.set_coins(playername, 0)
	current_levels[playername] = nil

	-- start level again
	super_sam_level.start_level(player, level)

	-- particle rain on respawn position
	super_sam.animation_failed(player)
end

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	current_levels[playername] = nil
end)

minetest.register_chatcommand("killme", {
	description = "Resets the current level",
	func = function(name)
		local player = minetest.get_player_by_name(name)
		super_sam_level.abort_level(player)
		return true, "Level reset!"
	end
})
