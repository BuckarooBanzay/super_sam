
-- playername -> { jumping={ time=0.1, ... } }
local player_effects = {}

function super_sam.get_player_effects(playername)
	local effects = player_effects[playername]
	if not effects then
		effects = {}
		player_effects[playername] = effects
	end
	return effects
end

-- effect_name => fn(playername)
local effect_off_callbacks = {}

-- decrease time every few ticks
local function effect_time_decrease()
	local dtime = 0.2
	for playername, effects in pairs(player_effects) do
		for effect_name, ctx in pairs(effects) do
			ctx.time = ctx.time - dtime
			if ctx.time < 0 then
				-- effect expired, run off_callback
				local cb = effect_off_callbacks[effect_name]
				if type(cb) == "function" then
					cb(playername)
				end
				-- remove effect context
				effects[effect_name] = nil
			end
		end
	end
	minetest.after(dtime, effect_time_decrease)
end
effect_time_decrease()

local function register_effect(itemname, name, options)
	-- off
	effect_off_callbacks[name] = function(playername)
		-- get effect context
		local effects = super_sam.get_player_effects(playername)
		local ctx = effects[name]
		if not ctx then
			return
		end

		local player = minetest.get_player_by_name(playername)
		if not player then
			return
		end
		super_sam.sound_play_effect_off(player)
		if options.physics then
			-- physics-override
			local physics_override = player:get_physics_override()
			for key in pairs(options.physics) do
				-- restore physics values
				physics_override[key] = ctx.previous_physics[key]
			end
			player:set_physics_override(physics_override)
		end

		if options.player_properties then
			-- player properties
			local restore_props = {}
			for key in pairs(options.player_properties) do
				restore_props[key] = ctx.previous_player_props[key]
			end
			player:set_properties(restore_props)
		end

		if options.fov then
			player:set_fov(0, false, 0.5)
		end
	end

	-- on
	super_sam.register_on_item_pickup(itemname, function(player)
		local playername = player:get_player_name()
		local previous_physics = player:get_physics_override()
		local previous_player_props = player:get_properties()

		local effects = super_sam.get_player_effects(playername)
		if effects[name] then
			-- reset time
			effects[name].time = options.time or 5
			-- already active
			return
		end

		-- create effect context
		effects[name] = {
			time = options.time or 5,
			previous_physics = previous_physics,
			previous_player_props = previous_player_props
		}
		super_sam.sound_play_effect_on(player)

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

register_effect("super_sam:flower_1", "shoot", {
	time = 20
})