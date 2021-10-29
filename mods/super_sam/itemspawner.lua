
minetest.register_node("super_sam:item_spawner", {
    description = "Item spawner",
    tiles = {"super_sam_items.png^[sheet:6x5:3,2"},
    groups = { cracky = 1 }
    -- TODO: spawn config
})

minetest.register_lbm({
    label = "Item spawner trigger",
    name = "super_sam:item_spawner",
    nodenames = "super_sam:item_spawner",
    run_at_every_load = true,
    action = function(pos)
        local item_pos = vector.add(pos, {x=0, y=2, z=0})
        minetest.add_entity(item_pos, "super_sam:item", minetest.serialize({
            visual = "wielditem",
            wield_item = "super_sam:coin",
            visual_size = { x=0.5, y=0.5 },
            automatic_rotate = 1
        }))
    end
})