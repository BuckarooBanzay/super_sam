local FORMNAME = "highscore_edit_formspec"

local function show_formspec(pos, playername)
	if not minetest.check_player_privs(playername, "super_sam_builder") then
		return
	end

	local meta = minetest.get_meta(pos)
	local formspec = [[
		size[6,2.5;]
		field[0.2,0.5;6,1;highscore_name;Highscore name;]] .. meta:get_string("highscore_name") .. [[]
		button_exit[0,1.5;6,1;save;Save]
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
		meta:set_string("highscore_name", fields.highscore_name or "")
	end
end)


function super_sam_highscore.register_node(name, def)
	def.on_punch = function(pos, _, player)
		local control = player:get_player_control()
		if control.sneak then
			return
		end
		local meta = minetest.get_meta(pos)
		local levelname = meta:get_string("highscore_name")
		local playername = player:get_player_name()
		super_sam_highscore.show_highscore_formspec(playername, levelname)
	end
	def.on_rightclick = function(pos, _, player)
		local playername = player:get_player_name()
		show_formspec(pos, playername)
	end

	minetest.register_node(name, def)
end