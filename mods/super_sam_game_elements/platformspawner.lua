
-- playername -> meta_as_table
local last_placed = {}

local function update_formspec(meta)
	meta:set_string("formspec", [[
		size[8,7.5;]
		field[0.2,0.5;1,1;xoffset;X Offset;${xoffset}]
		field[1.2,0.5;1,1;yoffset;Y Offset;${yoffset}]
		field[2.2,0.5;1,1;zoffset;Z Offset;${zoffset}]
		field[3.2,0.5;1,1;interval;Interval;${interval}]
		button_exit[6.1,0.2;2,1;save;Save]
		label[4,0.5;Item]
		list[context;main;5,0.2;1,1;]

		field[0.2,1.5;1,1;xvel;X Speed;${xvel}]
		field[1.2,1.5;1,1;yvel;Y Speed;${yvel}]
		field[2.2,1.5;1,1;zvel;Z Speed;${zvel}]

		field[0.2,2.5;1,1;xsize;X Size;${xsize}]
		field[1.2,2.5;1,1;ysize;Y Size;${ysize}]
		field[2.2,2.5;1,1;zsize;Z Size;${zsize}]

		list[current_player;main;0,3.5;8,4;]
		listring[]
	]]);
end

local function activate_spawner(pos)
	local timer = minetest.get_node_timer(pos)
	timer:start(0)
end

minetest.register_node(":super_sam:platform_spawner", {
	description = "Platform spawner",
	tiles = {"super_sam_items.png^[sheet:6x5:3,4"},
	groups = { cracky = 1 },
	on_receive_fields = function(pos, _, fields, sender)
		if not minetest.check_player_privs(sender, "super_sam_builder") or not fields.save then
			return
		end

		local meta = minetest.get_meta(pos)
		meta:set_string("xoffset", fields.xoffset or "0")
		meta:set_string("yoffset", fields.yoffset or "2")
		meta:set_string("zoffset", fields.zoffset or "0")
		meta:set_string("xvel", fields.xvel or "0.1")
		meta:set_string("yvel", fields.yvel or "0")
		meta:set_string("zvel", fields.zvel or "0")
		meta:set_string("xsize", fields.xsize or "1")
		meta:set_string("ysize", fields.ysize or "1")
		meta:set_string("zsize", fields.zsize or "1")
		meta:set_string("interval", fields.interval or "5")

		last_placed[sender:get_player_name()] = meta:to_table()

		activate_spawner(pos)
	end,
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)

		-- position offsets
		meta:set_string("xoffset", "0")
		meta:set_string("yoffset", "2")
		meta:set_string("zoffset", "0")
		meta:set_string("xvel", "0.1")
		meta:set_string("yvel", "0")
		meta:set_string("zvel", "0")
		meta:set_string("xsize", "1")
		meta:set_string("ysize", "1")
		meta:set_string("zsize", "1")
		meta:set_string("interval", "5")

		local inv = meta:get_inventory()
		inv:set_size("main", 1)

		-- check previous placement
		local last_meta = last_placed[placer:get_player_name()]
		if last_meta then
			-- copy values from previous node
			meta:from_table(last_meta)
		end

		update_formspec(meta)
	end,
	on_timer = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack("main", 1)
		local item_name = stack:get_name()

		if not item_name or item_name == "" then
			return
		end

		local xsize = tonumber(meta:get_string("xsize")) or 1
		local ysize = tonumber(meta:get_string("ysize")) or 1
		local zsize = tonumber(meta:get_string("zsize")) or 1

		local xoffset = tonumber(meta:get_string("xoffset")) or 0
		local yoffset = tonumber(meta:get_string("yoffset")) or 2
		local zoffset = tonumber(meta:get_string("zoffset")) or 0
		local spawn_pos = vector.add(pos, {x=xoffset, y=yoffset, z=zoffset})

		local xvel = tonumber(meta:get_string("xvel")) or 0.1
		local yvel = tonumber(meta:get_string("yvel")) or 0
		local zvel = tonumber(meta:get_string("zvel")) or 0

		minetest.add_entity(spawn_pos, "super_sam:platform", minetest.serialize({
			visual = "wielditem",
			wield_item = item_name,
			visual_size = { x=0.675*xsize, y=0.675*ysize, z=0.675*zsize },
			collisionbox = {-0.5*xsize, -0.5*ysize, -0.5*zsize, 0.5*xsize, 0.5*ysize, 0.5*zsize},
			physical = true,
			collide_with_objects = true,
			makes_footstep_sound = true,
			pointable = false,
			velocity = {
				x = xvel,
				y = yvel,
				z = zvel
			}
		}))

		local interval = tonumber(meta:get_string("interval")) or 5
		local timer = minetest.get_node_timer(pos)
		timer:start(interval)
	end
})

minetest.register_entity(":super_sam:platform", {
	initial_properties = {},
	static_save = false,
	on_activate = function(self, staticdata)
		self.object:set_armor_groups({punch_operable = 1})
		local data = minetest.deserialize(staticdata)
		self.data = data
		self.object:set_properties(data)
		self.object:set_velocity(data.velocity)
		self.timer = 0
	end,
	on_step = function(self, dtime, moveresult)
		self.timer = self.timer + dtime
		if self.timer > 60 or (moveresult and moveresult.collides) then
			-- lifetime expired
			self.object:remove()
		end
		local v = self.object:get_velocity()
		if not v or (v.x == 0 and v.y == 0 and v.z == 0) then
			-- platform stopped or is buggy, remove it
			self.object:remove()
		end
	end
})

minetest.register_lbm({
	label = "Platform spawner trigger",
	name = "super_sam_game_elements:platform_spawner",
	nodenames = "super_sam:platform_spawner",
	run_at_every_load = true,
	action = activate_spawner
})
