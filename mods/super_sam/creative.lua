local function is_creative(player)
    return minetest.check_player_privs(player, {super_sam_builder = true})
end


-- Unlimited node placement
minetest.register_on_placenode(function(_, _, placer)
	if placer and placer:is_player() then
		return is_creative(placer)
	end
end)

-- Don't pick up if the item is already in the inventory
local old_handle_node_drops = minetest.handle_node_drops
function minetest.handle_node_drops(pos, drops, digger)
	if not digger or not digger:is_player() or
		not is_creative(digger:get_player_name()) then
		return old_handle_node_drops(pos, drops, digger)
	end
	local inv = digger:get_inventory()
	if inv then
		for _, item in ipairs(drops) do
			if not inv:contains_item("main", item, true) then
				inv:add_item("main", item)
			end
		end
	end
end