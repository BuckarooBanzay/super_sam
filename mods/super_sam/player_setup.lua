
-- set the mario skin on join
minetest.register_on_joinplayer(function(player, last_login)
    player_api.set_textures(player, {"sam_mario_skin.png"})
    player:set_properties({
        hp_max = super_sam.max_hp
    })
    player:set_physics_override({
        speed = 1.8
    })

    if not last_login then
        -- show intro
        super_sam.show_intro(player:get_player_name())
        -- move to first level
        player:set_pos({ x=23, y=9.5, z=20 })
    end
end)