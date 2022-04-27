
local spikes = {
    ["punji"] = {},
    ["steel"] = {},
    ["wood"] = {}
}

for name, def in pairs(spikes) do
    def.description = "Super sam '" .. name .. "' spike"
    def.tiles = def.tiles or {"super_sam_spike_" .. name .. ".png"}
    def.groups = def.groups or { cracky = 1 }
    def.drawtype = "firelike"
    def.walkable = false
    def.sunlight_propagates = true
    def.paramtype = "light"
    def.damage_per_second = 1

    minetest.register_node(":super_sam:spike_" .. name, def)
end

if minetest.get_modpath("i3") then
    local by = {}
    for k in pairs(spikes) do
        if k ~= "punji" then
            table.insert(by, k)
        end
    end
    i3.compress("super_sam:spike_punji", {
        replace = "punji",
        by = by
    })
end