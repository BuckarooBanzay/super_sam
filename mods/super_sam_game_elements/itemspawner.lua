
-- playername -> meta_as_table
local last_placed = {}

local function set_default_values(meta, playername)
	-- default values
	meta:set_int("xoffset", 0)
	meta:set_int("yoffset", 2)
	meta:set_int("zoffset", 0)

	local inv = meta:get_inventory()
	inv:set_size("main", 1)

	-- check previous placement
	local last_meta = last_placed[playername]
	if last_meta then
		-- copy values from previous node
		meta:from_table(last_meta)
	end
end

local function add_item(pos)
	local meta = minetest.get_meta(pos)
	local x_offset = meta:get_int("xoffset")
	local y_offset = meta:get_int("yoffset")
	local z_offset = meta:get_int("zoffset")
	local inv = meta:get_inventory()
	local stack = inv:get_stack("main", 1)
	local item_name = stack:get_name()

	if not item_name or item_name == "" then
		return
	end

	local item_pos = vector.add(pos, {x=x_offset, y=y_offset, z=z_offset})
	super_sam.add_item_entity(item_pos, {
		spawner_pos = pos,
		properties = {
			visual = "wielditem",
			wield_item = item_name,
			visual_size = { x=0.5, y=0.5 },
			automatic_rotate = 1,
			pointable = false
		}
	})
end

local function remove_item(pos)
	local meta = minetest.get_meta(pos)
	local x_offset = meta:get_int("xoffset")
	local y_offset = meta:get_int("yoffset")
	local z_offset = meta:get_int("zoffset")
	local item_pos = vector.add(pos, {x=x_offset, y=y_offset, z=z_offset})
	local pos1 = vector.add(item_pos, 0.5)
	local pos2 = vector.subtract(item_pos, 0.5)

	super_sam.remove_item_entities(pos1, pos2)
end

local function refresh_item(pos)
	remove_item(pos)
	add_item(pos)
end

local function update_formspec(meta)
	meta:set_string("formspec", [[
		size[8,5.5;]
		field[0.2,0.5;1,1;xoffset;X Offset;${xoffset}]
		field[1.2,0.5;1,1;yoffset;Y Offset;${yoffset}]
		field[2.2,0.5;1,1;zoffset;Z Offset;${zoffset}]
		button_exit[6.1,0.2;2,1;save;Save]
		label[4,0.5;Item]
		list[context;main;5,0.2;1,1;]
		list[current_player;main;0,1.5;8,4;]
		listring[]
	]]);
end

super_sam.register_hidden_node(":super_sam:item_spawner", {
	description = "Item spawner",
	tiles = {"super_sam_items.png^[sheet:6x5:3,2"},
	groups = { cracky = 1 },
	on_receive_fields = function(pos, _, fields, sender)
		if not minetest.check_player_privs(sender, "super_sam_builder") or not fields.save then
			return
		end

		remove_item(pos)

		local meta = minetest.get_meta(pos)
		meta:set_int("xoffset", tonumber(fields.xoffset or "0"))
		meta:set_int("yoffset", tonumber(fields.yoffset or "2"))
		meta:set_int("zoffset", tonumber(fields.zoffset or "0"))

		local playername = sender:get_player_name()
		last_placed[playername] = meta:to_table()

		add_item(pos)
	end,
	after_place_node = function(pos, placer)
		local playername = placer:get_player_name()

		local meta = minetest.get_meta(pos)
		set_default_values(meta, playername)

		add_item(pos)
		update_formspec(meta)
	end,
	on_destruct = remove_item
})

minetest.register_alias("super_sam:item_spawner_hidden", "super_sam:item_spawner")



minetest.register_lbm({
	label = "Item spawner trigger",
	name = "super_sam_game_elements:item_spawner",
	nodenames = { "super_sam:item_spawner" },
	run_at_every_load = true,
	action = refresh_item
})

-- time-based item renewal
local collected_spawners = {}

super_sam.register_on_pickup(function(_, data)
	if data.spawner_pos then
		collected_spawners[minetest.pos_to_string(data.spawner_pos)] = os.time()
	end
end)

local function refresh_items()
	local now = os.time()
	for pos_str, time in pairs(collected_spawners) do
		if (time + 30) < now then
			-- time expired, refresh
			local pos = minetest.string_to_pos(pos_str)
			refresh_item(pos)
			collected_spawners[pos_str] = nil
		end
	end
	minetest.after(1, refresh_items)
end
refresh_items()