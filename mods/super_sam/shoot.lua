-- player shoot

super_sam.register_control("dig", function(player, state)
	local playername = player:get_player_name()
	local effects = super_sam.get_player_effects(playername)

	if not effects.shoot then
		-- can't shoot
		return
	end

	if not state then
		-- true -> false
		return
	end

	local shoot_start = vector.add(player:get_pos(),{x=0, y=player:get_properties().eye_height, z=0})
	shoot_start = vector.add(shoot_start, vector.multiply(player:get_look_dir(), 2))

	-- TODO: shoot
	minetest.add_entity(shoot_start, "super_sam:sam_shoot_projectile", minetest.serialize({
		visual = "mesh",
		mesh = "super_sam_sphere.obj",
		textures = {"default_lava.png"},
		wield_item = "super_sam:lava_source",
		visual_size = { x=5, y=5, z=5 },
		collisionbox = {
			-0.5, -0.5, -0.5,
			0.5, 0.5, 0.5
		},
		physical = true,
		collide_with_objects = true,
		pointable = false,
		velocity = vector.multiply(player:get_look_dir(), 5)
	}))
end)

minetest.register_entity("super_sam:sam_shoot_projectile", {
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
		if self.timer > 20 then
			self.object:remove()
			return
		end

		if moveresult and moveresult.collides then
			self.object:remove()
			-- TODO: collisions
			print(dump(moveresult))
			return
		end
	end
})