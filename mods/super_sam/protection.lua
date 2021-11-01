
local old_is_protected = minetest.is_protected

minetest.is_protected = function(pos, name)
    if minetest.check_player_privs(name, "super_sam_builder") then
        return old_is_protected(pos, name)
    else
        -- always protected if the player does not have the "super_sam_builder" priv
        return true
    end
end