include("shared.lua")

-- first off.. what did the great zealot change? well for starters... everything here is now a local function! yay! less shit.

-- second off... this is basically a crafting system. if someone wants to go through this shit and re-name stuff or re-do the GUI,
-- go on ahead. i dont care. I didn't make the original system, but I modified it for entities. So please keep my signature in the
-- customization.lua!

--[[
function ENT:Initialize()

end]]

function ENT:Draw()
	self:DrawModel()
end

--[[
	Returns the size of the text to fit in a component.
]]--
local function GetTextSize(text)
	return (string.len(text) * 5) + 15, 20
end

--[[
	Checks if the stove has the required amount of ingredients to bake the
	recipe.
]]--
local function CanBake(Recipe, value, ingredients)
	local canBake = true
	local rec_Ingredients = value.Recipe_Ingredients
	
	if (rec_Ingredients != nil) then
		print ( "got past checkpoint 1" )
		for ing, requiredAmount in pairs(rec_Ingredients) do
			print ( "got past checkpoint 2" )
			local ingredient = ingredients[ing]
			
			print ( "ultimate" )
			print ( table.ToString( ingredients[ing], false ) )
			
			local ing_key = ingredient
			local ing_value = nil

			if (ingredient.Amount < requiredAmount) then
				print ( "got past checkpoint 3" )
				canBake = false
			else
				canBake = true
			end
		end
	else
		canBake = false
	end

	return canBake
end

--[[
	Sends a request to server-side to spawn the food with the given name
]]--
local function SendBakeRequest(Recipe, value, theself)
	net.Start( "DarkRP_StoveSpawnFood" )
	net.WriteString( Recipe )
	net.WriteTable( value )
	net.WriteEntity( theself )
	net.SendToServer()
end

--[[
	Adds a new recipe to the recipes menu.
]]--
local function AddRecipeOption(categoryList, Recipe, value, ingredients, myself, form)
	local gap, height, items = 10, 10, 0
	local recipe_name = value.Name
	local RecipeIngredient = value.Recipe_Ingredients
	
	local category = categoryList:Add(recipe_name)
	
	local ing_key = nil
	local ing_value = nil
	
	--print ( "clientside: " .. recipe_name ) 
	--print ( "clientside: " .. RecipeIngredient )
	--print ( table.ToString( RecipeIngredient, false ) )
	
	local panel = vgui.Create("DPanel", category)
	panel:SetPos(10, 30)

	for Ing, amountNeeded in pairs(RecipeIngredient) do
		local ingredient = ingredients

		ing_key = Ing
		ing_value = ingredient[ing_key]
		
		print ( "\nNEW INGREDIENT SHIT" )
		print ( Ing )
		print ( ing_key )
		print ( ing_value.Amount )
		print ( ing_value.Name )
		print ( amountNeeded )
		
		if (ingredient != nil) then
			local text = ing_value.Amount .. "/" .. amountNeeded .. " - " .. ing_value.Name
			local label = vgui.Create("DLabel", panel)
			label:SetPos(10, 10 + (gap * items) + (height * items))
			label:SetText(text)
			label:SetSize(GetTextSize(text))
			
			if (ing_value.Amount >= amountNeeded) then
				label:SetColor(Color(0, 0, 0))
			else
				label:SetColor(Color(155, 0, 0))
			end

			items = items + 1
		end
	end

	local button = vgui.Create("DButton", panel)
	button:SetPos(10, 15 + (gap * items) + (height * items))
	button:SetText(recipe_name)
	button:SetSize(GetTextSize(recipe_name))
	button.DoClick = function()
		SendBakeRequest(Recipe, value, myself)
		form:Close()
	end

	if (not CanBake(Recipe, value, ingredients)) then
		button:SetDisabled(true)
	end

	items = items + 1
	panel:SetSize(275, 30 + (gap * items) + (height * items))
end

--[[
	Open the menu window.
]]--
net.Receive( "DarkRP_StoveOpenMenu", function (len, ply)
	Ingredients = net.ReadTable()
	Recipes = net.ReadTable()
	itSelf = net.ReadEntity()
	
	print ( table.ToString( Ingredients, "Recipe Ingredients: ", true ) )
	print ( table.ToString( Recipes, "Recipes: ", true ) )

	local form = vgui.Create("DFrame")
	form:SetPos(870, 370)
	form:SetSize(300, 400)
	form:SetTitle("Stove - Recipes")
	form:SetVisible(true)
	form:SetDraggable(true)
	form:SetBackgroundBlur(true)
	form:SetMouseInputEnabled(true)
	form:SetKeyboardInputEnabled(true)
	form:MakePopup()

	local categoryList = vgui.Create("DCategoryList", form)
	categoryList:SetPos(0, 25)
	categoryList:SetSize(300, 375);

	for Recipe, value in pairs(Recipes) do
		AddRecipeOption(categoryList, Recipe, value, Ingredients, itSelf, form)
	end
end)

--[[
	Notify the player that he is not the owner of the stove he is trying to
	use.
]]--
net.Receive( "DarkRP_StoveNotifyCantUse", function (len, ply)
	notification.AddLegacy("You can't use this stove as it's not yours.", NOTIFY_GENERIC, 5)
end)