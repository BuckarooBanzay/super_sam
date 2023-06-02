super_sam_hud = {}

local enable_damage = minetest.settings:get("enable_damage")

-- player => { name => id }
local hud_data = {}

local health_position = { x = 0.2, y = 0.05 }
local coins_position = { x = 0.4, y = 0.05 }
local level_position = { x = 0.6, y = 0.05 }
local time_position = { x = 0.6, y = 0.08 }
local score_position = { x = 0.8, y = 0.05 }

local hud_powerup_center_position = { x = 0.5, y = 0.1 }

local position_offscreen = { x = -1, y = -1 }

local function restrict_player_hud(player)
	player:hud_set_flags({
		crosshair = true,
		hotbar = false,
		healthbar = false,
		wielditem = false,
		breathbar = false,
		minimap = false,
		minimap_radar = false
	})
end

local function create_offscreen_hud_text(player, offset)
	return player:hud_add({
		hud_elem_type = "text",
		position = position_offscreen,
		text = "",
		offset = offset,
		alignment = { x = 0, y = 0},
		scale = {x = 2, y = 2}
	})
end

local function format_timer(time)
	return math.floor(time*10) / 10
end

local function setup_hud(player)
	local data = {}

	-- Score

	data.score_text = player:hud_add({
		hud_elem_type = "text",
		position = score_position,
		number = 0xffffff,
		text = "",
		offset = {x = 0,   y = 0},
		alignment = { x = 1, y = 0},
		scale = {x = 2, y = 2}
	})

	-- Time

	data.time_text = player:hud_add({
		hud_elem_type = "text",
		position = time_position,
		number = 0xffffff,
		text = "",
		offset = {x = 0,   y = 0},
		alignment = { x = 1, y = 0},
		scale = {x = 2, y = 2}
	})

	-- Coins

	data.coins_img = player:hud_add({
		hud_elem_type = "image",
		position = coins_position,
		text = "super_sam_items.png^[sheet:6x5:4,3",
		offset = {x = 0,   y = 0},
		alignment = { x = -1, y = 0},
		scale = {x = 2, y = 2}
	})

	data.coins_text = player:hud_add({
		hud_elem_type = "text",
		position = coins_position,
		number = 0xffffff,
		text = "",
		offset = {x = 0,   y = 0},
		alignment = { x = 1, y = 0},
		scale = {x = 2, y = 2}
	})

	-- Health

	data.health_img = player:hud_add({
		hud_elem_type = "image",
		position = health_position,
		text = "super_sam_heart.png",
		offset = {x = 0,   y = 0},
		alignment = { x = -1, y = 0},
		scale = {x = 2, y = 2}
	})

	data.health_text = player:hud_add({
		hud_elem_type = "text",
		position = health_position,
		number = 0xffffff,
		text = "",
		offset = {x = 0,   y = 0},
		alignment = { x = 1, y = 0},
		scale = {x = 2, y = 2}
	})

	-- Current level

	data.level_text = player:hud_add({
		hud_elem_type = "text",
		position = level_position,
		number = 0xffffff,
		text = "",
		offset = {x = 0,   y = 0},
		alignment = { x = 1, y = 0},
		scale = {x = 2, y = 2}
	})

	-- powerups / effects

	data.powerup1 = player:hud_add({
		hud_elem_type = "image",
		position = position_offscreen,
		text = "super_sam_items.png^[sheet:6x5:0,2",
		offset = {x = -32,   y = 0},
		alignment = { x = 0, y = 0},
		scale = {x = 2, y = 2}
	})
	data.powerup1_time = create_offscreen_hud_text(player, { x=-32, y=32 })

	data.powerup2 = player:hud_add({
		hud_elem_type = "image",
		position = position_offscreen,
		text = "super_sam_items.png^[sheet:6x5:1,2",
		offset = {x = 0,   y = 0},
		alignment = { x = 0, y = 0},
		scale = {x = 2, y = 2}
	})
	data.powerup2_time = create_offscreen_hud_text(player, { x=0, y=32 })

	data.powerup3 = player:hud_add({
		hud_elem_type = "image",
		position = position_offscreen,
		text = "super_sam_items.png^[sheet:6x5:2,2",
		offset = {x = 32,   y = 0},
		alignment = { x = 0, y = 0},
		scale = {x = 2, y = 2}
	})
	data.powerup3_time = create_offscreen_hud_text(player, { x=32, y=32 })

	data.powerup4 = player:hud_add({
		hud_elem_type = "image",
		position = position_offscreen,
		text = "super_sam_flower_1.png",
		offset = {x = 64,   y = 0},
		alignment = { x = 0, y = 0},
		scale = {x = 2, y = 2}
	})
	data.powerup4_time = create_offscreen_hud_text(player, { x=64, y=32 })

	hud_data[player:get_player_name()] = data
end

function super_sam_hud.update_player_hud(player)
	local playername = player:get_player_name()
	local data = hud_data[playername]
	if not data then
		return
	end

	if data.coins_text then
		player:hud_change(data.coins_text, "text", "x" .. super_sam.get_coins(playername))
	end
	if data.health_text then
		local hp = player:get_hp()
		if enable_damage ~= "true" then
			-- no damage enabled, show dummy value
			hp = "999"
		end
		player:hud_change(data.health_text, "text", "x" .. hp)
	end
	if data.score_text then
		player:hud_change(data.score_text, "text", super_sam_highscore.format_score(super_sam.get_score(playername)))
	end
	if data.level_text then
		local level = super_sam_level.get_current_level(player)
		local levelname = level and level.name or "<none>"
		player:hud_change(data.level_text, "text", "Level: '" .. levelname .. "'")
	end
	if data.time_text then
		local time = super_sam.get_time(playername)
		player:hud_change(data.time_text, "text", "Time: " .. (time or "-"))
		if time and time > 60 then
			player:hud_change(data.time_text, "number", 0x00ff00)
		else
			player:hud_change(data.time_text, "number", 0xff0000)
		end
	end

	-- TODO: proper effect class/module/enumeration/thing
	local effects = super_sam.get_player_effects(playername)
	if data.powerup1 then
		player:hud_change(data.powerup1, "position", effects.jumping and hud_powerup_center_position or position_offscreen)
		player:hud_change(data.powerup1_time,"position", effects.jumping and hud_powerup_center_position or position_offscreen)
		player:hud_change(data.powerup1_time, "text", effects.jumping and format_timer(effects.jumping.time) or "0.0")
	end
	if data.powerup2 then
		player:hud_change(data.powerup2, "position", effects.speed and hud_powerup_center_position or position_offscreen)
		player:hud_change(data.powerup2_time,"position", effects.speed and hud_powerup_center_position or position_offscreen)
		player:hud_change(data.powerup2_time, "text", effects.speed and format_timer(effects.speed.time) or "0.0")
	end
	if data.powerup3 then
		player:hud_change(data.powerup3, "position", effects.shrink and hud_powerup_center_position or position_offscreen)
		player:hud_change(data.powerup3_time,"position", effects.shrink and hud_powerup_center_position or position_offscreen)
		player:hud_change(data.powerup3_time, "text", effects.shrink and format_timer(effects.shrink.time) or "0.0")
	end
	if data.powerup4 then
		player:hud_change(data.powerup4, "position", effects.shoot and hud_powerup_center_position or position_offscreen)
		player:hud_change(data.powerup4_time,"position", effects.shoot and hud_powerup_center_position or position_offscreen)
		player:hud_change(data.powerup4_time, "text", effects.shoot and format_timer(effects.shoot.time) or "0.0")
	end
end

-- update hud periodically
local function update_hud()
	for _, player in ipairs(minetest.get_connected_players()) do
		super_sam_hud.update_player_hud(player)
	end
	minetest.after(0.1, update_hud)
end
minetest.after(0.1, update_hud)

-- setup hud on join
minetest.register_on_joinplayer(function(player)
	setup_hud(player)

	if not minetest.check_player_privs(player, "super_sam_builder") then
		restrict_player_hud(player)
	end

	super_sam_hud.update_player_hud(player)
end)