
minetest.register_on_respawnplayer(function(player)
    super_sam.reset_level(player)
    return true
end)

super_sam.register_on_pickup("super_sam:heart", function(player)
    local playername = player:get_player_name()
    player:set_hp(math.min(super_sam.max_hp, player:get_hp() + 1), "set_hp")
    super_sam.update_player_hud(player)
    minetest.sound_play({ name = "super_sam_heart", gain = 0.7 }, { to_player = playername }, true)
end)

minetest.register_on_dieplayer(function(player)
    -- game over sound
    minetest.sound_play({ name = "super_sam_game_over", gain = 2 }, { to_player = player:get_player_name() }, true)
end)

minetest.register_on_player_hpchange(function(player, hp_change)
    local playername = player:get_player_name()
    minetest.log("action", "[super_sam] hp_change for player '" .. playername .. "' with change: " .. hp_change)
    super_sam.update_player_hud(player)

    if hp_change == (-20 + super_sam.max_hp) then
        -- special case: initial join and set_hp call for default hp, ignore
        return
    elseif hp_change < 0 then
        -- damage sound
        minetest.sound_play({ name = "super_sam_game_over", gain = 2 }, { to_player = playername }, true)
    end
end)