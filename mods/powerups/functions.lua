
-- playername -> effectname
local active_effects = {}

local function stop_effect(playername, effect_def)
    local player = minetest.get_player_by_name(playername)
    if player then
        -- call leave only if the player exists
        effect_def.leave(player)
    end
end

minetest.register_on_leaveplayer(function(player)
    local playername = player:get_player_name()
    local effectname = active_effects[playername]
    if not effectname then
        return
    end

    -- call leave-effect if the player leaves
    local effect_def = powerups.get_effect(effectname)
    effect_def.leave(player)
end)

-- starts an effect, returns true if started, false otherwise
function powerups.start_effect(player, effect_def)
    local playername = player:get_player_name()

    if active_effects[playername] then
        return false
    end

    -- call enter function
    effect_def.enter(player)

    -- prevent multiple effects on the same player
    active_effects[playername] = true

    -- defer stop
    minetest.after(effect_def.time, stop_effect, playername, effect_def)
    return true
end