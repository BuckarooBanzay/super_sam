
local effects = {}

function powerups.register_effect(name, def)
    effects[name] = def
end

function powerups.get_effect(name)
    return effects[name]
end