
-- playername -> health-points
local healths = {}

-- playername -> os.time()
local last_change = {}

-- 2 seconds invincibility after health change
local cooldown = 2

local function check_for_death(name, health)
    if health < 0 then
        -- dead
        minetest.chat_send_player(name, "You died...")
        healths[name] = 0
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
    local dtime = os.time() - (last_change[name] or 0)
    if dtime <= cooldown then
        return
    end

    local max = 3
    local sum = (healths[name] or 0) + health
    if max and sum > max then
        sum = max
    end
    healths[name] = sum
    check_for_death(name, sum)
    last_change[name] = os.time()
    return sum
end

super_sam.register_on_pickup("super_sam:heart", function(player)
    local playername = player:get_player_name()
    super_sam.add_health(playername, 1)
    super_sam.update_player_hud(player)
    minetest.sound_play({ name = "super_sam_heart", gain = 0.7 }, { to_player = playername }, true)
end)

local damage_nodes = {
    "super_sam:lava_source",
    "super_sam:punji",
    "super_sam:steel",
    "super_sam:wood"
}

local damage_fn = function(player)
    local playername = player:get_player_name()
    super_sam.add_health(playername, -1)
    minetest.sound_play({ name = "super_sam_game_over", gain = 2 }, { to_player = playername }, true)
    super_sam.update_player_hud(player)
end

for _, nodename in ipairs(damage_nodes) do
    super_sam.register_on_nodetouch(nodename, damage_fn)
end