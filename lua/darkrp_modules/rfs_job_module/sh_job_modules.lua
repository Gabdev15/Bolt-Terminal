/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

timer.Simple(1, function()
	TEAM_RFSCOOK = DarkRP.createJob("Fast Food Cooker", {
		color = Color(158, 38, 228),
		model = {"models/Humans/Group01/Female_03.mdl"},
		description = [[ You are a cooker. You can make burgers, fries and drinks. You can also sell them to citizens.]],
		weapons = {},
		command = "cooker",
		max = 2,
		salary = 20,
		admin = 0,
		vote = false,
		category = "Citizens",
		cook = true,
		hasLicense = false
	})

	DarkRP.createCategory{
		name = "Cooking", 
		categorises = "entities",
		startExpanded = true,
		color = Color(158, 38, 228),
		canSee = function(ply) return true end,
		sortOrder = 100,
	}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

	DarkRP.createEntity("Delivery Box", {
		ent = "rfs_box",
		model = "models/realistic_food_system/carton.mdl",
		price = 100,
		max = 1,
		cmd = "rfs_box",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})

	DarkRP.createEntity("Bag", {
		ent = "rfs_bag",
		model = "models/realistic_food_system/paper_bag.mdl",
		price = 150,
		max = 4,
		cmd = "rfs_bag",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})

	DarkRP.createEntity("Condiments Container", {
		ent = "rfs_condiment_container",
		model = "models/realistic_food_system/condiment_container.mdl",
		price = 100,
		max = 1,
		cmd = "rfs_condiment_container",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})

	DarkRP.createEntity("Fountain", {
		ent = "rfs_fountain",
		model = "models/realistic_food_system/soda_fountain_.mdl",
		price = 300,
		max = 1,
		cmd = "rfs_fountain",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})

	DarkRP.createEntity("Fryer", {
		ent = "rfs_fryer",
		model = "models/realistic_food_system/fryer.mdl",
		price = 300,
		max = 1,
		cmd = "rfs_fryer",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})

	DarkRP.createEntity("Grill", {
		ent = "rfs_grill",
		model = "models/realistic_food_system/grill.mdl",
		price = 300,
		max = 1,
		cmd = "rfs_grill",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})

	DarkRP.createEntity("Burger Plank", {
		ent = "rfs_plank_burger",
		model = "models/realistic_food_system/presentation_table.mdl",
		price = 100,
		max = 1,
		cmd = "rfs_plank_burger",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

	DarkRP.createEntity("Cutting Plank", {
		ent = "rfs_plank",
		model = "models/realistic_food_system/cutting_plank.mdl",
		price = 100,
		max = 1,
		cmd = "rfs_plank",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})
	
	DarkRP.createEntity("Table", {
		ent = "rfs_table",
		model = "models/realistic_food_system/table.mdl",
		price = 200,
		max = 1,
		cmd = "rfs_table",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})

	DarkRP.createEntity("Terminal", {
		ent = "rfs_terminal",
		model = "models/realistic_food_system/terminal.mdl",
		price = 200,
		max = 4,
		cmd = "rfs_terminal",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})

	DarkRP.createEntity("Screen", {
		ent = "rfs_screen",
		model = "models/realistic_food_system/screen.mdl",
		price = 200,
		max = 4,
		cmd = "rfs_screen",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

	DarkRP.createEntity("Dishes", {
		ent = "rfs_dishes",
		model = "models/realistic_food_system/dishes.mdl",
		price = 200,
		max = 4,
		cmd = "rfs_dishes",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

	DarkRP.createEntity("Tray", {
		ent = "rfs_tray",
		model = "models/realistic_food_system/tray.mdl",
		price = 200,
		max = 4,
		cmd = "rfs_tray",
		allowed = {TEAM_RFSCOOK},
		category = "Cooking",
	})
end)
