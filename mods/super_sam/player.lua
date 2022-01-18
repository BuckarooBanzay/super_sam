
-- set the mario skin on join
minetest.register_on_joinplayer(function(player)
    player_api.set_textures(player, {"sam_mario_skin.png"})
end)