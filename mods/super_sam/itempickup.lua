
-- itemname -> callback()
local callbacks = {}

local function check_player_for_pickups(player)
    local pos = player:get_pos()
    local list = minetest.get_objects_inside_radius(pos, 1)

    for _, obj in ipairs(list) do
        local is_player = obj.is_player and obj:is_player()

        if not is_player then
            print(dump(obj:get_luaentity().data))
        end
    end
end

local function check_for_pickups()
    for _, player in ipairs(minetest.get_connected_players()) do
        check_player_for_pickups(player)
    end

    minetest.after(0.5, check_for_pickups)
end

check_for_pickups()

function super_sam.register_on_pickup(itemname, callback)
    callbacks[itemname] = callback
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