
-- itemname -> list<callback>
local item_callbacks = {}

local global_callbacks = {}

local function check_player_for_pickups(player)
	local pos = vector.add(player:get_pos(), {x=0, y=0.5, z=0})
	local objects = minetest.get_objects_inside_radius(pos, 1.5)

	for _, obj in ipairs(objects) do
		local is_player = obj.is_player and obj:is_player()
		local entity = obj:get_luaentity()

		if not is_player and entity.name == "super_sam:item" and entity.data then
			assert(entity.data.spawner_pos, "entity issue: no 'spawner_pos'")
			assert(entity.data.properties, "entity issue: no 'properties'")

			local itemname = entity.data.properties.wield_item
			local list = item_callbacks[itemname] or {}
			for _, callback in ipairs(list) do
				local result = callback(player, itemname)
				if result then
					-- check result table
					if result.remove then
						obj:remove()
					end
				else
					-- default: remove item
					obj:remove()
				end
			end

			for _, callback in ipairs(global_callbacks) do
				callback(player, entity.data.spawner_pos)
			end
		end
	end
end

local function check_for_pickups()
	for _, player in ipairs(minetest.get_connected_players()) do
		check_player_for_pickups(player)
	end

	minetest.after(0, check_for_pickups)
end
minetest.after(0, check_for_pickups)

-- per wield-item callback
function super_sam.register_on_item_pickup(itemname, callback)
	local list = item_callbacks[itemname]
	if not list then
		list = {}
		item_callbacks[itemname] = list
	end

	table.insert(list, callback)
end

-- global callback
function super_sam.register_on_pickup(callback)
	table.insert(global_callbacks, callback)
end
