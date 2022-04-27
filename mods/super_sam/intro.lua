
function super_sam.show_intro(playername)
	minetest.show_formspec(playername, "intro", [[
		size[12,13;]
		label[0,0.1;Super sam intro (get here again with the /intro command)]
		button_exit[10,0;2,1;start;Start]

		label[0,1;Welcome to the super-sam adventures (work in progress)]
		label[0,2;make yourself familiar with the power-ups and items before you start]

		image[0,3;2,2;super_sam_items.png^[sheet:6x5:4,3]
		label[0.4,5;Points]
		image[3.3,3;2,2;super_sam_heart.png]
		label[3.3,5;Health-point]
		image[6.6,3;2,2;super_sam_items.png^[sheet:6x5:1,2]
		label[6.6,5;Speed increase]
		image[10,3;2,2;super_sam_items.png^[sheet:6x5:2,2]
		label[10,5;Higher jumps]

		label[0,6.1;Current highscore top 5 (also available with /highscore)]
		]] .. super_sam_highscore.get_highscore_formspec_fragment("total", 0, 7, 11.7, 6, 5) .. [[
	]])
end

minetest.register_chatcommand("intro", {
	description = "Shows the intro screen",
	func = super_sam.show_intro
})