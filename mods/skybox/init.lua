
minetest.register_on_joinplayer(function(player)
  player:set_clouds({ density=0 })
  player:set_sky({r=0, g=0, b=0}, "skybox", {
    "blizzard_up.jpg^[transformR270",
    "blizzard_dn.jpg^[transformR90",
    "blizzard_ft.jpg",
    "blizzard_bk.jpg",
    "blizzard_lf.jpg",
    "blizzard_rt.jpg"
  })
end)
