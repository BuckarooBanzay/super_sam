
minetest.register_on_joinplayer(function(player)
    -- skybox / clouds
	player:set_clouds({ density=0 })

	if player.set_sun then
		-- new format
		player:set_sun({
			visible = false,
			sunrise_visible = false
		})
		player:set_moon({
			visible = false
		})
		player:set_sky({
			base_color = "#000000",
			clouds = false,
			type = "skybox",
			textures = {
				"arid2_up.jpg^[transformR270",
				"arid2_dn.jpg^[transformR90",
				"arid2_ft.jpg",
				"arid2_bk.jpg",
				"arid2_lf.jpg",
				"arid2_rt.jpg"
			}
		})
	else
		-- legacy format
		player:set_sky({r=0, g=0, b=0}, "skybox", {
			"arid2_up.jpg^[transformR270",
			"arid2_dn.jpg^[transformR90",
			"arid2_ft.jpg",
			"arid2_bk.jpg",
			"arid2_lf.jpg",
			"arid2_rt.jpg"
		})
	end

end)