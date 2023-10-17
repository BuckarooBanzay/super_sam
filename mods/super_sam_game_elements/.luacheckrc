globals = {
	"minetest", "super_sam_game_elements",
	["worldedit"] = {
		fields = {
			"pos1", "pos2"
		}
	}
}

read_globals = {
	-- Stdlib
	string = {fields = {"split", "trim"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump", "dump2",
	"VoxelArea", "AreaStore",

	-- mods
	"player_api", "worldedit",
	"super_sam", "mtt"
}
