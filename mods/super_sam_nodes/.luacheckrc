globals = {
	"super_sam_nodes"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split", "trim"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"minetest",
	"vector", "ItemStack",
	"dump", "dump2",
	"VoxelArea", "AreaStore",

	-- mods
	"stairsplus",
	"i3"
}
