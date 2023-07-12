
minetest.register_abm({
    label = "Lava effect",
    nodenames = {"super_sam:lava_source"},
    interval = 2,
    chance = 10,
    action = function(pos)
        minetest.add_particlespawner({
            amount = 1,
            time = 2,
            texture = "super_sam_white_pixel.png^[colorize:#ff0000:255]",
            minpos = vector.add(pos, { x=-0.5, y=0.5, z=0.5}),
            maxpos = vector.add(pos, 0.5),
            minvel = {x=0, y=4, z=0},
            maxvel = {x=0, y=7, z=0},
            minexptime = 0.2,
            maxexptime = 1,
            minsize = 0.2,
            maxsize = 1,
            collisiondetection = true,
            collision_removal = true,
            object_collision = true
        })
    end
})