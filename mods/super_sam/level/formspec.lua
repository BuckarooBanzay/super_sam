local FORMNAME = "level_formspec"

local has_worldedit = minetest.get_modpath("worldedit")
local has_modgen = minetest.get_modpath("modgen")

function super_sam.show_level_formspec(pos, playername)
    if not minetest.check_player_privs(playername, "super_sam_builder") then
        return
    end

    local meta = minetest.get_meta(pos)

    local formspec = [[
        size[6,5.5;]
        field[0.2,0.5;3,1;name;Name;]] .. meta:get_string("name") .. [[]
        field[3.2,0.5;3,1;time;Time;]] .. meta:get_string("time") .. [[]

        field[0.2,1.5;1,1;xplus;X+;]] .. meta:get_int("xplus") .. [[]
        field[1.2,1.5;1,1;yplus;Y+;]] .. meta:get_int("yplus") .. [[]
        field[2.2,1.5;1,1;zplus;Z+;]] .. meta:get_int("zplus") .. [[]

        field[0.2,2.5;1,1;xminus;X-;]] .. meta:get_int("xminus") .. [[]
        field[1.2,2.5;1,1;yminus;Y-;]] .. meta:get_int("yminus") .. [[]
        field[2.2,2.5;1,1;zminus;Z-;]] .. meta:get_int("zminus") .. [[]

        field[0.2,3.5;1,1;tpx;Teleport;]] .. meta:get_int("tpx") .. [[]
        field[1.2,3.5;1,1;tpy;;]] .. meta:get_int("tpy") .. [[]
        field[2.2,3.5;1,1;tpz;;]] .. meta:get_int("tpz") .. [[]

        button_exit[0,4.5;6,1;save;Save]
    ]]

    if has_worldedit then
        -- add WE buttons
        formspec = formspec .. "button_exit[3,1.15;3,1;we_get;From WE-Pos]"
        formspec = formspec .. "button_exit[3,2.15;3,1;we_mark;Mark WE-Pos]"
    end

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

    -- get bounds from WE markers
    if fields.we_get and worldedit.pos1[playername] and worldedit.pos2[playername] then
        local pos1, pos2 = worldedit.sort_pos(worldedit.pos1[playername], worldedit.pos2[playername])
        fields.xminus = pos.x - pos1.x
        fields.yminus = pos.y - pos1.y
        fields.zminus = pos.z - pos1.z
        fields.xplus = pos2.x - pos.x
        fields.yplus = pos2.y - pos.y
        fields.zplus = pos2.z - pos.z
        fields.save  = true
    end


    if fields.save then
        meta:set_int("xplus", tonumber(fields.xplus) or 0)
        meta:set_int("yplus", tonumber(fields.yplus) or 0)
        meta:set_int("zplus", tonumber(fields.zplus) or 0)
        meta:set_int("xminus", tonumber(fields.xminus) or 0)
        meta:set_int("yminus", tonumber(fields.yminus) or 0)
        meta:set_int("zminus", tonumber(fields.zminus) or 0)
        meta:set_int("tpx", tonumber(fields.tpx) or 0)
        meta:set_int("tpy", tonumber(fields.tpy) or 0)
        meta:set_int("tpz", tonumber(fields.tpz) or 0)

        meta:set_int("time", tonumber(fields.time) or 120)
        meta:set_string("name", fields.name or "<unknown>")

        -- backward compat: clear formspec field on node-meta
        meta:set_string("formspec", nil)

        if has_modgen then
            -- dispatch changes
            modgen.mark_changed(pos, pos)
        end
    end

    -- mark bounds with WE markers
    if fields.we_mark then
        worldedit.pos1[playername] = {
            x = pos.x - meta:get_int("xminus"),
            y = pos.y - meta:get_int("yminus"),
            z = pos.z - meta:get_int("zminus")
        }
        worldedit.pos2[playername] = {
            x = pos.x + meta:get_int("xplus"),
            y = pos.y + meta:get_int("yplus"),
            z = pos.z + meta:get_int("zplus")
        }
        worldedit.mark_pos1(playername)
        worldedit.mark_pos2(playername);
    end

    super_sam.register_level_beacon(pos)
end)