
local max_entries = 20

local highscore = minetest.deserialize(super_sam.storage:get_string("highscore")) or {}

function super_sam.update_highscore(playername, score, level)

    -- create new entry object
    local new_entry = {
        name = playername,
        score = score,
        timestamp = os.time(),
        level = level
    }

    -- check existing list
    local existing_updated = false
    for i, entry in ipairs(highscore) do
        if entry.name == playername then
            -- change existing
            highscore[i] = new_entry
            existing_updated = true
            break
        end
    end

    if not existing_updated then
        -- add new
        table.insert(highscore, new_entry)
    end

    -- sort by score descending
    table.sort(highscore, function(a,b) return a.score > b.score end)

    if #highscore > max_entries then
        -- remove last entry if too many
        table.remove(highscore, #highscore)
    end

    super_sam.storage:set_string("highscore", minetest.serialize(highscore))
end

function super_sam.get_highscore_formspec_fragment(x, y, size_x, size_y, entries)
    entries = entries or max_entries

    local list = ""
    for i, entry in ipairs(highscore) do
        local color = "#FFFFFF"

        if i == 1 then
            -- gold
            color = "#D4AF37"
        elseif i == 2 then
            -- silver
            color = "#C0C0C0"
        elseif i == 3 then
            -- bronze
            color = "#CD7F32"
        end
        list = list .. color .. "," .. super_sam.format_score(entry.score) .. "," ..
            entry.name .. "," .. entry.level .. "," .. os.date('%Y-%m-%d %H:%M:%S', entry.timestamp) .. ","

        if i > entries then
            break
        end
    end

    return [[
        tablecolumns[color;text;text;text;text]
        table[]] .. x..","..y..";"..size_x..","..size_y.. [[;items;#999,Score,Playername,Level,Date,]] .. list .. [[]
    ]]
end

minetest.register_chatcommand("highscore", {
    description = "Shows the current highscore",
    func = function(name)
        minetest.show_formspec(name, "highscore", [[
            size[12,12;]
            label[0,0.1;Highscore top 10]
            button_exit[10,0;2,1;quit;Quit]
            ]] .. super_sam.get_highscore_formspec_fragment(0, 1, 11.7, 11, 10) .. [[
        ]])
    end
})