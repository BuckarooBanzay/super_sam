-- name -> def
local skyboxes = {}

function super_sam_skybox.register(name, def)
    skyboxes[name] = def
end

function super_sam_skybox.get(name)
    return skyboxes[name]
end

function super_sam_skybox.get_all()
    return skyboxes
end

function super_sam_skybox.get_names()
    local names = {}
    for name in pairs(skyboxes) do
        table.insert(names, name)
    end
    return names
end

function super_sam_skybox.reset_skybox(player)
	super_sam_skybox.set_skybox("default", player)
end

function super_sam_skybox.set_skybox(name, player)
    local skybox = super_sam_skybox.get(name)
    if not skybox then
        return false
    end

    player:set_clouds({ density=0 })

    skybox.color = skybox.color or {r=0, g=0, b=0}

    if player.set_sun then
		-- new format
		player:set_sun({
			visible = false,
			sunrise_visible = false
		})
		player:set_moon({
			visible = false
		})
		player:set_sky({
			base_color = skybox.color,
			clouds = false,
			type = "skybox",
			textures = skybox.textures
		})
	else
		-- legacy format
		player:set_sky(skybox.color, "skybox", skybox.textures)
	end
end

