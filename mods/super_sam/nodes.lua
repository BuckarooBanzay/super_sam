

local nodes = {
    ["brick"] = { tiles={"default_brick.png^[transformFX", "default_brick.png"} },
    ["cobble"] = {},
    ["stone"] = {},
    ["stone_block"] = {},
    ["stone_brick"] = {},
    ["desert_sandstone"] = {},
    ["desert_sandstone_block"] = {},
    ["desert_sandstone_brick"] = {},
    ["desert_stone"] = {},
    ["desert_stone_block"] = {},
    ["desert_stone_brick"] = {},
    ["dirt"] = {},
    ["grass"] = {},
    ["obsidian_block"] = {},
    ["obsidian_brick"] = {},
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

    minetest.register_node("super_sam:" .. name, def)
end

