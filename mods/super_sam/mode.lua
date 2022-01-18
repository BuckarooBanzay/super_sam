
local editor_privs = {
    "fly", "fast", "noclip", "debug"
}

-- returns true if in play mode
function super_sam.check_play_mode(player)
    local meta = player:get_meta()
    local mode = meta:get_string("super_sam_mode")
    return mode == "" or mode == "play"
end

-- play mode
function super_sam.set_play_mode(player)
    local playername = player:get_player_name()

    -- clear inventory items
    local inv = player:get_inventory()
    local main_inv = inv:get_list("main")
    for i in ipairs(main_inv) do
        main_inv[i] = ""
    end
    inv:set_list("main", main_inv)

    -- restrict hud
    player:hud_set_flags({
        hotbar = false,
        wielditem = false,
        minimap = false,
        minimap_radar = false
    })

    -- revoke privs
    local privs = minetest.get_player_privs(playername)
    for _, name in pairs(editor_privs) do
        privs[name] = nil
    end
    minetest.set_player_privs(playername, privs)

    -- TODO: search nearest/last level
end

-- editor mode
function super_sam.set_edit_mode(player)
    local playername = player:get_player_name()

    -- abort level (if started)
    super_sam.abort_level(player)

    -- add editor items to inv
    local inv = player:get_inventory()
    local main_inv = inv:get_list("main")
    main_inv[1] = "super_sam:editor"
    inv:set_list("main", main_inv)

    -- toggle hud items
    player:hud_set_flags({
        hotbar = true,
        wielditem = true,
        minimap = true,
        minimap_radar = true
    })

    -- reset time and stats
    super_sam.set_time(playername, nil)
    super_sam.set_coins(playername, 0)
    super_sam.set_score(playername, 0)

    -- grant privs
    local privs = minetest.get_player_privs(playername)
    for _, name in pairs(editor_privs) do
        privs[name] = true
    end
    minetest.set_player_privs(playername, privs)
end

-- restore previous mode on join
minetest.register_on_joinplayer(function(player)
    local meta = player:get_meta()
    local mode = meta:get_string("super_sam_mode")

    if mode == "edit" then
        super_sam.set_edit_mode(player)
    else
        super_sam.set_play_mode(player)
    end
end)

-- toggle command, requires the "super_sam_builder" priv
minetest.register_chatcommand("mode", {
    params = "[edit|play]",
    description = "Switch between edit and play mode",
    privs = { super_sam_builder=true },
    func = function(name, mode)
        local player = minetest.get_player_by_name(name)
        local meta = player:get_meta()
        meta:set_string("super_sam_mode", mode)

        if mode == "play" then
            super_sam.set_play_mode(player)
            return true, "Switched to play mode"

        elseif mode == "edit" then
            -- abort level
            super_sam.set_edit_mode(player)
            return true, "Switched to editor mode"

        else
            return true, "Invalid mode: '" .. mode .. "'"

        end
    end
})