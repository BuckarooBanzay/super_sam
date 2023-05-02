

mtt.validate_nodenames(minetest.get_modpath("super_sam") .. "/nodenames.txt")

mtt.emerge_area({x=0,y=0,z=0}, {x=48,y=48,z=48})

mtt.register("mod-deps", function(callback)
    assert(minetest.get_modpath("super_sam_highscore"))
    assert(minetest.get_modpath("super_sam_hud"))
    assert(minetest.get_modpath("super_sam_level"))
    assert(minetest.get_modpath("super_sam_ambience"))
    assert(minetest.get_modpath("super_sam_map"))
    assert(minetest.get_modpath("super_sam_nodes"))
    assert(minetest.get_modpath("super_sam_game_elements"))
    callback()
end)