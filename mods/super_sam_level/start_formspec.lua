local FORMNAME = "level_start_formspec"
local has_mapsync = minetest.get_modpath("mapsync")

function super_sam_level.show_level_start_formspec(pos, playername)
	if not minetest.check_player_privs(playername, "super_sam_builder") then
		return
	end

	local meta = minetest.get_meta(pos)
	local selected_skybox_idx = 1

	local skybox = meta:get_string("skybox")
	if skybox == "" then
		skybox = "default"
	end
	local skybox_items = ""
	for i, name in ipairs(super_sam_skybox.get_names()) do
		skybox_items = skybox_items .. (i == 1 and "" or ",") .. name
		if name == skybox then
			selected_skybox_idx = i
		end
	end

	local formspec = [[
		size[6,6.5;]
		real_coordinates[true]
		field[0.5,0.5;5,1;required_lvl;Required level;]] .. meta:get_string("required_lvl") .. [[]

		field[0.5,2;1.5,1;tpx;Teleport;]] .. meta:get_int("tpx") .. [[]
		field[2,2;1.5,1;tpy;;]] .. meta:get_int("tpy") .. [[]
		field[3.5,2;1.5,1;tpz;;]] .. meta:get_int("tpz") .. [[]

		dropdown[0.5,3.5;5;skybox;]] .. skybox_items .. [[;]] .. selected_skybox_idx .. [[;false]

		button_exit[0.5,5;5,1;save;Save]
	]]

	minetest.show_formspec(playername,
		FORMNAME .. ";" .. minetest.pos_to_string(pos),
		formspec
	)
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
		meta:set_int("tpx", tonumber(fields.tpx) or 0)
		meta:set_int("tpy", tonumber(fields.tpy) or 0)
		meta:set_int("tpz", tonumber(fields.tpz) or 0)
		meta:set_string("skybox", fields.skybox)
		meta:set_string("required_lvl", fields.required_lvl or "")
	end

	if has_mapsync then
		mapsync.mark_changed(pos, pos)
	end
end)