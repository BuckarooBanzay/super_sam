
local function can_start_level(player, beacon_pos)
	local meta = minetest.get_meta(beacon_pos)
	local required_lvl = meta:get_string("required_lvl")
	if required_lvl ~= "" and not super_sam.has_finished_level(player, required_lvl) then
		-- player did not finish the required level
		return false, "You haven't finished the required level for this yet: '" .. required_lvl .. "'"
	end
	-- all conditions met
	return true
end

local function execute_teleport(player, beacon_pos)
	local control = player:get_player_control()
	if control.sneak then
		-- don't do anything if sneak is pressed
		return
	end

	local playername = player:get_player_name()
	local meta = minetest.get_meta(beacon_pos)
	local target_pos = {
		x = meta:get_int("tpx"),
		y = meta:get_int("tpy"),
		z = meta:get_int("tpz")
	}

	local ok, err_msg = can_start_level(player, beacon_pos)
	if ok or not super_sam.check_play_mode(player) then
		-- save startpos
		local start_pos = vector.add(beacon_pos, super_sam.player_offset)
		super_sam.set_player_startpos(player, start_pos)

		-- either the level-requirements are met or the player is in edit-mode
		player:set_pos(vector.add(target_pos, super_sam.player_offset))

		-- capture player, if a beacon is nearby
		minetest.after(0.1, function()
			-- because: minetest ¯\_(ツ)_/¯
			super_sam.capture_players_near_beacon(target_pos)
		end)
	else
		-- not allowed
		super_sam.sound_play_gameover(player)
		minetest.chat_send_player(playername, err_msg)
	end
end

local beacon_radius_outer = 50
local beacon_radius_inner = 2

-- list of players that could be captured (in a close radius to a beacon)
local capture_players = {}
local function get_beacon_capture_players(beacon_pos)
	local hash = minetest.hash_node_position(beacon_pos)
	local capture = capture_players[hash]
	if not capture then
		capture = {}
		capture_players[hash] = capture
	end
	return capture
end

-- gc
minetest.register_on_leaveplayer(function(player)
	for _, capture in pairs(capture_players) do
		capture[player:get_player_name()] = nil
	end
end)

-- beacon animation and player capture
minetest.register_abm({
	label = "Level start beacon effect",
	nodenames = "super_sam:level_start_beacon",
	interval = 1,
	chance = 1,
	action = function(beacon_pos)
		for _, player in ipairs(minetest.get_connected_players()) do
			if can_start_level(player, beacon_pos) then
				-- player could start that level
				-- beacon animation per player
				super_sam.animation_teleport_beacon(player, beacon_pos)

				local playername = player:get_player_name()
				local distance = vector.distance(player:get_pos(), beacon_pos)
				local capture = get_beacon_capture_players(beacon_pos)

				if distance <= beacon_radius_inner then
					-- player is in close proximity
					if capture[playername] and super_sam.check_play_mode(player) then
						-- player was inside the outer radius before, capture them
						capture[playername] = nil
						execute_teleport(player, beacon_pos)
					end
				elseif distance < beacon_radius_outer then
					-- player is inside the outer radius
					-- mark for capture
					capture[playername] = true
				else
					-- unmark for capture
					capture[playername] = nil
				end

			end
		end
	end
})

-- level start (lounge platform)
minetest.register_node("super_sam:level_start_beacon", {
	description = "Level start beacon",
	tiles = {
		"super_sam_beacon_lit.png",
		"super_sam_beacon_side.png"
	},
	groups = { cracky = 1 },
	on_rightclick = function(pos, _, player)
		if minetest.check_player_privs(player:get_player_name(), "super_sam_builder") then
			super_sam.show_level_start_formspec(pos, player:get_player_name())
		else
			execute_teleport(player, pos)
		end
	end,
	on_punch = function(pos, _, player)
		execute_teleport(player, pos)
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("required_lvl", "my_level_name")
	end,
})
