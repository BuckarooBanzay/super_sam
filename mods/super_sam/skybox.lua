
minetest.register_on_joinplayer(function(player)
    player:set_clouds({ density=0 })
    player:set_sky({r=0, g=0, b=0}, "skybox", {
        "arid2_up.jpg^[transformR270",
        "arid2_dn.jpg^[transformR90",
        "arid2_ft.jpg",
        "arid2_bk.jpg",
        "arid2_lf.jpg",
        "arid2_rt.jpg"
    })
  end)