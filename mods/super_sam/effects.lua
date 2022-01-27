
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


local function register_effect(itemname, name, options)
    super_sam.register_on_pickup(itemname, function(player)
        local playername = player:get_player_name()
        local previous_physics = player:get_physics_override()
        local previous_player_props = player:get_properties()

        local effects = super_sam.get_player_effects(playername)
        effects[name] = true

        minetest.sound_play({ name = "super_sam_effect_on", gain = 0.7 }, { to_player = playername }, true)

        if options.physics then
            -- physics-override
            -- override specified keys of the physics override
            local physics_override = player:get_physics_override()
            for key, value in pairs(options.physics) do
                -- save value for restore later
                previous_physics[key] = physics_override[key]
                -- override value
                physics_override[key] = value
            end
            player:set_physics_override(physics_override)
        end

        if options.player_properties then
            -- player properties override
            player:set_properties(options.player_properties)
        end

        if options.fov then
            player:set_fov(options.fov, true, 0.5)
        end

        minetest.after(options.time or 5, function()
            effects[name] = false
            player = minetest.get_player_by_name(playername)
            if not player then
                return
            end
            minetest.sound_play({ name = "super_sam_effect_off", gain = 0.7 }, { to_player = playername }, true)
            if options.physics then
                -- physics-override
                local physics_override = player:get_physics_override()
                for key in pairs(options.physics) do
                    -- restore physics values
                    physics_override[key] = previous_physics[key]
                end
                player:set_physics_override(physics_override)
            end

            if options.player_properties then
                -- player properties
                local restore_props = {}
                for key in pairs(options.player_properties) do
                    restore_props[key] = previous_player_props[key]
                end
                player:set_properties(restore_props)
            end

            if options.fov then
                player:set_fov(0, false, 0.5)
            end
        end)
    end)
end

register_effect("super_sam:mushroom_1", "jumping", {
    physics = { jump = 2 },
    time = 5
})

register_effect("super_sam:mushroom_2", "speed", {
    physics = {
        speed = 2.5
    },
    fov = 1.2,
    time = 5
})

register_effect("super_sam:mushroom_3", "shrink", {
    player_properties = {
        eye_height = 0.3,
        visual_size = {x = 0.4, y = 0.4, z = 0.4},
        collisionbox = {
            -0.2, 0.0, -0.2,
            0.2, 0.8, 0.2
        }
    },
    physics = {
        jump = 0.7
    },
    time = 10
})