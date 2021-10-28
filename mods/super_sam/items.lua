
minetest.register_craftitem("super_sam:coin", {
    inventory_image = "super_sam_coin.png",
    description = "Coin",
    groups = {
        coin = 1
    }
})

minetest.register_entity("super_sam:coin", {
    initial_properties = {
        visual = "upright_sprite",
        visual_size = {x=1,y=1},
        textures = {"super_sam_coin.png"},
        physical = true,
        collide_with_objects = true
    },

    on_step = function(_, _, moveresult)
        if moveresult.collides then
            print(dump(moveresult))
        end
    end
})

minetest.register_chatcommand("test", {
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            local pos = player:get_pos()
            minetest.add_entity(pos, "super_sam:coin")
        end
    end
})