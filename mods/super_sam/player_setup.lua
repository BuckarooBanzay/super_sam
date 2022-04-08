
-- set the mario skin on join
minetest.register_on_joinplayer(function(player, last_login)
    -- mario skin
    player_api.set_textures(player, {"sam_mario_skin.png"})
    -- max hp override
    player:set_properties({
        hp_max = super_sam.max_hp
    })
    -- speed setting
    player:set_physics_override({
        speed = 1.8
    })
    -- skybox / clouds
    player:set_clouds({ density=0 })

    if player.set_sun then
        -- new format
        player:set_sun({
            visible = false,
            sunrise_visible = false
        })
        player:set_moon({
            visible = false
        })
        player:set_sky({
            base_color = "#000000",
            clouds = false,
            type = "skybox",
            textures = {
                "arid2_up.jpg^[transformR270",
                "arid2_dn.jpg^[transformR90",
                "arid2_ft.jpg",
                "arid2_bk.jpg",
                "arid2_lf.jpg",
                "arid2_rt.jpg"
            }
        })
    else
        -- legacy format
        player:set_sky({r=0, g=0, b=0}, "skybox", {
            "arid2_up.jpg^[transformR270",
            "arid2_dn.jpg^[transformR90",
            "arid2_ft.jpg",
            "arid2_bk.jpg",
            "arid2_lf.jpg",
            "arid2_rt.jpg"
        })
    end

    if not last_login then
        -- show intro
        super_sam.show_intro(player:get_player_name())
        -- move to first level
        player:set_pos({ x=23, y=9.5, z=20 })
        player:set_look_horizontal(math.pi * 1.5)
    end
end)