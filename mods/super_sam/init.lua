super_sam = {}

local MP = minetest.get_modpath(minetest.get_current_modname())
dofile(MP .. "/skybox.lua")
dofile(MP .. "/score.lua")
dofile(MP .. "/hud.lua")
dofile(MP .. "/privs.lua")
dofile(MP .. "/protection.lua")
dofile(MP .. "/hand.lua")
dofile(MP .. "/spawn.lua")
dofile(MP .. "/items.lua")
dofile(MP .. "/nodes.lua")
dofile(MP .. "/itemspawner.lua")
dofile(MP .. "/platformspawner.lua")
dofile(MP .. "/projectilespawner.lua")
dofile(MP .. "/liquids.lua")
dofile(MP .. "/bakedclay.lua")
dofile(MP .. "/plants.lua")
dofile(MP .. "/itempickup.lua")
dofile(MP .. "/tools.lua")

minetest.register_entity("super_sam:test", {
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
        if self.timer > 60 or moveresult.collides then
            self.object:remove()
        end
    end
})

minetest.register_chatcommand("test",{
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()
        local spawn_pos = vector.add(pos, {x=0, y=2, z=0})

        local xsize = 1
        local ysize = 1
        local zsize = 1

        minetest.add_entity(spawn_pos, "super_sam:test", minetest.serialize({
            visual = "mesh",
            mesh = "super_sam_sphere.obj",
            textures = {"default_lava.png"},
            visual_size = { x=10*xsize, y=10*ysize, z=10*zsize },
            collisionbox = {-0.5*xsize, -0.5*ysize, -0.5*zsize, 0.5*xsize, 0.5*ysize, 0.5*zsize},
            physical = true,
            collide_with_objects = true,
            pointable = true,
            velocity = {
                x = 0,
                y = 0,
                z = 1
            }
        }))
    end
})