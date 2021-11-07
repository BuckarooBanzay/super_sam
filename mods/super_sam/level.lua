
-- name => def
local levels = {}

function super_sam.get_level(name)
    return levels[name]
end

-- name => levelname
local current_levels = {}

local function register_level(pos)
    local meta = minetest.get_meta(pos)
    local level_def = {
        time = meta:get_int("time"),
        name = meta:get_string("name"),
        start = vector.add(pos, {x=0, y=0.5, z=0}),
        bounds = {
            { x=meta:get_int("xminus"), y=meta:get_int("yminus"), z=meta:get_int("zminus") },
            { x=meta:get_int("xplus"), y=meta:get_int("yplus"), z=meta:get_int("zplus") }
        }
    }

    levels[level_def.name] = level_def
end

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
            local ppos = player:get_pos()
            for other_levelname, other_level in pairs(levels) do
                local distance = vector.distance(ppos, other_level.start)
                if distance < 2 and other_levelname ~= levelname then
                    super_sam.finalize_level(player)
                    -- TODO: next level
                    print("Would have moved to level: '" .. other_levelname .. "'")
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

local function update_formspec(meta)
    meta:set_string("formspec", [[
        size[4,4.5;]
        field[0.2,0.5;3,1;name;Name;${name}]
        field[3.2,0.5;1,1;time;Time;${time}]

        field[0.2,1.5;1,1;xplus;X+;${xplus}]
        field[1.2,1.5;1,1;yplus;Y+;${yplus}]
        field[2.2,1.5;1,1;zplus;Z+;${zplus}]

        field[0.2,2.5;1,1;xminus;X-;${xminus}]
        field[1.2,2.5;1,1;yminus;Y-;${yminus}]
        field[2.2,2.5;1,1;zminus;Z-;${zminus}]

        button_exit[0,3.5;4,1;save;Save]
    ]]);
end

minetest.register_node("super_sam:level_beacon", {
    description = "Level beacon",
    tiles = {
        "super_sam_beacon_top.png",
        "super_sam_beacon_side.png"
    },
    groups = { cracky = 1 },
    on_receive_fields = function(pos, _, fields, sender)
        if not minetest.check_player_privs(sender, "super_sam_builder") or not fields.save then
            return
        end

        local meta = minetest.get_meta(pos)
        meta:set_int("xplus", tonumber(fields.xplus) or 0)
        meta:set_int("yplus", tonumber(fields.yplus) or 0)
        meta:set_int("zplus", tonumber(fields.zplus) or 0)
        meta:set_int("xminus", tonumber(fields.xminus) or 0)
        meta:set_int("yminus", tonumber(fields.yminus) or 0)
        meta:set_int("zminus", tonumber(fields.zminus) or 0)

        meta:set_int("time", tonumber(fields.time) or 120)
        meta:set_string("name", fields.name or "<unknown>")

        register_level(pos)
    end,
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)

        -- position offsets
        meta:set_int("xplus", 0)
		meta:set_int("yplus", 0)
		meta:set_int("zplus", 0)
        meta:set_int("xminus", 0)
        meta:set_int("yminus", 0)
        meta:set_int("zminus", 0)

        meta:set_int("time", 120)
        meta:set_string("name", "My level")

        update_formspec(meta)
        register_level(pos)
    end,
})

minetest.register_lbm({
    label = "Level beacon register",
    name = "super_sam:level_beacon",
    nodenames = "super_sam:level_beacon",
    run_at_every_load = true,
    action = register_level
})
