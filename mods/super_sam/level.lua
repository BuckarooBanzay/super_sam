
-- name => def
local levels = {}

function super_sam.register_level(name, def)
    def.name = name
    levels[name] = def
end

function super_sam.get_level(name)
    return levels[name]
end

function super_sam.start_level(player, level)
    player:set_pos(level.start)
end

minetest.register_chatcommand("start", {
    params = "<levelname>",
    description = "Start an arbitrary level",
    privs = { super_sam_builder=true },
    func = function(name, levelname)
        local level = super_sam.get_level(levelname)
        if not level then
            return false, "Level '" .. levelname .. "' not found"
        end

        local player = minetest.get_player_by_name(name)
        super_sam.start_level(player, level)
        return true, "Level '" .. levelname .. "' started"
    end
})