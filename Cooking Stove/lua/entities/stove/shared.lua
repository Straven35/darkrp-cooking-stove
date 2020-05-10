ENT.Type									= "anim"
ENT.Base									= "base_gmodentity"
ENT.PrintName							= "Stove"
ENT.Author								= "Zignd"
ENT.Spawnable						= true
ENT.AdminSpawnable						= true
ENT.Category							= "Zealot's Entities"
ENT.NetStoveOpenMenu			= "DarkRP_StoveOpenMenu"
ENT.NetStoveSpawnFood		= "DarkRP_StoveSpawnFood"
ENT.NetStoveNotifyCantUse	= "DarkRP_StoveNotifyCantUse"

Stove = {}

ENT.Recipes = {}
	--["food_hc_grilled"] = {
	--	["Grilled Headcrab"]=true,
	--	["food_hc_raw"] = 1,
	--}
--}
ENT.Ingredients = {}
	--["food_hc_raw"]= { "Raw Headcrab Meat", 0 }
--}

if (SERVER) then
	util.AddNetworkString( "DarkRP_StoveOpenMenu" )
	util.AddNetworkString( "DarkRP_StoveSpawnFood" )
	util.AddNetworkString( "DarkRP_StoveNotifyCantUse" )
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 1, "owning_ent")
end

function DarkRP.createStoveRecipe(recipe_name, recipe_ent, ingredients_ents)
	print( table.ToString( ENT.Ingredients, "Shit", true ) )
	if (!ENT.Recipes[recipe_name]) and (!ENT.Recipes[recipe_ent]) and (!ENT.Recipes[ingredients_ents]) then
		ENT.Recipes[recipe_ent] = { Name = tostring(recipe_name), Recipe_Ingredients = ingredients_ents }
		print( table.ToString( ENT.Recipes, "Recipe Shit", true ) )
	else
		error("This recipe has been added already.")
	end
end

function DarkRP.createStoveIngredient(ingredient_name, ingredient_ent)
	if (!ENT.Ingredients[ingredient_name]) and (!ENT.Ingredients[ingredient_ent]) then
		ENT.Ingredients[ingredient_ent] = { Name = tostring(ingredient_name), Amount = 0 }
		print( table.ToString( ENT.Ingredients, "Shit", true ) ) --IT FUCKING WORKS SCOOB AAAAAAAAAAAAAAAAAAAA
		PrintTable( table.GetKeys( ENT.Ingredients ) )
	else
		error("This ingredient has been added already.")
	end
end

include("customization.lua")