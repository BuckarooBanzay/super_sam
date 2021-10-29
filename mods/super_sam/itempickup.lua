
-- itemname -> list<callback>
local callbacks = {}

local function check_player_for_pickups(player)
    local pos = vector.add(player:get_pos(), {x=0, y=0.5, z=0})
    local objects = minetest.get_objects_inside_radius(pos, 1.5)

    for _, obj in ipairs(objects) do
        local is_player = obj.is_player and obj:is_player()
        local entity = obj:get_luaentity()

        if not is_player and entity.name == "super_sam:item" and entity.data then
            local itemname = entity.data.wield_item
            local list = callbacks[itemname] or {}
            for _, callback in ipairs(list) do
                callback(player, itemname)
                obj:remove()
            end
        end
    end
end

local function check_for_pickups()
    for _, player in ipairs(minetest.get_connected_players()) do
        check_player_for_pickups(player)
    end

    minetest.after(0.1, check_for_pickups)
end

check_for_pickups()

function super_sam.register_on_pickup(itemname, callback)
    local list = callbacks[itemname]
    if not list then
        list = {}
        callbacks[itemname] = list
    end

    table.insert(list, callback)
end

minetest.register_entity("super_sam:item", {
    initial_properties = {},
    static_save = false,
    on_activate = function(self, staticdata)
		self.object:set_armor_groups({punch_operable = 1})
		local data = minetest.deserialize(staticdata)
        self.data = data
        self.object:set_properties(data)
	end
})

-- Test code below

minetest.register_chatcommand("test", {
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            local pos = player:get_pos()
            minetest.add_entity(pos, "super_sam:item", minetest.serialize({
                visual = "wielditem",
                wield_item = "super_sam:coin",
                visual_size = { x=0.5, y=0.5 },
                automatic_rotate = 1
            }))
        end
    end
})

super_sam.register_on_pickup("super_sam:coin", function(player, itemname)
    print(player:get_player_name() .. " picked up: " .. itemname)
end)