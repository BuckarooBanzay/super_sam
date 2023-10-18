globals = {
	"super_sam_highscore"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split", "trim"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"minetest", "vector", "ItemStack",
	"dump", "dump2",
	"VoxelArea", "AreaStore",

	-- deps
	"super_sam"
}
