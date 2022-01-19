local has_worldedit = minetest.get_modpath("worldedit")

local function update_formspec(meta)
    local formspec = [[
        size[6,4.5;]
        field[0.2,0.5;3,1;name;Name;${name}]
        field[3.2,0.5;3,1;time;Time;${time}]

        field[0.2,1.5;1,1;xplus;X+;${xplus}]
        field[1.2,1.5;1,1;yplus;Y+;${yplus}]
        field[2.2,1.5;1,1;zplus;Z+;${zplus}]

        field[0.2,2.5;1,1;xminus;X-;${xminus}]
        field[1.2,2.5;1,1;yminus;Y-;${yminus}]
        field[2.2,2.5;1,1;zminus;Z-;${zminus}]

        button_exit[0,3.5;6,1;save;Save]
    ]]

    if has_worldedit then
        -- add WE buttons
        formspec = formspec .. "button_exit[3,1.15;3,1;we_get;From WE-Pos]"
        formspec = formspec .. "button_exit[3,2.15;3,1;we_mark;Mark WE-Pos]"
    end
    meta:set_string("formspec", formspec);
end


minetest.register_node("super_sam:level_beacon", {
    description = "Level beacon",
    tiles = {
        "super_sam_beacon_top.png",
        "super_sam_beacon_side.png"
    },
    groups = { cracky = 1 },
    on_receive_fields = function(pos, _, fields, sender)
        local playername = sender:get_player_name()
        if not minetest.check_player_privs(sender, "super_sam_builder") then
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

        local meta = minetest.get_meta(pos)

        if fields.save then
            meta:set_int("xplus", tonumber(fields.xplus) or 0)
            meta:set_int("yplus", tonumber(fields.yplus) or 0)
            meta:set_int("zplus", tonumber(fields.zplus) or 0)
            meta:set_int("xminus", tonumber(fields.xminus) or 0)
            meta:set_int("yminus", tonumber(fields.yminus) or 0)
            meta:set_int("zminus", tonumber(fields.zminus) or 0)

            meta:set_int("time", tonumber(fields.time) or 120)
            meta:set_string("name", fields.name or "<unknown>")
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
        update_formspec(meta)
    end,
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)

        -- position offsets
        meta:set_int("xplus", 0)
		meta:set_int("yplus", 0)
		meta:set_int("zplus", 0)
        meta:set_int("xminus", 0)
        meta:set_int("yminus", 0)
        meta:set_int("zminus", 0)

        meta:set_int("time", 120)
        meta:set_string("name", "My level")

        update_formspec(meta)
        super_sam.register_level_beacon(pos)
    end,
})

minetest.register_lbm({
    label = "Level beacon register",
    name = "super_sam:level_beacon",
    nodenames = "super_sam:level_beacon",
    run_at_every_load = true,
    action = super_sam.register_level_beacon
})
