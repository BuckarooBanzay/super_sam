
super_sam_test.register_test(function(callback)
    minetest.log("warning", "[super_sam_test] emerging")
    local pos1 = {x=0, y=0, z=0}
    local pos2 = {x=48, y=48, z=48}
    minetest.emerge_area(pos1, pos2, function(_,_,calls_remaining)
        if calls_remaining == 0 then
            callback()
        end
    end)
end)