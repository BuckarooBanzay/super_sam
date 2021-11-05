
-- name => def
local levels = {}

function super_sam.register_level(name, def)
    levels[name] = def
end

function super_sam.get_level(name)
    return levels[name]
end

--[[
-- playername => def
local player_levels = {}

function super_sam.player_set_level(player, name)
end

function super_sam.player_get_level(player)
end
--]]