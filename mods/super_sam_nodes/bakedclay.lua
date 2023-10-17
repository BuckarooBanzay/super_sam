
local bakedclay = {
    ["white"] = {},
    ["yellow"] = {},
    ["black"] = {},
    ["natural"] = {},
    ["dark_grey"] = {},
    ["dark_green"] = {},
    ["pink"] = {},
    ["grey"] = {},
    ["magenta"] = {},
    ["brown"] = {},
    ["green"] = {},
    ["cyan"] = {},
    ["blue"] = {},
    ["red"] = {},
    ["violet"] = {},
    ["orange"] = {}
}

for name, def in pairs(bakedclay) do
    def.description = "Super sam '" .. name .. "' node"
    def.tiles = def.tiles or {"baked_clay_" .. name .. ".png"}
    def.groups = def.groups or { cracky = 1 }
    def.paramtype2 = "facedir"
    def.sounds = def.sounds or super_sam_nodes.node_sound_stone()

    minetest.register_node(":super_sam:clay_" .. name, def)

    stairsplus:register_all("super_sam", "clay_" .. name, "super_sam:clay_" .. name, def)
end
