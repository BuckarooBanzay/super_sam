
local healths = {}

local function check_for_death(name, health)
    if health < 0 then
        -- dead
        minetest.chat_send_player(name, "You died...")
        super_sam.set_health(name, 0)
        super_sam.reset_level(minetest.get_player_by_name(name))
    end
end

function super_sam.set_health(name, health)
    healths[name] = health
    check_for_death(name, health)
end

function super_sam.get_health(name)
    return healths[name] or 0
end

function super_sam.add_health(name, health)
    local max = 3
    local sum = (healths[name] or 0) + health
    if max and sum > max then
        sum = max
    end
    healths[name] = sum
    check_for_death(name, sum)
    return sum
end

super_sam.register_on_pickup("super_sam:heart", function(player)
    local playername = player:get_player_name()
    super_sam.add_health(playername, 1)
    super_sam.update_player_hud(player)
    minetest.sound_play({ name = "super_sam_heart", gain = 0.7 }, { to_player = playername }, true)
end)

super_sam.register_on_nodetouch("super_sam:lava_source", function(player)
    local playername = player:get_player_name()
    super_sam.add_health(playername, -1)
    super_sam.update_player_hud(player)
end)