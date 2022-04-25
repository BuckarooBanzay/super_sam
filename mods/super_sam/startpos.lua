-- constants
local META_STARTPOS = "super_sam_last_startpos"

function super_sam.set_player_startpos(player, pos)
    if not pos then
        pos = player:get_pos()
    end
    local meta = player:get_meta()
    meta:set_string(META_STARTPOS, minetest.pos_to_string(pos))
end

function super_sam.teleport_player_startpos(player)
    local meta = player:get_meta()
    local last_startpos = meta:get_string(META_STARTPOS)
    if last_startpos ~= "" then
        player:set_pos(minetest.string_to_pos(last_startpos))
    end
end

minetest.register_on_joinplayer(function(player)
    if not super_sam.check_play_mode(player) then
        -- not in play mode
        return
    end
    super_sam.teleport_player_startpos(player)
end)