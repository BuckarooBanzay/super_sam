
local beacon_teleport_distance = 3

-- name => levelname
local current_levels = {}

function super_sam.start_level(player, level)
    -- store current pos in case of logout/timeout
    local meta = player:get_meta()
    meta:set_string("super_sam_last_startpos", minetest.pos_to_string(level.start))

    local playername = player:get_player_name()

    -- set start position
    local distance = vector.distance(level.start, player:get_pos())
    if distance > beacon_teleport_distance then
        -- only move player if he's too far away
        player:set_pos(level.start)
    end

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
    local ppos = player:get_pos()

    -- update score and highscore
    local coins = super_sam.get_coins(playername)
    super_sam.set_coins(playername, 0)
    super_sam.add_score(playername, coins * 100)
    super_sam.update_highscore(playername, super_sam.get_score(playername), current_levels[playername])

    -- effects
    minetest.sound_play({ name = "super_sam_cash", gain = 1.5 }, { to_player = playername }, true)
    minetest.add_particlespawner({
        amount = coins * 50,
        time = 1,
        -- floor
        minpos = vector.subtract(ppos, {x=3, y=1, z=3}),
        maxpos = vector.subtract(ppos, {x=-3, y=1, z=-3}),
        minvel = {x=0, y=2, z=0},
        maxvel = {x=0, y=4, z=0},
        minsize = 2,
        texture = "super_sam_items.png^[sheet:6x5:4,3"
    })

    -- Clear time
    super_sam.set_time(playername, nil)

    -- Clear current level name
    current_levels[playername] = nil
end

-- aborts the current level (used for edit mode)
function super_sam.abort_level(player)
    local playername = player:get_player_name()
    super_sam.set_coins(playername, 0)

    current_levels[playername] = nil
end

-- resets the level after too much damage or timeout
function super_sam.reset_level(player)
    local playername = player:get_player_name()
    local levelname = current_levels[playername]
    if not levelname then
        return
    end
    local level = super_sam.get_level_by_name(levelname)
    if not level then
        return
    end

    -- clear level data
    super_sam.abort_level(player)

    -- start level again
    super_sam.start_level(player, level)

    -- particle rain on respawn position
    local ppos = player:get_pos()
    minetest.add_particlespawner({
        amount = 350,
        time = 1,
        -- floor
        minpos = vector.subtract(ppos, {x=3, y=1, z=3}),
        maxpos = vector.subtract(ppos, {x=-3, y=1, z=-3}),
        minvel = {x=0, y=2, z=0},
        maxvel = {x=0, y=4, z=0},
        minsize = 2,
        texture = "super_sam_items.png^[sheet:6x5:4,2"
    })
end

minetest.register_on_leaveplayer(super_sam.reset_level)

minetest.register_on_joinplayer(function(player)
    if not super_sam.check_play_mode(player) then
        -- not in play mode
        return
    end
    local meta = player:get_meta()
    local last_startpos = meta:get_string("super_sam_last_startpos")
    if last_startpos ~= "" then
        player:set_pos(minetest.string_to_pos(last_startpos))
    end
end)

local function check_current_level()
    for _, player in ipairs(minetest.get_connected_players()) do
        local playername = player:get_player_name()
        local playmode = super_sam.check_play_mode(player)
        if playmode then
            local nearest_level = super_sam.get_nearest_level(player:get_pos(), beacon_teleport_distance)
            local current_level = current_levels[playername]

            if current_level and nearest_level and current_level ~= nearest_level.name then
                -- shift to next level
                minetest.log("action", "[super_sam] Shifting player '" .. playername ..
                    "' to level '" .. nearest_level.name .. "'")
                super_sam.finalize_level(player)
                super_sam.start_level(player, nearest_level)

            elseif not current_level and nearest_level then
                -- not in a level and regular player
                minetest.log("action", "[super_sam] Starting level '" .. nearest_level.name ..
                    "' for player '" .. playername .. "'")
                super_sam.start_level(player, nearest_level)

            elseif current_level then
                -- check bounds
                local level_def = super_sam.get_level_by_name(current_level)
                local ppos = player:get_pos()
                if ppos.x < level_def.bounds.min.x or
                    ppos.y < level_def.bounds.min.y or
                    ppos.z < level_def.bounds.min.z or
                    ppos.x > level_def.bounds.max.x or
                    ppos.y > level_def.bounds.max.y or
                    ppos.z > level_def.bounds.max.z then
                    minetest.chat_send_player(playername, "Outside the level-region, resetting...")
                    super_sam.reset_level(player)
                end
            end
        end
    end

    minetest.after(0.5, check_current_level)
end
minetest.after(0.5, check_current_level)

minetest.register_chatcommand("start", {
    params = "<levelname>",
    description = "Start an arbitrary level",
    privs = { super_sam_builder=true },
    func = function(name, levelname)
        local level = super_sam.get_level_by_name(levelname)
        if not level then
            return false, "Level '" .. levelname .. "' not found"
        end

        local player = minetest.get_player_by_name(name)
        super_sam.start_level(player, level)
        return true, "Level '" .. levelname .. "' started"
    end
})

minetest.register_chatcommand("killme", {
    description = "Resets the current level",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        super_sam.reset_level(player)
        return true, "Level reset!"
    end
})
