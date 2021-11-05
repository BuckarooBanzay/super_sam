
local player_times = {}

function super_sam.set_time(playername, seconds)
    player_times[playername] = seconds
end

function super_sam.get_time(playername)
    return player_times[playername]
end

local function decrement_time()
    for playername, time in pairs(player_times) do
        local player = minetest.get_player_by_name(playername)
        if not player then
            -- not connected anymore
            player_times[playername] = nil
        elseif time and time > 0 then
            -- decrement
            player_times[playername] = time - 1
        end
    end
    minetest.after(1, decrement_time)
end

decrement_time()