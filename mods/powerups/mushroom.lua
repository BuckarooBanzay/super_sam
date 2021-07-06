
powerups.register_effect({
    itemname = "flowers:mushroom_red",
    time = 5,
    enter = function(player)
        print("enter: " .. player:get_player_name())
    end,
    leave = function(player)
        print("leave: " .. player:get_player_name())
    end
})

-- powerups.register_effect("flowers:mushroom_brown", {})
