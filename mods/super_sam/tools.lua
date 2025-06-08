
local default_caps = {
	times={
		[1] = 0.1,
		[2] = 0.1,
		[3] = 0.1
	},
	uses = -1,
	maxlevel = 1
}

minetest.register_tool("super_sam:edit_hand", {
	description = "Edit hand",
	inventory_image = "blank.png",
	range = 32,
	groups = {
		not_in_creative_inventory = 1
	},
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level=0,
		groupcaps={
			cracky = default_caps,
			choppy = default_caps,
			oddly_breakable_by_hand = default_caps
		}
	}
})