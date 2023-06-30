
-- name -> {fn, fn}
local events = {}

super_sam.EVENT_MODE_CHANGE = "mode_change" -- player, edit|play
super_sam.EVENT_TIMEOUT = "timeout" -- player
super_sam.EVENT_PLAYER_START = "player_start" -- player, levelname
super_sam.EVENT_PLAYER_FINISHED = "player_finished" -- player, levelname, highscore_name, score, rank
super_sam.EVENT_PLAYER_ABORTED = "player_aborted" -- player

function super_sam.on_event(name, fn)
    local list = events[name]
    if not list then
        list = {}
        events[name] = list
    end
    table.insert(list, fn)
end

function super_sam.emit_event(name, ...)
    local list = events[name]
    for _, fn in ipairs(list or {}) do
        fn(...)
    end
end