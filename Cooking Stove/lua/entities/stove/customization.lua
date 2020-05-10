--[[
---------------------------------------------
--ORIGINAL ENTITY BY ZIGND
--https://forum.darkrp.com/threads/stove-a-stove-for-darkrp-created-by-zignd.1771/
--
--MODIFIED BY ZEALOT
--https://steamcommunity.com/id/thezealot35/
---------------------------------------------

	This is the customization file, the only file you should edit.
	
	The recipe and ingredient name should be valid entities. See: food mod entities

	Examples:
		- For new ingredients:
			DarkRP.createStoveIngredient("Pop can", "ent_pop_can") -- The ingredient name ("Pop can") and the entity itself ("ent_pop_can")

		- For new recipes:
			DarkRP.createStoveRecipe("Melon", "ent_melon" { -- The recipe name/result ("Melon") and the entity to spawn ("ent_melon")
				["ent_pop_can"] = 1 -- The ingredient entity ("ent_pop_can") and its required amount (1) to make the recipe
			})

	You should use this with the food mod found on the workshop, as this requires ENTITIES instead of the darkRP food now.
	Do not remove the Stove.SpawnDelay property you should only change its number
	
	--PLEASE NOTE: THIS IS ***TECHNICALLY*** A CRAFTING SYSTEM NOW. SINCE I
]]--

-- How long it will take to spawn the food over the stove after clicking the button
Stove.SpawnDelay = 3

-- Ingredients
DarkRP.createStoveIngredient("Headcrab Meat", "food_hc_raw")
DarkRP.createStoveIngredient("Fast Headcrab Meat", "food_fhc_raw")
DarkRP.createStoveIngredient("Poison Headcrab Meat", "food_phc_raw")

-- Recipes
DarkRP.createStoveRecipe("Grilled Headcrab Meat", "food_hc_grilled", {
	["food_hc_raw"] = 2,
})

DarkRP.createStoveRecipe("Grilled Fast Headcrab Meat", "food_fhc_grilled", {
	["food_fhc_raw"] = 2,
})

DarkRP.createStoveRecipe("Grilled Poison Headcrab Meat", "food_phc_grilled", {
	["food_phc_raw"] = 2,
})