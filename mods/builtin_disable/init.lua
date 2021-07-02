
local disable_abms = {
	["default"] = true,
	["farming"] = true,
	["flowers"] = true,
	["moreblocks"] = true
}

local disable_lbms = {
	["default"] = true,
	["moreblocks"] = true,
	["doors"] = true
}

local disable_globalsteps = {
	["player_api"] = true
}

minetest.register_on_mods_loaded(function()
	-- disable abm's
	for i=#minetest.registered_abms,1,-1 do
		local abm = minetest.registered_abms[i]
		if disable_abms[abm.mod_origin] then
			table.remove(minetest.registered_abms, i)
		end
	end

	-- disable lbm's
	for i=#minetest.registered_lbms,1,-1 do
		local lbm = minetest.registered_lbms[i]
		if disable_lbms[lbm.mod_origin] then
			table.remove(minetest.registered_lbms, i)
		end
	end

	-- disable globalsteps
	for i=#minetest.registered_globalsteps,1,-1 do
		local globalstep = minetest.registered_globalsteps[i]
		local info = minetest.callback_origins[globalstep]
		if disable_globalsteps[info.mod] then
			table.remove(minetest.registered_globalsteps, i)
		end
	end
end)
