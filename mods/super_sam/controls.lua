
-- name => {callback(player, new_state)...}
local control_callbacks = {}

function super_sam.register_control(name, callback)
    local list = control_callbacks[name]
    if not list then
        list = {}
        control_callbacks[name] = list
    end
    table.insert(list, callback)
end

-- playername -> bits
local previous_state = {}

minetest.register_globalstep(function()
    for _, player in ipairs(minetest.get_connected_players()) do
        local playername = player:get_player_name()
        local control = player:get_player_control()
        local previous_control = previous_state[playername]
        if previous_control then
            -- check registered callbacks
            for control_name, callbacks in pairs(control_callbacks) do
                    if not previous_control[control_name] and control[control_name] then
                    -- false -> true
                    for _, callback in ipairs(callbacks) do
                        callback(player, true)
                    end
                elseif previous_control[control_name] and not control[control_name] then
                    -- true -> false
                    for _, callback in ipairs(callbacks) do
                        callback(player, false)
                    end
                end
            end
        end
        previous_state[playername] = control
    end
end)

minetest.register_on_leaveplayer(function(player)
    previous_state[player:get_player_name()] = nil
end)