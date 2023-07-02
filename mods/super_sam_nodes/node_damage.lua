
-- nodes that a should only be passable with a cheat-client
-- add some damage to prevent cheating/noclipping to some extent
local damage_nodes = {
    "super_sam:border",
    "super_sam:cobble",
    "super_sam:stone",
    "super_sam:stone_brick",
    "super_sam:dirt",
    "super_sam:grass"
}

for _, nodename in ipairs(damage_nodes) do
    minetest.override_item(nodename, {
        damage_per_second = 5
    })
end