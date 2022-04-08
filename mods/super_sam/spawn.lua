local function move_to_spawn(player)
    player:set_pos(super_sam.spawn_pos)
end

minetest.register_on_respawnplayer(move_to_spawn)
minetest.register_on_newplayer(move_to_spawn)