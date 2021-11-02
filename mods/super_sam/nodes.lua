
-- "default" nodes
local nodes = {
    ["brick"] = {tiles={"default_brick.png^[transformFX", "default_brick.png"} },
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