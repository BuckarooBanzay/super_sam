
local vines = {
    ["vine_end"] = { tiles = {"super_sam_vines_end.png"} },
    ["vine_middle"] = { tiles = {"super_sam_vines_middle.png"} }
}

for name, def in pairs(vines) do
    def.description = "Super sam '" .. name .. "' vine"
    def.groups = def.groups or { cracky = 1 }
    def.inventory_image = def.tiles[1]
	def.wield_image = def.tiles[1]
    def.drawtype = "plantlike"
	def.waving = 1
    def.paramtype = "light"
    def.paramtype2 = "wallmounted"
    def.drawtype = "signlike"
    def.climbable = true
    def.selection_box = { type = "wallmounted" }
	def.sunlight_propagates = true
	def.walkable = false

    minetest.register_node(":super_sam:" .. name, def)
end

if minetest.get_modpath("i3") then
    i3.compress("super_sam:vine_end", {
        replace = "_end",
        by = {"_middle"}
    })
end