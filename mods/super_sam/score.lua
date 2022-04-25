
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
