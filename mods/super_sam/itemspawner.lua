

local function execute_item_spawning(pos)
    local meta = minetest.get_meta(pos)
    local x_offset = meta:get_int("x-offset")
    local y_offset = meta:get_int("y-offset")
    local z_offset = meta:get_int("z-offset")
    local inv = meta:get_inventory()
    local stack = inv:get_stack("main", 1)
    local item_name = stack:get_name()

    if not item_name or item_name == "" then
        return
    end

    local item_pos = vector.add(pos, {x=x_offset, y=y_offset, z=z_offset})
    minetest.add_entity(item_pos, "super_sam:item", minetest.serialize({
        visual = "wielditem",
        wield_item = item_name,
        visual_size = { x=0.5, y=0.5 },
        automatic_rotate = 1
    }))
end

local update_formspec = function(meta)
    meta:set_string("formspec", [[
        size[8,5.5;]
        field[0.2,0.5;1,1;xoffset;X Offset;${x-offset}]
        field[1.2,0.5;1,1;yoffset;Y Offset;${y-offset}]
        field[2.2,0.5;1,1;zoffset;Z Offset;${z-offset}]
        button_exit[6.1,0.2;2,1;save;Save]
        label[4,0.5;Item]
        list[context;main;5,0.2;1,1;]
        list[current_player;main;0,1.5;8,4;]
        listring[]
    ]]);
end

minetest.register_node("super_sam:item_spawner", {
    description = "Item spawner",
    tiles = {"super_sam_items.png^[sheet:6x5:3,2"},
    groups = { cracky = 1 },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)

        -- position offsets
        meta:set_int("x-offset", 0)
		meta:set_int("y-offset", 2)
		meta:set_int("z-offset", 0)

		local inv = meta:get_inventory()
		inv:set_size("main", 1)

        update_formspec(meta)
    end
})

minetest.register_lbm({
    label = "Item spawner trigger",
    name = "super_sam:item_spawner",
    nodenames = "super_sam:item_spawner",
    run_at_every_load = true,
    action = execute_item_spawning
})