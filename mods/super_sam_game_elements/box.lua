local function update_formspec(meta)
	meta:set_string("formspec", [[
		size[8,7;]

		field[0.2,0.5;2,1;maxvel;Max Speed;${maxvel}]
		field[2.2,0.5;2,1;minvel;Min Speed;${minvel}]
		field[4.2,0.5;2,1;regenerate;Regenerate;${regenerate}]
		button_exit[6,0.2;2,1;save;Save]

		list[context;main;0,1.2;8,1;]

        list[current_player;main;0,2.5;8,4;]
		listring[]
	]]);
end

minetest.register_node(":super_sam:box", {
	description = "Box",
	tiles = {"super_sam_items.png^[sheet:6x5:2,0"},
	groups = { cracky = 1 },
    on_receive_fields = function(pos, _, fields, sender)
		if not minetest.check_player_privs(sender, "super_sam_builder") or not fields.save then
			return
		end

		local meta = minetest.get_meta(pos)
		meta:set_string("maxvel", fields.maxvel)
		meta:set_string("minvel", fields.minvel)
		meta:set_string("regenerate", fields.regenerate)
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)

		-- position offsets
		meta:set_string("maxvel", "(0,0,0)")
		meta:set_string("minvel", "(0,-1,0)")
		meta:set_string("regenerate", "15")

		local inv = meta:get_inventory()
		inv:set_size("main", 8)

		update_formspec(meta)
	end,
	on_timer = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack("main", 1)
		local item_name = stack:get_name()

		if not item_name or item_name == "" then
			return
		end

		-- TODO

		local interval = tonumber(meta:get_string("regenerate")) or 5
		local timer = minetest.get_node_timer(pos)
		timer:start(interval)
	end
})