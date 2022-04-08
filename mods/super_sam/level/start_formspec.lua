local FORMNAME = "level_start_formspec"

local has_modgen = minetest.get_modpath("modgen")

function super_sam.show_level_start_formspec(pos, playername)
    if not minetest.check_player_privs(playername, "super_sam_builder") then
        return
    end

    local meta = minetest.get_meta(pos)

    local formspec = [[
        size[6,3.5;]
        field[0.2,0.5;6,1;required_lvl;Required level;]] .. meta:get_string("required_lvl") .. [[]

        field[0.2,1.5;1,1;tpx;Teleport;]] .. meta:get_int("tpx") .. [[]
        field[1.2,1.5;1,1;tpy;;]] .. meta:get_int("tpy") .. [[]
        field[2.2,1.5;1,1;tpz;;]] .. meta:get_int("tpz") .. [[]

        button_exit[0,2.5;6,1;save;Save]
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
        meta:set_string("required_lvl", fields.required_lvl or "<unknown>")

        if has_modgen then
            -- dispatch changes
            modgen.mark_changed(pos, pos)
        end
    end
end)