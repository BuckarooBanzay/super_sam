

local function check_player(player)
    local pos = player:get_pos()
    local objects = minetest.get_objects_inside_radius(pos, 2)
    for _, obj in ipairs(objects) do
        print(dump(obj))
        -- TODO: powerups.start_effect(player, effect_def)
        -- TODO: remove item if successfully started
    end
end

local function check()
    for _, player in ipairs(minetest.get_connected_players()) do
        check_player(player)
    end
    -- periodic check
    minetest.after(0.5, check)
end

check()