
local function setup_builder()
    -- TODO: debug stuff
end

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
end

minetest.register_on_joinplayer(function(player)
    if minetest.check_player_privs(player, "super_sam_builder") then
        setup_builder(player)
    else
        setup_player(player)
    end
end)