
function super_sam.animation_failed(player)
	local ppos = player:get_pos()
	minetest.add_particlespawner({
		amount = 350,
		time = 1,
		-- floor
		minpos = vector.subtract(ppos, {x=5, y=1, z=5}),
		maxpos = vector.subtract(ppos, {x=-5, y=1, z=-5}),
		minvel = {x=0, y=2, z=0},
		maxvel = {x=0, y=4, z=0},
		minsize = 2,
		texture = "super_sam_items.png^[sheet:6x5:4,2"
	})
end

function super_sam.animation_teleport_beacon(player, beacon_pos)
	minetest.add_particlespawner({
		amount = 50,
		time = 1,
		-- floor
		minpos = vector.subtract(beacon_pos, {x=0.5, y=-0.5, z=0.5}),
		maxpos = vector.add(beacon_pos, {x=0.5, y=0.5, z=0.5}),
		minvel = {x=0, y=1, z=0},
		maxvel = {x=0, y=2, z=0},
		minsize = 2,
		texture = "super_sam_items.png^[sheet:6x5:5,2",
		playername = player:get_player_name()
	})
end

function super_sam.animation_cash(player, coins)
	local ppos = player:get_pos()
	super_sam.sound_play_cash(player)
	minetest.add_particlespawner({
		amount = coins * 50,
		time = 1,
		-- floor
		minpos = vector.subtract(ppos, {x=5, y=1, z=5}),
		maxpos = vector.subtract(ppos, {x=-5, y=1, z=-5}),
		minvel = {x=0, y=2, z=0},
		maxvel = {x=0, y=4, z=0},
		minsize = 2,
		texture = "super_sam_items.png^[sheet:6x5:4,3"
	})
end