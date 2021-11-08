

minetest.register_node("super_sam:lights_block", {
    description = "Light Block",
    tiles = {"super_sam_lights_block_glass.png^super_sam_lights_block_frame.png"},
    paramtype = "light",
    light_source = minetest.LIGHT_MAX,
    groups = {cracky = 1},
})

minetest.register_node("super_sam:lights_smallblock", {
    description = "Light Block (small)",
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-1/4, -1/2, -1/4, 1/4, 0, 1/4}
    },
    tiles = {
        "super_sam_lights_block_glass.png^super_sam_lights_block_frame.png",
        "super_sam_lights_block_glass.png^super_sam_lights_block_frame.png",
        "[combine:16x16:0,4=" ..
            "(super_sam_lights_block_glass.png^super_sam_lights_block_frame.png)"
    },
    use_texture_alpha = "opaque",
    paramtype = "light",
    paramtype2 = "facedir",
    sunlight_propagates = true,
    light_source = 12,
    groups = {cracky = 1}
})

minetest.register_node("super_sam:lights_lantern_f", {
    description = "Lantern floor",
    drawtype = "mesh",
    mesh = "super_sam_lights_lantern_f.obj",
    tiles = {
        "super_sam_lights_lantern_frame.png^super_sam_lights_lantern_glass.png",
        "super_sam_lights_metal_dark_32.png"
    },
    use_texture_alpha = "opaque",
    collision_box = {
        type = "fixed",
        fixed = {-3/16, -1/2, -3/16, 3/16, 1/16, 3/16}
    },
    selection_box = {
        type = "fixed",
        fixed = {-3/16, -1/2, -3/16, 3/16, 1/16, 3/16}
    },
    walkable = false,
    paramtype = "light",
    sunlight_propagates = true,
    light_source = 12,
    groups = {cracky = 1}
})

minetest.register_node("super_sam:lights_lantern_c", {
    description = "Lantern ceiling",
    drawtype = "mesh",
    mesh = "super_sam_lights_lantern_c.obj",
    tiles = {
        "super_sam_lights_lantern_frame.png^super_sam_lights_lantern_glass.png",
        "super_sam_lights_metal_dark_32.png"
    },
    use_texture_alpha = "opaque",
    collision_box = {
        type = "fixed",
        fixed = {-3/16, -1/16, -3/16, 3/16, 1/2, 3/16}
    },
    selection_box = {
        type = "fixed",
        fixed = {-3/16, 0, -3/16, 3/16, 1/2, 3/16}
    },
    walkable = false,
    paramtype = "light",
    sunlight_propagates = true,
    light_source = 12,
    groups = {cracky = 1},
})

minetest.register_node("super_sam:lights_lantern_w", {
    description = "Lantern wall",
    drawtype = "mesh",
    mesh = "super_sam_lights_lantern_w.obj",
    tiles = {
        "super_sam_lights_lantern_frame.png^super_sam_lights_lantern_glass.png",
        "super_sam_lights_metal_dark_32.png"
    },
    use_texture_alpha = "clip",
    collision_box = {
        type = "fixed",
        fixed = {-3/16, -1/4, -5/16, 3/16, 1/8, 3/16}
    },
    selection_box = {
        type = "fixed",
        fixed = {-3/16, -1/4, -5/16, 3/16, 1/8, 3/16}
    },
    walkable = false,
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    light_source = 12,
    groups = {cracky = 1},
})


minetest.register_node("super_sam:lights_oillamp", {
    description = "Vintage Oil Lamp",
    drawtype = "mesh",
    mesh = "super_sam_lights_oillamp.obj",
    tiles = {
        {
            name = "super_sam_lights_oil_flame.png",
            animation = {
                type = "sheet_2d",
                frames_w = 16,
                frames_h = 1,
                frame_length = 0.3
            }
        },
        "super_sam_lights_oillamp.png",
        "super_sam_lights_brass_32.png"
    },
    use_texture_alpha = "clip",
    collision_box = {
        type = "fixed",
        fixed = {-1/8, -1/2, -1/8, 1/8, 1/4, 1/8}
    },
    selection_box = {
        type = "fixed",
        fixed = {-1/8, -1/2, -1/8, 1/8, 1/4, 1/8}
    },
    walkable = false,
    paramtype = "light",
    sunlight_propagates = true,
    light_source = 8,
    groups = {cracky = 1}
})