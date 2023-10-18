
-- itemname -> list<callback>
local item_callbacks = {}

local global_callbacks = {}

minetest.register_entity(":super_sam:item", {
	initial_properties = {},
	static_save = false,
	on_activate = function(self, staticdata)
		self.object:set_armor_groups({punch_operable = 1})
		local data = minetest.deserialize(staticdata)
		self.data = data
		self.object:set_properties(data.properties)
		if data.velocity then
			self.object:set_velocity(data.velocity)
		end
		if data.acceleration then
			self.object:set_acceleration(data.acceleration)
		end
	end,
	on_step = function(self, _, moveresult)
		if not self.data.enable_physics then
			return
		end

		if moveresult.touching_ground and not moveresult.standing_on_object then
			self.object:set_velocity({ x=0, y=0, z=0 })
			self.data.enable_physics = false
		end
	end
})

function super_sam.add_item_entity(pos, data)
	minetest.add_entity(pos, "super_sam:item", minetest.serialize(data))
end

function super_sam.remove_item_entities(pos1, pos2)
	local objects = minetest.get_objects_in_area(pos1, pos2)
	for _, object in ipairs(objects) do
		local entity = object:get_luaentity()
		if entity and entity.name == "super_sam:item" then
			object:remove()
		end
	end
end

local function check_player_for_pickups(player)
	local pos = vector.add(player:get_pos(), {x=0, y=0.5, z=0})
	local objects = minetest.get_objects_inside_radius(pos, 1.5)

	for _, obj in ipairs(objects) do
		local is_player = obj.is_player and obj:is_player()
		local entity = obj:get_luaentity()

		if not is_player and entity.name == "super_sam:item" and entity.data then
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
				callback(player, entity.data)
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
