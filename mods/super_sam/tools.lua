
minetest.register_tool("super_sam:edit_hand", {
	description = "Edit hand",
	inventory_image = "blank.png",
	range = 32,
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level=0,
		groupcaps={
			cracky = {
				times={ [1]=0.1 },
				uses = -1,
				maxlevel = 1
			},
			choppy = {
				times={ [2]=0.1 },
				uses = -1,
				maxlevel = 1
			}
		}
	}
})