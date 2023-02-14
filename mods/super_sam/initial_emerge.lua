
-- emerge area before the player joins
minetest.register_on_mods_loaded(function()
    minetest.after(0, function()
        minetest.emerge_area(super_sam.spawn_pos, super_sam.spawn_pos)
    end)
end)