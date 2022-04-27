-- constants
local META_STARTPOS = "super_sam_startpos"

function super_sam.set_player_startpos(player, pos)
	if not pos then
		pos = player:get_pos()
	end
	local meta = player:get_meta()
	meta:set_string(META_STARTPOS, minetest.pos_to_string(pos))
end

function super_sam.teleport_player_startpos(player)
	local meta = player:get_meta()
	local last_startpos = meta:get_string(META_STARTPOS)
	if last_startpos ~= "" then
		-- restore last safe position
		player:set_pos(minetest.string_to_pos(last_startpos))
	else
		-- move to spawn pos
		player:set_pos(super_sam.spawn_pos)
		player:set_look_horizontal(super_sam.spawn_look_direction)
	end
end

minetest.register_on_joinplayer(function(player)
	if not super_sam.check_play_mode(player) then
		-- not in play mode
		return
	end
	super_sam.teleport_player_startpos(player)
end)

local function worker()
	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = player:get_pos()
		if ppos.y < -100 then
			-- player fell into the abyss
			local playername = player:get_player_name()

			if super_sam.check_play_mode(player) then
				-- play mode, teleport back
				local meta = player:get_meta()
				local last_pos = minetest.string_to_pos(
					meta:get_string(META_STARTPOS) or minetest.pos_to_string(super_sam.spawn_pos)
				)
				player:set_pos(last_pos)
			else
				-- edit mode, just warn
				minetest.chat_send_player(playername, "WARNING: You are below the teleport-back y-position!")
			end
		end
	end
	minetest.after(1, worker)
end

minetest.after(1, worker)