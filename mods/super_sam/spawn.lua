local function move_to_spawn(player)
    player:set_pos(super_sam.spawn_pos)
    player:set_look_horizontal(super_sam.spawn_look_direction)
end

minetest.register_on_respawnplayer(move_to_spawn)
minetest.register_on_newplayer(move_to_spawn)