

local coin_texture = "super_sam_items.png^[sheet:6x5:4,3"
super_sam_highscore.register_node(":super_sam:highscore", {
	description = "Highscore board",
	inventory_image = coin_texture,
	wield_image = coin_texture,
	tiles = {coin_texture},
	paramtype = "light",
	paramtype2 = "wallmounted",
	drawtype = "signlike",
	selection_box = { type = "wallmounted" },
	sunlight_propagates = true,
	walkable = false,
	groups = { cracky = 1 }
})