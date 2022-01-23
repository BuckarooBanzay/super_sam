
local function read_manifest()
	local infile = io.open(minetest.get_modpath("super_sam_map") .. "/manifest.json", "r")
	local instr = infile:read("*a")
	infile:close()

	return minetest.parse_json(instr or "{}")
end

local manifest = read_manifest()
local up_to_date

minetest.register_on_mods_loaded(function()
    assert(manifest, "map manifest not found")

    local world_map_mtime = super_sam.storage:get_int("map_mtime")
    if world_map_mtime == 0 then
        -- initial game startup, save map mtime
        super_sam.storage:set_int("map_mtime", manifest.mtime)
        up_to_date = true
    else
        -- subsequent startup, check mtime with stored value
        if world_map_mtime < manifest.mtime then
            -- world mtime is older than the one in the game mod
            up_to_date = false
        else
            -- everything ok
            up_to_date = true
        end
    end
end)

minetest.register_on_joinplayer(function(player)
    if not up_to_date then
        minetest.chat_send_player(
            player:get_player_name(),
            minetest.colorize("#ff0000", "The game-map has been updated, " ..
                "please remove the world- or map-files to reflect the changes ingame!")
        )
    end
end)