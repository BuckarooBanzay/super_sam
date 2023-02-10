
-- level player-capture and shift-to-next
minetest.register_node("super_sam:level_beacon", {
	description = "Level beacon",
	tiles = {
		"super_sam_beacon_grey.png",
		"super_sam_beacon_side.png"
	},
	groups = { cracky = 1 },
	on_rightclick = function(pos, _, player)
		super_sam.show_level_formspec(pos, player:get_player_name())
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)

		-- position offsets
		meta:set_int("xplus", 0)
		meta:set_int("yplus", 0)
		meta:set_int("zplus", 0)
		meta:set_int("xminus", 0)
		meta:set_int("yminus", 0)
		meta:set_int("zminus", 0)

		meta:set_int("time", 120)
		meta:set_string("name", "My level")
	end
})

local function create_level_def(beacon_pos)
	local meta = minetest.get_meta(beacon_pos)
	local node = minetest.get_node(beacon_pos)
	if node.name ~= "super_sam:level_beacon" then
		-- not a level beacon, ignore silently
		return
	end
	return {
		time = meta:get_int("time"),
		name = meta:get_string("name"),
		start = beacon_pos,
		lookdir = meta:get_string("lookdir"),
		bounds = {
			min = {
				x = beacon_pos.x - meta:get_int("xminus"),
				y = beacon_pos.y - meta:get_int("yminus"),
				z = beacon_pos.z - meta:get_int("zminus")
			},
			max = {
				x = beacon_pos.x + meta:get_int("xplus"),
				y = beacon_pos.y + meta:get_int("yplus"),
				z = beacon_pos.z + meta:get_int("zplus")
			}
		}
	}
end

-- pos_str(beacon_pos) => true
local emerged_levels = {}

-- emerge level before entering
local function pre_emerge_level(beacon_pos)
	local key = minetest.pos_to_string(beacon_pos)
	if emerged_levels[key] then
		return
	end

	local nearest_level = create_level_def(beacon_pos)
	if nearest_level and nearest_level.start then
		minetest.emerge_area(nearest_level.start, nearest_level.start)
	end

	emerged_levels[key] = true
end

local function check_level_progress(player, beacon_pos)
	if not super_sam.check_play_mode(player) then
		-- not in play mode, ignore
		return
	end
	local current_level = super_sam.get_current_level(player)
	local nearest_level = create_level_def(beacon_pos)

	if not nearest_level then
		-- no next level available
		return
	end

	if current_level then
		if current_level.name == nearest_level.name then
			-- same level, don't do anything
			return
		end

		-- finalize level first
		super_sam.finalize_level(player)
	end

	-- shift to next level
	super_sam.start_level(player, nearest_level)
end

local function check_players_near_beacon(beacon_pos)
	pre_emerge_level(beacon_pos)
	for _, player in ipairs(minetest.get_connected_players()) do
		local distance = vector.distance(player:get_pos(), beacon_pos)
		if distance <= super_sam.beacon_teleport_distance then
			check_level_progress(player, beacon_pos)
		end
	end
end

function super_sam.capture_players_near_beacon(pos, radius)
	radius = radius or 2
	local pos1 = vector.subtract(pos, radius)
	local pos2 = vector.add(pos, radius)
	for _, beacon_pos in ipairs(minetest.find_nodes_in_area(pos1, pos2, {"super_sam:level_beacon"})) do
		check_players_near_beacon(beacon_pos)
	end
end

minetest.register_abm({
	label = "Level transfer/proceed beacon",
	nodenames = "super_sam:level_beacon",
	interval = 1,
	chance = 1,
	action = check_players_near_beacon
})

