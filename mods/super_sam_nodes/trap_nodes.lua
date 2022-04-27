
local trap_nodes = {
    { mod = "super_sam", name = "stone" },
    { mod = "super_sam", name = "dirt" }
}

for _, trap_node in ipairs(trap_nodes) do
    local plain_nodename = trap_node.mod .. ":" .. trap_node.name
    local plain_def = minetest.registered_nodes[plain_nodename]
    assert(plain_def, "node not found: " .. plain_nodename)

    local def = table.copy(plain_def)
    def.description = "Super sam trap '" .. trap_node.name .. "' node"
    def.walkable = false
    for i, tile in ipairs(def.tiles) do
        def.tiles[i] = tile .. "^moreblocks_trap_box.png"
    end

    minetest.register_node(":super_sam:" .. trap_node.name .. "_trap", def)
end

if minetest.get_modpath("i3") then
    i3.compress("super_sam:stone_trap", {
        replace = "stone",
        by = {"dirt"}
    })
end