
local hidden_nodenames = {}
local hideable_nodenames = {}

local hidden_to_visible_map = {}
local visible_to_hidden_map = {}

function super_sam.register_hidden_node(name)
	local hidden_name = name .. "_hidden"

	-- register names
	table.insert(hideable_nodenames, name)
	table.insert(hidden_nodenames, hidden_name)
	visible_to_hidden_map[name] = hidden_name
	hidden_to_visible_map[hidden_name] = name

	-- visible node
	local def = minetest.registered_nodes[name]

	-- hidden node
	local hidden_def = table.copy(def)
	hidden_def.groups = hidden_def.groups or {}
	hidden_def.groups.not_in_creative_inventory = 1
	hidden_def.drawtype = "airlike"
	hidden_def.paramtype = "light"
	hidden_def.sunlight_propagates = true
	hidden_def.pointable = false
	hidden_def.walkable = false
	hidden_def.diggable = false
	minetest.register_node(hidden_name, hidden_def)
end


minetest.register_chatcommand("show", {
	description = "Make hidden nodes visible in the nearby area",
	privs = { super_sam_builder=true },
	func = function(name)
		local player = minetest.get_player_by_name(name)
		local ppos = vector.round(player:get_pos())
		local pos1 = vector.subtract(ppos, 10)
		local pos2 = vector.add(ppos, 10)
		local poslist = minetest.find_nodes_in_area(pos1, pos2, hidden_nodenames)
		local count = 0
		for _, pos in ipairs(poslist) do
			local node = minetest.get_node(pos)
			node.name = hidden_to_visible_map[node.name]
			minetest.swap_node(pos, node)
			count = count + 1
		end
		return true, "Successfully shown " .. count .. " nodes"
	end
})

minetest.register_chatcommand("hide", {
	description = "Make visible nodes hidden in the nearby area",
	privs = { super_sam_builder=true },
	func = function(name)
		local player = minetest.get_player_by_name(name)
		local ppos = vector.round(player:get_pos())
		local pos1 = vector.subtract(ppos, 10)
		local pos2 = vector.add(ppos, 10)
		local poslist = minetest.find_nodes_in_area(pos1, pos2, hideable_nodenames)
		local count = 0
		for _, pos in ipairs(poslist) do
			local node = minetest.get_node(pos)
			node.name = visible_to_hidden_map[node.name]
			minetest.swap_node(pos, node)
			count = count + 1
		end
		return true, "Successfully hidden " .. count .. " nodes"
	end
})