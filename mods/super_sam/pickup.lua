
-- itemname -> callback()
local callbacks = {}

local function check_player_for_pickups(player)
    local pos = player:get_pos()
    local list = minetest.get_objects_inside_radius(pos, 1)

    for _, obj in ipairs(list) do
        local is_player = obj.is_player and obj:is_player()

        if not is_player then
            print(dump(obj:get_entity_name())) -- __builtin:item
            print(dump(obj:get_luaentity())) -- { itemstring = "super_sam:desert_sandstone_brick 91" }
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