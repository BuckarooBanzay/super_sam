
-- register node invisible unless editor mode is enabled
function super_sam.register_hidden_node(name, def)

	if not super_sam.editor_mode then
		def.drawtype = "airlike"
		def.paramtype = "light"
		def.sunlight_propagates = true
		def.pointable = false
		def.walkable = false
		def.diggable = false
	end

	minetest.register_node(name, def)
end
