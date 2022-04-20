
local tests = {}

function super_sam_test.register_test(fn)
    table.insert(tests, fn)
end

local i = 0
function super_sam_test.execute_tests()
    i = i + 1
    local fn = tests[i]
    if not fn then
        -- everything ok
        minetest.request_shutdown("success")
        return
    end

    fn(function()
        minetest.after(0.1, super_sam_test.execute_tests)
    end)
end