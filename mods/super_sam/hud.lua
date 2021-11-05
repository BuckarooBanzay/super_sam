
-- player => { name => id }
local hud_data = {}

local health_position = { x = 0.2, y = 0.05 }
local coins_position = { x = 0.4, y = 0.05 }
local level_position = { x = 0.6, y = 0.05 }
local time_position = { x = 0.6, y = 0.08 }
local score_position = { x = 0.8, y = 0.05 }

local function restrict_player_hud(player)
    player:hud_set_flags({
        crosshair = true,
        hotbar = false,
        healthbar = false,
        wielditem = false,
        breathbar = false,
        minimap = false,
        minimap_radar = false
    })
end

local function setup_hud(player)
    local data = {}

    -- Score

    data.score_text = player:hud_add({
        hud_elem_type = "text",
        position = score_position,
        number = 0xffffff,
        text = "",
        offset = {x = 0,   y = 0},
        alignment = { x = 1, y = 0},
        scale = {x = 2, y = 2}
    })

    -- Time

    data.time_text = player:hud_add({
        hud_elem_type = "text",
        position = time_position,
        number = 0xffffff,
        text = "",
        offset = {x = 0,   y = 0},
        alignment = { x = 1, y = 0},
        scale = {x = 2, y = 2}
    })

    -- Coins

    data.coins_img = player:hud_add({
        hud_elem_type = "image",
        position = coins_position,
        text = "super_sam_items.png^[sheet:6x5:4,3",
        offset = {x = 0,   y = 0},
        alignment = { x = -1, y = 0},
        scale = {x = 2, y = 2}
    })

    data.coins_text = player:hud_add({
        hud_elem_type = "text",
        position = coins_position,
        number = 0xffffff,
        text = "",
        offset = {x = 0,   y = 0},
        alignment = { x = 1, y = 0},
        scale = {x = 2, y = 2}
    })

    -- Health

    data.health_img = player:hud_add({
        hud_elem_type = "image",
        position = health_position,
        text = "super_sam_heart.png",
        offset = {x = 0,   y = 0},
        alignment = { x = -1, y = 0},
        scale = {x = 2, y = 2}
    })

    data.health_text = player:hud_add({
        hud_elem_type = "text",
        position = health_position,
        number = 0xffffff,
        text = "",
        offset = {x = 0,   y = 0},
        alignment = { x = 1, y = 0},
        scale = {x = 2, y = 2}
    })

    -- Current level

    data.level_text = player:hud_add({
        hud_elem_type = "text",
        position = level_position,
        number = 0xffffff,
        text = "",
        offset = {x = 0,   y = 0},
        alignment = { x = 1, y = 0},
        scale = {x = 2, y = 2}
    })

    hud_data[player:get_player_name()] = data
end

function super_sam.update_player_hud(player)
    local playername = player:get_player_name()
    local data = hud_data[playername]
    if not data then
        return
    end

    if data.coins_text then
        player:hud_change(data.coins_text, "text", "x" .. super_sam.get_coins(playername))
    end
    if data.health_text then
        player:hud_change(data.health_text, "text", "x" .. super_sam.get_health(playername))
    end
    if data.score_text then
        -- TODO: 1000-separator
        player:hud_change(data.score_text, "text", "$ " .. super_sam.get_score(playername))
    end
    if data.level_text then
        local levelname = super_sam.get_current_level_name(player)
        player:hud_change(data.level_text, "text", "Level: '" .. (levelname or "<none>"))
    end
    if data.time_text then
        local time = super_sam.get_time(playername)
        player:hud_change(data.time_text, "text", "Time: " .. (time or "-"))
        if time and time > 60 then
            player:hud_change(data.time_text, "color", 0x00ff00)
        else
            player:hud_change(data.time_text, "color", 0xff0000)
        end
    end
end

local function update_hud()
    for _, player in ipairs(minetest.get_connected_players()) do
        super_sam.update_player_hud(player)
    end
    minetest.after(1, update_hud)
end

update_hud()

minetest.register_on_joinplayer(function(player)
    setup_hud(player)

    if not minetest.check_player_privs(player, "super_sam_builder") then
        restrict_player_hud(player)
    end

    super_sam.update_player_hud(player)
end)