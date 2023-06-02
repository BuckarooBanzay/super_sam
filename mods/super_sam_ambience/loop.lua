
local sounds = {
	main = {
		{ name = "super_sam_ambience_1", duration = 119 },
		{ name = "super_sam_ambience_2", duration = 100 },
		{ name = "super_sam_ambience_3", duration = 130 },
		{ name = "super_sam_ambience_4", duration = 103 },
		{ name = "super_sam_ambience_5", duration = 167 },
		{ name = "super_sam_ambience_6", duration = 130 }
	},
	main2 = {
		{ name = "super_sam_ambience_7", duration = 57 },
		{ name = "super_sam_ambience_8", duration = 91 },
		{ name = "super_sam_ambience_9", duration = 134 },
		{ name = "super_sam_ambience_10", duration = 124 },
		{ name = "super_sam_ambience_11", duration = 98 }
	},
	relax = {
		{ name = "super_sam_ambience_relax_1", duration = 67, gain = 2 }
	}
}

-- playername -> handle
local handles = {}

-- playername -> current_theme
local player_themes = {}

local function stop_sound(playername)
	local handle = handles[playername]
	if handle then
		minetest.sound_stop(handle)
		handles[playername] = nil
	end
end

local function check_sound(playername)
	local player = minetest.get_player_by_name(playername)
	local ppos = player:get_pos()
	local meta = player:get_meta()
	local state = meta:get_string("super_sam_ambience")
	if state == "off" then
		return
	end

	local theme = super_sam_ambience.get_theme_at_pos(ppos)
	if theme ~= player_themes[playername] then
		-- theme changed
		stop_sound(playername)
	end

	if handles[playername] then
		-- already playing
		return
	end

	local theme_sounds = sounds[theme]
	if not theme_sounds then
		-- no sounds for the theme found
		return
	end

	local sound = theme_sounds[math.random(#theme_sounds)]
	local handle = minetest.sound_play({ name = sound.name, gain = sound.gain or 0.5 }, { to_player = playername })
	handles[playername] = handle
	player_themes[playername] = theme
	minetest.after(sound.duration, function()
		-- remove handle after it is finished
		if handles[playername] == handle then
			handles[playername] = nil
		end
	end)
end

-- check periodically
local function worker()
	for _, player in ipairs(minetest.get_connected_players()) do
		check_sound(player:get_player_name())
	end

	minetest.after(1, worker)
end
minetest.after(1, worker)

-- check on join
minetest.register_on_joinplayer(function(player)
	check_sound(player:get_player_name())
end)

-- toggle command
minetest.register_chatcommand("ambience", {
	params = "[off|on]",
	description = "toggle ambience sound",
	func = function(name, state)
		local player = minetest.get_player_by_name(name)
		local meta = player:get_meta()
		meta:set_string("super_sam_ambience", state)

		if state == "on" then
			check_sound(name)
			return true, "Enabled ambience music"

		elseif state == "off" then
			stop_sound(name)
			return true, "Disabled ambience music"

		else
			return true, "Invalid state: '" .. state .. "'"

		end
	end
})