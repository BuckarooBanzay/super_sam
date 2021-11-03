
local healths = {}

function super_sam.set_health(name, health)
    healths[name] = health
end

function super_sam.get_health(name)
    return healths[name] or 0
end

function super_sam.add_health(name, health, max)
    local sum = (healths[name] or 0) + health
    if max and sum > max then
        sum = max
    end
    healths[name] = sum
end

super_sam.register_on_pickup("super_sam:mushroom_1", function(player)
    local playername = player:get_player_name()
    super_sam.add_health(playername, 1, 3)
    super_sam.update_player_hud(player)
    -- TODO: sound
end)