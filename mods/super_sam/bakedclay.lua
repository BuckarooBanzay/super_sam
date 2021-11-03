
local bakedclay = {
    ["white"] = {},
    ["terracotta_dark_green"] = {},
    ["yellow"] = {},
    ["black"] = {},
    ["natural"] = {},
    ["terracotta_brown"] = {},
    ["terracotta_dark_grey"] = {},
    ["dark_grey"] = {},
    ["terracotta_light_blue"] = {},
    ["dark_green"] = {},
    ["terracotta_white"] = {},
    ["pink"] = {},
    ["grey"] = {},
    ["terracotta_blue"] = {},
    ["magenta"] = {},
    ["brown"] = {},
    ["green"] = {},
    ["terracotta_violet"] = {},
    ["terracotta_magenta"] = {},
    ["terracotta_orange"] = {},
    ["terracotta_green"] = {},
    ["terracotta_cyan"] = {},
    ["terracotta_black"] = {},
    ["cyan"] = {},
    ["terracotta_red"] = {},
    ["blue"] = {},
    ["red"] = {},
    ["terracotta_pink"] = {},
    ["terracotta_yellow"] = {},
    ["terracotta_grey"] = {},
    ["violet"] = {},
    ["orange"] = {}
}

for name, def in pairs(bakedclay) do
    def.description = "Super sam '" .. name .. "' node"
    def.tiles = def.tiles or {"baked_clay_" .. name .. ".png"}
    def.groups = def.groups or { cracky = 1 }
    def.paramtype2 = "facedir"
    def.sounds = def.sounds or super_sam.node_sound_stone()

    minetest.register_node("super_sam:clay_" .. name, def)

    stairsplus:register_all("super_sam", "clay_" .. name, "super_sam:clay_" .. name, def)
end

