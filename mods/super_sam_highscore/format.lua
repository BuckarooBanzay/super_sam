
-- http://lua-users.org/lists/lua-l/2006-01/msg00525.html
local function format_thousand(v)
	local s = string.format("%d", math.floor(v))
	local pos = string.len(s) % 3
	if pos == 0 then pos = 3 end
	return string.sub(s, 1, pos)
		.. string.gsub(string.sub(s, pos+1), "(...)", "'%1")
end

function super_sam_highscore.format_score(score)
	return "$ " .. format_thousand(score)
end
