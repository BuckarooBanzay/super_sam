
local effects = {}

function powerups.register_effect(def)
    effects[def.itemname] = def
end

function powerups.get_effect(name)
    return effects[name]
end