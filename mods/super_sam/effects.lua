
-- playername -> { jumping=true }
local player_effects = {}

function super_sam.get_player_effects(playername)
    local effects = player_effects[playername]
    if not effects then
        effects = {}
        player_effects[playername] = effects
    end
    return effects
end


local function register_effect(itemname, name, physicsname, physicsmodifier)
    super_sam.register_on_pickup(itemname, function(player)
        local playername = player:get_player_name()
        local previous_overrides = player:get_physics_override()

        local effects = super_sam.get_player_effects(playername)
        effects[name] = true

        minetest.sound_play({ name = "super_sam_effect_on", gain = 0.7 }, { to_player = playername }, true)
        player:set_physics_override({
            [physicsname] = physicsmodifier
        })

        minetest.after(5, function()
            effects[name] = false
            player = minetest.get_player_by_name(playername)
            if not player then
                return
            end
            minetest.sound_play({ name = "super_sam_effect_off", gain = 0.7 }, { to_player = playername }, true)
            player:set_physics_override({
                [physicsname] = previous_overrides[physicsname]
            })
        end)
    end)
end

register_effect("super_sam:mushroom_1", "jumping", "jump", 2)
register_effect("super_sam:mushroom_2", "speed", "speed", 2.5)