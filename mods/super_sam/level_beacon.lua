
local function update_formspec(meta)
    meta:set_string("formspec", [[
        size[4,4.5;]
        field[0.2,0.5;3,1;name;Name;${name}]
        field[3.2,0.5;1,1;time;Time;${time}]

        field[0.2,1.5;1,1;xplus;X+;${xplus}]
        field[1.2,1.5;1,1;yplus;Y+;${yplus}]
        field[2.2,1.5;1,1;zplus;Z+;${zplus}]

        field[0.2,2.5;1,1;xminus;X-;${xminus}]
        field[1.2,2.5;1,1;yminus;Y-;${yminus}]
        field[2.2,2.5;1,1;zminus;Z-;${zminus}]

        button_exit[0,3.5;4,1;save;Save]
    ]]);
end


minetest.register_node("super_sam:level_beacon", {
    description = "Level beacon",
    tiles = {
        "super_sam_beacon_top.png",
        "super_sam_beacon_side.png"
    },
    groups = { cracky = 1 },
    on_receive_fields = function(pos, _, fields, sender)
        if not minetest.check_player_privs(sender, "super_sam_builder") or not fields.save then
            return
        end

        local meta = minetest.get_meta(pos)
        meta:set_int("xplus", tonumber(fields.xplus) or 0)
        meta:set_int("yplus", tonumber(fields.yplus) or 0)
        meta:set_int("zplus", tonumber(fields.zplus) or 0)
        meta:set_int("xminus", tonumber(fields.xminus) or 0)
        meta:set_int("yminus", tonumber(fields.yminus) or 0)
        meta:set_int("zminus", tonumber(fields.zminus) or 0)

        meta:set_int("time", tonumber(fields.time) or 120)
        meta:set_string("name", fields.name or "<unknown>")

        super_sam.register_level(pos)
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
        super_sam.register_level(pos)
    end,
})

minetest.register_lbm({
    label = "Level beacon register",
    name = "super_sam:level_beacon",
    nodenames = "super_sam:level_beacon",
    run_at_every_load = true,
    action = super_sam.register_level
})
