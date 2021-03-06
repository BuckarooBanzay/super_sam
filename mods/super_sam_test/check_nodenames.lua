
super_sam_test.register_test(function(callback)
    minetest.log("warning", "[super_sam_test] checking nodenames")

    local assert_nodes = {}
    for nodename in io.lines(minetest.get_modpath("super_sam_test") .. "/nodenames.txt") do
        table.insert(assert_nodes, nodename)
    end

    -- assemble node-list from registered lbm's
    local lbm_nodes = {}
    for _, lbm in ipairs(minetest.registered_lbms) do
        if type(lbm.nodenames) == "string" then
            -- duh, list as string
            lbm_nodes[lbm.nodenames] = true
        else
            -- proper list, add all regardless if they are a "group:*"
            for _, nodename in ipairs(lbm.nodenames) do
                lbm_nodes[nodename] = true
            end
        end
    end

    -- check nodes
    local all_nodes_present = true
    for _, nodename in ipairs(assert_nodes) do
        if not minetest.registered_nodes[nodename]
            and not minetest.registered_aliases[nodename]
            and not lbm_nodes[nodename] then
                error("Node not present and not available in an alias/lbm: " .. nodename)
        end
    end

    if not all_nodes_present then
        error("some of the required nodes are not present and not aliased!")
    end

    callback()
end)