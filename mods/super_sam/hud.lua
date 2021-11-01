
local function setup_builder()
    -- TODO: debug stuff
end

-- player => { name => id }
local hud_data = {}

local score_position = { x = 0.5, y = 0.05 }
local health_position = { x = 0.25, y = 0.05 }
local level_position = { x = 0.75, y = 0.05 }

local function setup_player(player)
    player:hud_set_flags({
        crosshair = true,
        hotbar = false,
        healthbar = false,
        wielditem = false,
        breathbar = false,
        minimap = false,
        minimap_radar = false
    })

    local data = {}

    data.score_img = player:hud_add({
        hud_elem_type = "image",
        position = score_position,
        text = "super_sam_items.png^[sheet:6x5:4,3",
        offset = {x = 0,   y = 0},
        alignment = { x = -1, y = 0},
        scale = {x = 2, y = 2}
    })

    data.score_text = player:hud_add({
        hud_elem_type = "text",
        position = score_position,
        number = 0xffffff,
        text = "x0",
        offset = {x = 0,   y = 0},
        alignment = { x = 1, y = 0},
        scale = {x = 2, y = 2}
    })

    data.health_img = player:hud_add({
        hud_elem_type = "image",
        position = health_position,
        text = "super_sam_items.png^[sheet:6x5:0,2",
        offset = {x = 0,   y = 0},
        alignment = { x = -1, y = 0},
        scale = {x = 2, y = 2}
    })

    data.health_text = player:hud_add({
        hud_elem_type = "text",
        position = health_position,
        number = 0xffffff,
        text = "x0",
        offset = {x = 0,   y = 0},
        alignment = { x = 1, y = 0},
        scale = {x = 2, y = 2}
    })

    data.level_text = player:hud_add({
        hud_elem_type = "text",
        position = level_position,
        number = 0xffffff,
        text = "Level 0-0",
        offset = {x = 0,   y = 0},
        alignment = { x = 1, y = 0},
        scale = {x = 2, y = 2}
    })

    hud_data[player:get_player_name()] = data
end

local function hud_update_player(player)
    local playername = player:get_player_name()
    local data = hud_data[playername]
    if data.score_text then
        player:hud_change(data.score_text, "text", "x" .. super_sam.get_score(playername))
    end
end

local function hud_update()
    for _, player in ipairs(minetest.get_connected_players()) do
        hud_update_player(player)
    end
    minetest.after(0.5, hud_update)
end

hud_update()

minetest.register_on_joinplayer(function(player)
    if not minetest.check_player_privs(player, "super_sam_builder") then
        setup_builder(player)
    else
        setup_player(player)
    end
end)