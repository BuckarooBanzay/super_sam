
-- name => level
local current_levels = {}

-- coords

-- constants
local META_STARTPOS = "super_sam_last_startpos"

local lookdir_to_rad = {
    ["+x"] = math.pi / 2 * 3,
    ["-x"] = math.pi / 2,
    ["-z"] = math.pi,
    ["+z"] = 0
}

function super_sam.start_level(player, level)
    local meta = player:get_meta()
    local playername = player:get_player_name()

    local start_pos = vector.add(level.start, super_sam.player_offset)

    -- store current pos in case of logout/timeout
    meta:set_string(META_STARTPOS, minetest.pos_to_string(start_pos))

    minetest.log("action", "[super_sam] starting level '" .. level.name .. "' for player '" .. playername .. "'")

    -- set start position
    local distance = vector.distance(level.start, player:get_pos())
    if distance > super_sam.beacon_teleport_distance then
        -- only move player if he's too far away
        player:set_pos(start_pos)
    end

    -- set look dir, if set
    if level.lookdir ~= "" then
        -- center vertical look
        player:set_look_vertical(0)
        local rad = lookdir_to_rad[level.lookdir]
        if rad then
            player:set_look_horizontal(rad)
        end
    end

    -- set timer
    super_sam.set_time(playername, level.time)

    -- store current level
    current_levels[playername] = level

    -- update hud
    super_sam.update_player_hud(player)
end

function super_sam.get_current_level(player)
    local playername = player:get_player_name()
    return current_levels[playername]
end

function super_sam.finalize_level(player)
    local finished_level = super_sam.get_current_level(player)
    if not finished_level then
        -- nothing started, ignore
        return
    end

    local playername = player:get_player_name()
    local ppos = player:get_pos()

    -- register as finished
    super_sam.add_finished_level(player, finished_level.name)

    minetest.log("action", "[super_sam] finalizing current level for player '" .. playername .. "'")

    -- update score and highscore
    local coins = super_sam.get_coins(playername)
    super_sam.set_coins(playername, 0)

    -- convert coins and remaining time to score
    local remaining_time = super_sam.get_time(playername)
    super_sam.add_score(playername, (coins * 100) + (remaining_time * 10))
    super_sam.update_highscore(playername, super_sam.get_score(playername), current_levels[playername])

    -- effects
    minetest.sound_play({ name = "super_sam_cash", gain = 1.5 }, { to_player = playername }, true)
    minetest.add_particlespawner({
        amount = coins * 50,
        time = 1,
        -- floor
        minpos = vector.subtract(ppos, {x=5, y=1, z=5}),
        maxpos = vector.subtract(ppos, {x=-5, y=1, z=-5}),
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
    minetest.log("action", "[super_sam] aborting level for player '" .. playername .. "'")

    super_sam.set_coins(playername, 0)

    current_levels[playername] = nil
end

-- resets the level after too much damage or timeout
function super_sam.reset_level(player)
    local playername = player:get_player_name()
    local level = current_levels[playername]
    if not level then
        return
    end

    minetest.log("action", "[super_sam] resetting level for player '" .. playername .. "'")

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
        minpos = vector.subtract(ppos, {x=5, y=1, z=5}),
        maxpos = vector.subtract(ppos, {x=-5, y=1, z=-5}),
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

minetest.register_chatcommand("killme", {
    description = "Resets the current level",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        super_sam.reset_level(player)
        return true, "Level reset!"
    end
})
