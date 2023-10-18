
local scores = {}

function super_sam.get_score(name)
	return scores[name] or 0
end

function super_sam.set_score(name, score)
	scores[name] = score
end

function super_sam.add_score(name, score)
	super_sam.set_score(name, super_sam.get_score(name) + score)
end

-- http://lua-users.org/lists/lua-l/2006-01/msg00525.html
local function format_thousand(v)
	local s = string.format("%d", math.floor(v))
	local pos = string.len(s) % 3
	if pos == 0 then pos = 3 end
	return string.sub(s, 1, pos)
		.. string.gsub(string.sub(s, pos+1), "(...)", "'%1")
end

function super_sam.format_score(score)
	return "$ " .. format_thousand(score)
end
