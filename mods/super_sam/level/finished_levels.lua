
--[[
format (serialized in json):

def = {
	["s01e01"] = true,
	["s01e02"] = true
}
--]]

local META_FINISHED_LEVELS = "super_sam_finished_levels"

local cache = {}

local function load(player)
	local playername = player:get_player_name()
	if cache[playername] then
		return cache[playername]
	end

	local meta = player:get_meta()
	local json = meta:get_string(META_FINISHED_LEVELS)
	if json == "" then
		return {}
	else
		return minetest.parse_json(json) or {}
	end
end

local function save(player, levels)
	local playername = player:get_player_name()
	local meta = player:get_meta()
	meta:set_string(META_FINISHED_LEVELS, minetest.write_json(levels))
	cache[playername] = levels
end

function super_sam.clear_finished_levels(player)
	save(player, {})
end

function super_sam.add_finished_level(player, levelname)
	local levels = load(player)
	if not levels[levelname] then
		levels[levelname] = true
		save(player, levels)
	end
end

function super_sam.has_finished_level(player, levelname)
	local levels = load(player)
	return levels[levelname]
end

minetest.register_chatcommand("levels", {
	description = "Lists the finished levels",
	privs = { super_sam_builder=true },
	func = function(name)
		local player = minetest.get_player_by_name(name)
		local levels = load(player)
		local msg = "Finished levels: "
		for k in pairs(levels) do
			msg = msg .. k .. " "
		end
		return true, msg
	end
})

minetest.register_chatcommand("levels_clear", {
	description = "Clears the list of finished levels",
	privs = { super_sam_builder=true },
	func = function(name)
		local player = minetest.get_player_by_name(name)
		super_sam.clear_finished_levels(player)
		return true, "Cleared all finished levels"
	end
})