
local effects = {}

function powerups.register(name, fn)
    effects[name] = fn
end

function powerups.get_effect(name)
    return effects[name]
end