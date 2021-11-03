
-- nodename -> list<callback>
local callbacks = {}

local function check_player(player)
    local eye_offset = player:get_eye_offset()
    local pos = vector.add(player:get_pos(), eye_offset)
    local node = minetest.get_node(vector.round(pos))
    if not node or not node.name then
        return
    end

    local list = callbacks[node.name] or {}
    for _, callback in ipairs(list) do
        callback(player, node.name)
    end
end

local function check()
    for _, player in ipairs(minetest.get_connected_players()) do
        check_player(player)
    end

    minetest.after(0.1, check)
end

check()

function super_sam.register_on_nodetouch(nodename, callback)
    local list = callbacks[nodename]
    if not list then
        list = {}
        callbacks[nodename] = list
    end

    table.insert(list, callback)
end