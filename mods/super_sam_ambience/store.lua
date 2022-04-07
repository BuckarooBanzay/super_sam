
-- area store for lookup
local store = AreaStore()

function super_sam_ambience.register_ambience_node(pos)
    local meta = minetest.get_meta(pos)
    local ambience_def = {
        theme = meta:get_string("theme"),
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

    local id = store:insert_area(ambience_def.bounds.min, ambience_def.bounds.max, ambience_def.theme)
    ambience_def.area_id = id
end

function super_sam_ambience.get_themes_at_pos(pos)
    local result = {}
    local list = store:get_areas_for_pos(pos, true, true)
    for _, entry in pairs(list) do
        table.insert(result, entry.data)
    end
    return result
end

function super_sam_ambience.get_theme_at_pos(pos)
    local list = super_sam_ambience.get_themes_at_pos(pos)
    return list and list[1]
end