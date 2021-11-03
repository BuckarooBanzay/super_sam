
local scores = {}

function super_sam.set_score(name, score)
    scores[name] = score
end

function super_sam.get_score(name)
    return scores[name] or 0
end

function super_sam.add_score(name, score)
    scores[name] = (scores[name] or 0) + score
end

super_sam.register_on_pickup("super_sam:coin", function(player)
    local playername = player:get_player_name()
    super_sam.add_score(playername, 1)
    super_sam.update_player_hud(player)
    minetest.sound_play({ name = "super_sam_coin", gain = 0.3 }, { to_player = playername }, true)
end)