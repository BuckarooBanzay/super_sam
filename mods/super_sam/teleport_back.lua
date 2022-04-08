local META_STARTPOS = "super_sam_last_startpos"

local function worker()
    for _, player in ipairs(minetest.get_connected_players()) do
        local ppos = player:get_pos()
        if ppos.y < -100 then
            -- player fell into the abyss
            local playername = player:get_player_name()

            if super_sam.check_play_mode(player) then
                -- play mode, teleport back
                local meta = player:get_meta()
                local last_pos = minetest.string_to_pos(
                    meta:get_string(META_STARTPOS) or minetest.pos_to_string(super_sam.spawn_pos)
                )
                player:set_pos(last_pos)
            else
                -- edit mode, just warn
                minetest.chat_send_player(playername, "WARNING: You are below the teleport-back y-position!")
            end
        end
    end
    minetest.after(1, worker)
end

minetest.after(1, worker)