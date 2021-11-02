

minetest.register_entity("super_sam:platform", {
    initial_properties = {},
    static_save = false,
    on_activate = function(self, staticdata)
		self.object:set_armor_groups({punch_operable = 1})
		local data = minetest.deserialize(staticdata)
        self.data = data
        self.object:set_properties(data)
        self.object:set_velocity({x=0.5, y=0, z=0})
        self.timer = 0
	end,
    on_step = function(self, dtime, moveresult)
        self.timer = self.timer + dtime
        if self.timer > 60 or moveresult.collides then
            self.object:remove()
        end
    end
})

minetest.register_chatcommand("test", {
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            local pos = player:get_pos()
            local sizex = 1
            local sizey = 1
            local sizez = 1
            minetest.add_entity(vector.add(pos, {x=0, y=2, z=0}), "super_sam:platform", minetest.serialize({
                visual = "wielditem",
                wield_item = "super_sam:stone",
                visual_size = { x=0.675*sizex, y=0.675*sizey, z=0.675*sizez },
                collisionbox = {-0.5*sizex, -0.5*sizey, -0.5*sizez, 0.5*sizex, 0.5*sizey, 0.5*sizez},
                physical = true,
                collide_with_objects = true,
                makes_footstep_sound = true,
                pointable = false
            }))
        end
    end
})