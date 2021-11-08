
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

    minetest.register_node("super_sam:" .. name, def)
end