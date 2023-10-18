
-- set the mario skin on join
minetest.register_on_joinplayer(function(player, last_login)
	-- mario skin
	player_api.set_textures(player, {"sam_mario_skin.png"})
	-- max hp override
	player:set_properties({
		hp_max = super_sam.max_hp
	})
	-- speed setting
	player:set_physics_override({
		speed = 1.8
	})

	if not last_login then
		-- show intro
		super_sam.show_intro(player:get_player_name())
		-- move to first level
		player:set_pos({ x=23, y=9.5, z=20 })
		player:set_look_horizontal(math.pi * 1.5)
	end
end)