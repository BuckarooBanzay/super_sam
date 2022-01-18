
local sounds = {
    { name = "super_sam_ambience_1", duration = 119 },
    { name = "super_sam_ambience_2", duration = 100 },
    { name = "super_sam_ambience_3", duration = 130 }
}

-- playername -> handle
local handles = {}

local function check_sound(playername)
    local player = minetest.get_player_by_name(playername)
    local meta = player:get_meta()
    local state = meta:get_string("super_sam_ambience")
    if state == "off" then
        return
    end

    if handles[playername] then
        -- already playing
        return
    end

    local sound = sounds[math.random(#sounds)]
    local handle = minetest.sound_play({ name = sound.name, gain = 0.7 }, { to_player = playername })
    handles[playername] = handle
    minetest.after(sound.duration, function()
        if handles[playername] == handle then
            handles[playername] = nil
            check_sound(playername)
        end
    end)
end

local function stop_sound(playername)
    local handle = handles[playername]
    if handle then
        minetest.sound_stop(handle)
        handles[playername] = nil
    end
end

-- check on join
minetest.register_on_joinplayer(function(player)
    check_sound(player:get_player_name())
end)

-- toggle command
minetest.register_chatcommand("ambience", {
    params = "[off|on]",
    description = "toggle ambience sound",
    func = function(name, state)
        local player = minetest.get_player_by_name(name)
        local meta = player:get_meta()
        meta:set_string("super_sam_ambience", state)

        if state == "on" then
            check_sound(name)
            return true, "Enabled ambience music"

        elseif state == "off" then
            stop_sound(name)
            return true, "Disabled ambience music"

        else
            return true, "Invalid state: '" .. state .. "'"

        end
    end
})