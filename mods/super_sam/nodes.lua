
-- "default" nodes
local nodes = {
    ["brick"] = {
        tiles= {
            "default_brick.png^[transformFX",
            "default_brick.png"
        }
    },
    ["cobble"] = {
        sounds = super_sam.node_sound_stone()
    },
    ["stone"] = {
        sounds = super_sam.node_sound_stone()
    },
    ["stone_block"] = {
        sounds = super_sam.node_sound_stone()
    },
    ["stone_brick"] = {
        sounds = super_sam.node_sound_stone()
    },
    ["desert_sandstone"] = {
        sounds = super_sam.node_sound_stone()
    },
    ["desert_sandstone_block"] = {
        sounds = super_sam.node_sound_stone()
    },
    ["desert_sandstone_brick"] = {
        sounds = super_sam.node_sound_stone()
    },
    ["desert_stone"] = {
        sounds = super_sam.node_sound_stone()
    },
    ["desert_stone_block"] = {
        sounds = super_sam.node_sound_stone()
    },
    ["desert_stone_brick"] = {
        sounds = super_sam.node_sound_stone()
    },
    ["dirt"] = {
        sounds = super_sam.node_sound_dirt()
    },
    ["grass"] = {
        sounds = super_sam.node_sound_dirt()
    },
    ["obsidian_block"] = {
        sounds = super_sam.node_sound_stone()
    },
    ["obsidian_brick"] = {
        sounds = super_sam.node_sound_stone()
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

    minetest.register_node("super_sam:" .. name, def)

    local stairsdef = table.copy(def)
    if #stairsdef.tiles > 1 and stairsdef.drawtype and stairsdef.drawtype:find("glass") then
        stairsdef.tiles = {stairsdef.tiles[1]}
        stairsdef.paramtype2 = nil
    end

    stairsplus:register_all("super_sam", name, "super_sam:" .. name, stairsdef)
end

-- special nodes

minetest.register_node("super_sam:border", {
	description = "Border node",
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	groups = {cracky = 1}
})