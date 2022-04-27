
minetest.register_node("super_sam_ambience:sound_beacon", {
	description = "Sound beacon",
	tiles = {
		"super_sam_ambience_node.png"
	},
	groups = { cracky = 1 },
	on_rightclick = function(pos, _, player)
		super_sam_ambience.show_formspec(pos, player:get_player_name())
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)

		-- position offsets
		meta:set_int("xplus", 0)
		meta:set_int("yplus", 0)
		meta:set_int("zplus", 0)
		meta:set_int("xminus", 0)
		meta:set_int("yminus", 0)
		meta:set_int("zminus", 0)

		meta:set_string("theme", "none")

		super_sam_ambience.register_node(pos)
	end,
})

minetest.register_lbm({
	label = "Ambience beacon register",
	name = "super_sam_ambience:sound_beacon",
	nodenames = "super_sam_ambience:sound_beacon",
	run_at_every_load = true,
	action = super_sam_ambience.register_node
})
