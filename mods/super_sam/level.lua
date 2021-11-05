
-- name => def
local levels = {}

function super_sam.register_level(name, def)
    def.name = name
    levels[name] = def
end

function super_sam.get_level(name)
    return levels[name]
end

-- name => levelname
local current_levels = {}

function super_sam.start_level(player, level)
    local playername = player:get_player_name()

    -- set start position
    player:set_pos(level.start)

    -- set timer
    super_sam.set_time(playername, level.time)

    -- store current level
    current_levels[playername] = level.name

    -- update hud
    super_sam.update_player_hud(player)
end

function super_sam.get_current_level_name(player)
    local playername = player:get_player_name()
    return current_levels[playername]
end

function super_sam.finalize_level(player)
    -- convert coins to score
    local playername = player:get_player_name()
    local coins = super_sam.get_coins(playername)
    super_sam.set_coins(playername, 0)
    super_sam.add_score(playername, coins * 100)

    -- Clear time
    super_sam.set_time(playername, nil)

    -- Clear current level name
    current_levels[playername] = nil
end

function super_sam.abort_level(player)
    local playername = player:get_player_name()
    super_sam.set_coins(playername, 0)

    -- TODO: subtract health
    -- TODO: move to level start / full-restart
end


local function check_current_level()
    for playername, levelname in pairs(current_levels) do
        local player = minetest.get_player_by_name(playername)
        if not player then
            -- cleanup
            current_levels[playername] = nil
        else
            -- progress
            -- check if the player is near the finish position
            local level = super_sam.get_level(levelname)
            local ppos = player:get_pos()
            for nextlevelname, finishpos in pairs(level.finish) do
                local distance = vector.distance(ppos, finishpos)
                if distance < 3 then
                    super_sam.finalize_level(player)
                    -- TODO: next level
                    print("Would have moved to level: '" .. nextlevelname .. "'")
                end
            end
        end
    end

    minetest.after(0.5, check_current_level)
end
check_current_level()

minetest.register_chatcommand("start", {
    params = "<levelname>",
    description = "Start an arbitrary level",
    privs = { super_sam_builder=true },
    func = function(name, levelname)
        local level = super_sam.get_level(levelname)
        if not level then
            return false, "Level '" .. levelname .. "' not found"
        end

        local player = minetest.get_player_by_name(name)
        super_sam.start_level(player, level)
        return true, "Level '" .. levelname .. "' started"
    end
})