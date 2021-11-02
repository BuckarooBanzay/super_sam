local function move_to_spawn(player)
    player:set_pos({ x=22.5, y=9.5, z=19.5 })
end

minetest.register_on_respawnplayer(move_to_spawn)
minetest.register_on_newplayer(move_to_spawn)