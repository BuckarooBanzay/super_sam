
local function check_current_level()
	for _, player in ipairs(minetest.get_connected_players()) do
		local playername = player:get_player_name()
		local playmode = super_sam.check_play_mode(player)
		local current_level = super_sam_level.get_current_level(player)
		if playmode and current_level then
			-- check bounds
			local ppos = player:get_pos()
			if ppos.x < (current_level.bounds.min.x - 0.5) or
				ppos.y < (current_level.bounds.min.y - 0.5) or
				ppos.z < (current_level.bounds.min.z - 0.5) or
				ppos.x > (current_level.bounds.max.x + 0.5) or
				ppos.y > (current_level.bounds.max.y + 0.5) or
				ppos.z > (current_level.bounds.max.z + 0.5) then
				minetest.chat_send_player(playername, "Outside the level-region, resetting...")
				super_sam_level.reset_level(player)
			end
		end
	end

	minetest.after(0.5, check_current_level)
end
minetest.after(0.5, check_current_level)