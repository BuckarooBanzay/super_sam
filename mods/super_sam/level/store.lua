
-- name => def
local levels = {}

-- area store for lookup
local store = AreaStore()

function super_sam.register_level_beacon(pos)
    local meta = minetest.get_meta(pos)
    local level_def = {
        time = meta:get_int("time"),
        name = meta:get_string("name"),
        start = pos,
        teleport = {
            x = meta:get_int("tpx"),
            y = meta:get_int("tpy"),
            z = meta:get_int("tpz")
        },
        bounds = {
            min = {
                x = pos.x - meta:get_int("xminus"),
                y = pos.y - meta:get_int("yminus"),
                z = pos.z - meta:get_int("zminus")
            },
            max = {
                x = pos.x + meta:get_int("xplus"),
                y = pos.y + meta:get_int("yplus"),
                z = pos.z + meta:get_int("zplus")
            }
        }
    }

    local old_level = levels[level_def.name]
    if old_level then
        -- remove old entry (name has to match)
        store:remove_area(old_level.area_id)
    end

    local id = store:insert_area(level_def.bounds.min, level_def.bounds.max, level_def.name)
    level_def.area_id = id
    levels[level_def.name] = level_def
end

function super_sam.get_level_by_name(name)
    return levels[name]
end

-- returns the nearest level-beacon within the given margin
function super_sam.get_nearest_level(pos, margin)
    local pos1 = vector.subtract(pos, margin)
    local pos2 = vector.add(pos, margin)
    local list = store:get_areas_in_area(pos1, pos2, true, true, true)
    local level_list = {}
    for _, entry in pairs(list) do
        local level_def = levels[entry.data]
        local distance = vector.distance(pos, level_def.start)
        if distance <= margin then
            -- only add if the start-pos is within the margin
            table.insert(level_list, level_def)
        end
    end

    -- sort by distance
    table.sort(level_list, function(a, b)
        return vector.distance(pos, a.start) < vector.distance(pos, b.start)
    end)

    return level_list[1]
end

function super_sam.get_levels_at_pos(pos)
    local result = {}
    local list = store:get_areas_for_pos(pos, true, true)
    for _, entry in pairs(list) do
        table.insert(result, levels[entry.data])
    end
    return result
end

function super_sam.get_level_at_pos(pos)
    local list = super_sam.get_levels_at_pos(pos)
    return list[1]
end