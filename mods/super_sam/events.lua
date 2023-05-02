
-- name -> {fn, fn}
local events = {}

super_sam.EVENT_MODE_CHANGE = "mode_change" -- player, edit|play
super_sam.EVENT_TIMEOUT = "timeout" -- player

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