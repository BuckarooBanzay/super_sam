
-- https://github.com/minetest/minetest_game/blob/master/mods/fire/init.lua
minetest.register_node("super_sam:flame", {
    description = "Super sam 'fire' node",
	drawtype = "firelike",
	tiles = {{
		name = "super_sam_flame_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1
		}}
	},
	inventory_image = "super_sam_flame.png",
	paramtype = "light",
	light_source = 13,
	walkable = false,
	sunlight_propagates = true,
	damage_per_second = 1,
	groups = { cracky = 1 },
	drop = ""
})
