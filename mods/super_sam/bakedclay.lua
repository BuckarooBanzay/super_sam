
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

    minetest.register_node("super_sam:clay_" .. name, def)
end

