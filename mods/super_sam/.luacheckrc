globals = {
	"minetest", "super_sam",
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
	"VoxelArea",

	-- mods
	"stairsplus", "player_api", "worldedit"
}
