local FORMNAME = "box_formspec"

local has_mapsync = minetest.get_modpath("mapsync")

local function show_formspec(pos, playername)
    if not minetest.check_player_privs(playername, "super_sam_builder") then
		return
	end

	local meta = minetest.get_meta(pos)

	local formspec = [[
		size[8,7;]

		field[0.2,0.5;2,1;maxvel;Max Speed;]] .. meta:get_string("maxvel") .. [[]
		field[2.2,0.5;2,1;minvel;Min Speed;]] .. meta:get_string("minvel") .. [[]
		field[4.2,0.5;2,1;regenerate;Regenerate;]] .. meta:get_string("regenerate") .. [[]
		button_exit[6,0.2;2,1;save;Save]

		list[context;main;0,1.2;8,1;]

        list[current_player;main;0,2.5;8,4;]
		listring[]
	]]

    minetest.show_formspec(playername, FORMNAME .. ";" .. minetest.pos_to_string(pos), formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	local pos = minetest.string_to_pos(parts[2])
	local meta = minetest.get_meta(pos)
	local playername = player:get_player_name()

	if not minetest.check_player_privs(playername, "super_sam_builder") then
		return
	end

	if fields.save then
		meta:set_string("maxvel", fields.maxvel)
		meta:set_string("minvel", fields.minvel)
		meta:set_string("regenerate", fields.regenerate)
	end

	if has_mapsync then
		mapsync.mark_changed(pos, pos)
	end
end)

minetest.register_node(":super_sam:box", {
	description = "Box",
	tiles = {"super_sam_items.png^[sheet:6x5:2,0"},
	groups = { cracky = 1 },
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)

		-- position offsets
		meta:set_string("maxvel", "(0,0,0)")
		meta:set_string("minvel", "(0,-1,0)")
		meta:set_string("regenerate", "15")

		local inv = meta:get_inventory()
		inv:set_size("main", 8)
	end,
    on_rightclick = function(pos, _, player)
		show_formspec(pos, player:get_player_name())
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