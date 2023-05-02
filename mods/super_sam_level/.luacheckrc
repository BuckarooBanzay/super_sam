globals = {
	"super_sam_level",
	["worldedit"] = {
		fields = {
			"pos1", "pos2"
		}
	}
}

read_globals = {
	"minetest", "super_sam",

	-- Stdlib
	string = {fields = {"split", "trim"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump", "dump2",
	"VoxelArea", "AreaStore",

	-- deps
	"super_sam_highscore", "worldedit"
}
