local has_worldedit = minetest.get_modpath("worldedit")

-- player -> inv-formspecs
local old_inv_formspecs = {}

local editor_privs = {
	"fly", "fast", "noclip", "debug"
}

-- returns true if in play mode
function super_sam.check_play_mode(player)
	local meta = player:get_meta()
	local mode = meta:get_string("super_sam_mode")
	return mode == "" or mode == "play"
end

-- play mode
function super_sam.set_play_mode(player)
	local playername = player:get_player_name()

	-- make player mortal
	player:set_armor_groups({
		immortal = nil,
		fall_damage_add_percent = -100
	})
	player:set_hp(super_sam.max_hp, "set_hp")

	-- clear inventory items
	local inv = player:get_inventory()

	local hand_inv = {""}
	inv:set_list("hand", hand_inv)

	local main_inv = inv:get_list("main")
	for i in ipairs(main_inv) do
		main_inv[i] = ""
	end
	inv:set_list("main", main_inv)

	-- disable inventory
	old_inv_formspecs[playername] = player:get_inventory_formspec()
	player:set_inventory_formspec("")

	-- restrict hud
	player:hud_set_flags({
		healthbar = false,
		breathbar = false,
		hotbar = false,
		wielditem = false,
		minimap = false,
		minimap_radar = false
	})

	-- revoke privs
	local privs = minetest.get_player_privs(playername)
	for _, name in pairs(editor_privs) do
		privs[name] = nil
	end
	minetest.set_player_privs(playername, privs)

	-- TODO: search nearest/last level
end

-- editor mode
function super_sam.set_edit_mode(player)
	local playername = player:get_player_name()

	super_sam.emit_event(super_sam.EVENT_MODE_CHANGE, player, "edit")

	-- make player immortal
	player:set_armor_groups({ immortal = 1 })

	-- restore inventory formspec
	if old_inv_formspecs[playername] then
		player:set_inventory_formspec(old_inv_formspecs[playername])
	end

	-- add editor items to inv
	local inv = player:get_inventory()

	local hand_inv = {"super_sam:edit_hand"}
	inv:set_list("hand", hand_inv)

	local main_inv = inv:get_list("main")
	if has_worldedit then
		main_inv[1] = "worldedit:wand"
	end
	inv:set_list("main", main_inv)

	-- toggle hud items
	player:hud_set_flags({
		hotbar = true,
		wielditem = true,
		minimap = true,
		minimap_radar = true
	})

	-- reset time and stats
	super_sam.set_time(playername, nil)
	super_sam.set_coins(playername, 0)
	super_sam.set_score(playername, 0)

	-- grant privs
	local privs = minetest.get_player_privs(playername)
	for _, name in pairs(editor_privs) do
		privs[name] = true
	end
	minetest.set_player_privs(playername, privs)
end

-- restore previous mode on join
minetest.register_on_joinplayer(function(player)
	local meta = player:get_meta()
	local mode = meta:get_string("super_sam_mode")

	if mode == "edit" then
		super_sam.set_edit_mode(player)
	else
		super_sam.set_play_mode(player)
	end
end)

-- toggle command, requires the "super_sam_builder" priv
minetest.register_chatcommand("mode", {
	params = "[edit|play]",
	description = "Switch between edit and play mode",
	privs = { super_sam_builder=true },
	func = function(name, mode)
		local player = minetest.get_player_by_name(name)
		local meta = player:get_meta()
		meta:set_string("super_sam_mode", mode)

		if mode == "play" then
			super_sam.set_play_mode(player)
			return true, "Switched to play mode"

		elseif mode == "edit" then
			-- abort level
			super_sam.set_edit_mode(player)
			return true, "Switched to editor mode"

		else
			return true, "Invalid mode: '" .. mode .. "'"

		end
	end
})