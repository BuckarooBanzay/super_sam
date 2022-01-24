
-- "default" nodes
local nodes = {
    ["brick"] = {
        tiles= {
            "default_brick.png^[transformFX",
            "default_brick.png"
        }
    },
    ["cobble"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["stone"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["stone_block"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["stone_brick"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["desert_sandstone"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["desert_sandstone_block"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["desert_sandstone_brick"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["desert_stone"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["desert_stone_block"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["desert_stone_brick"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["dirt"] = {
        sounds = super_sam_nodes.node_sound_dirt()
    },
    ["grass"] = {
        sounds = super_sam_nodes.node_sound_dirt(),
        tiles = {
            "default_grass.png", "default_dirt.png", {
                name = "default_dirt.png^default_grass_side.png",
			    tileable_vertical = false
            }
        }
    },
    ["obsidian_block"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["obsidian_brick"] = {
        sounds = super_sam_nodes.node_sound_stone()
    },
    ["ice"] = {groups={slippery=3, cracky=1}},
    ["snow"] = {},
    ["glass"] = {
        tiles = {"default_glass.png", "default_glass_detail.png"},
        drawtype = "glasslike_framed_optional",
        use_texture_alpha = "clip",
        sunlight_propagates = true,
        paramtype = "light"
    },
}

for name, def in pairs(nodes) do
    def.description = "Super sam '" .. name .. "' node"
    def.tiles = def.tiles or {"default_" .. name .. ".png"}
    def.groups = def.groups or { cracky = 1 }

    minetest.register_node(":super_sam:" .. name, def)

    local stairsdef = table.copy(def)
    if #stairsdef.tiles > 1 and stairsdef.drawtype and stairsdef.drawtype:find("glass") then
        stairsdef.tiles = {stairsdef.tiles[1]}
        stairsdef.paramtype2 = nil
    end

    stairsplus:register_all("super_sam", name, "super_sam:" .. name, stairsdef)
end

-- special nodes

minetest.register_node(":super_sam:border", {
	description = "Border node",
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	groups = {cracky = 1}
})

-- ladder

minetest.register_node(":super_sam:ladder_steel", {
	description = "Steel Ladder",
	drawtype = "nodebox",
	tiles = {
        "default_ladder_steel.png",
        "default_ladder_steel.png",
        "default_steel_block.png",
        "default_steel_block.png",
        "default_steel_block.png",
        "default_steel_block.png"
    },
	inventory_image = "default_ladder_steel.png",
	wield_image = "default_ladder_steel.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
    node_box = {
        type = 'fixed',
        fixed = {
            {-0.375, -0.5, -0.5, -0.25, -0.375, 0.5}, -- strut_1
            {0.25, -0.5, -0.5, 0.375, -0.375, 0.5}, -- strut_2
            {-0.4375, -0.5, 0.3125, 0.4375, -0.375, 0.4375}, -- rung_1
            {-0.4375, -0.5, 0.0625, 0.4375, -0.375, 0.1875}, -- rung_2
            {-0.4375, -0.5, -0.1875, 0.4375, -0.375, -0.0625}, -- rung_3
            {-0.4375, -0.5, -0.4375, 0.4375, -0.375, -0.3125} -- rung_4
        }
    },
    selection_box = {
        type = 'wallmounted',
        wall_top = {-0.4375, 0.375, -0.5, 0.4375, 0.5, 0.5},
        wall_side = {-0.5, -0.5, -0.4375, -0.375, 0.5, 0.4375},
        wall_bottom = {-0.4375, -0.5, -0.5, 0.4375, -0.375, 0.5}
    },
	groups = {
        cracky = 1
    },
	sounds = super_sam_nodes.node_sound_metal()
})