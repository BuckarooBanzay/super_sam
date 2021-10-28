local function move_to_spawn(player)
    player:set_pos({ x=0, y=0.5, z=0 })
end

minetest.register_on_respawnplayer(move_to_spawn)
minetest.register_on_newplayer(move_to_spawn)