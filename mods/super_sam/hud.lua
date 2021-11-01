
local function setup_builder()
    -- TODO: debug stuff
end

-- player => { name => id }
local hud_data = {}

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
        position = { x = 0.5, y = 0.05 },
        text = "super_sam_items.png^[sheet:6x5:4,3",
        offset = {x = 0,   y = 0},
        alignment = { x = 1, y = 0},
        scale = {x = 2, y = 2}
    })

    data.score_text = player:hud_add({
        hud_elem_type = "text",
        position = { x = 0.5, y = 0.05 },
        number = 0xffffff,
        text = "1000x",
        offset = {x = 0,   y = 0},
        alignment = { x = -1, y = 0},
        scale = {x = 4, y = 4}
    })

    hud_data[player:get_player_name()] = data
end

minetest.register_on_joinplayer(function(player)
    if not minetest.check_player_privs(player, "super_sam_builder") then
        setup_builder(player)
    else
        setup_player(player)
    end
end)