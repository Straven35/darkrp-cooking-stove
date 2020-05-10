AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("customization.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/furniturestove001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local physObj = self:GetPhysicsObject()
	physObj:Wake()
	physObj:SetMass(10)

	self.Damage = 100
	self.Sparking = false
end

function ENT:OnTakeDamage(dmg)
	self.Damage = self.Damage - dmg:GetDamage()
	if (self.Damage <= 0) then
		self:Destruct()
		self:Remove()
	end
end

function ENT:StartTouch(ent)
	--PrintTable( table.GetKeys( itSelf.Ingredients ) )
	--print( table.ToString( itSelf.Ingredients, "Ingredients: ", true ) )
	if (self.Ingredients[ent:GetClass()]) then
		--print ( tostring(itSelf.Ingredients[ent:GetClass()].Name) )
		--print ( tostring(itSelf.Ingredients[ent:GetClass()].Amount) )
		local ingredient = self.Ingredients[ent:GetClass()]
		local recipes = self.Recipes

		if (ingredient.Name != nil) then
			ingredient.Amount = ingredient.Amount + 1
			ent:Remove()
		end
	end
end

function ENT:Think()
	if (self.Sparking) then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(2)
		effectdata:SetScale(1)
		effectdata:SetRadius(2)
		util.Effect("Sparks", effectdata)
	end
end

function ENT:Use(activator, caller, useType, value)
	if (caller:IsPlayer()) then
		if ( self:Getowning_ent() == caller ) then
			net.Start( "DarkRP_StoveOpenMenu" )
			net.WriteTable( self.Ingredients )
			net.WriteTable( self.Recipes )
			net.WriteEntity( self ) --guess what! self isnt recgnized client side! yay!
			net.Send(caller)
		else
			net.Start( "DarkRP_StoveNotifyCantUse" )
			net.Send( caller )
		end
	end
end

--[[
	Creates an explosion effect around the stove.
]]--
function ENT:Destruct()
	local vPoint = self:GetPos() + Vector(0, 0, 50)
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end

--[[
	Remove the ingredients that were used on a recipe
]]--
local function RemoveUsedIngredients(recipe, t, titty)
	for ingredient, requiredAmount in pairs( t.Recipe_Ingredients ) do
		if ( ingredient ) then
			titty.Ingredients[ingredient].Amount = titty.Ingredients[ingredient].Amount - requiredAmount
		else
			error("Invalid ingredient name.")
		end
	end
end

--[[
	Receives a net message from client to spawn the specified food entity. boom
]]--
net.Receive( "DarkRP_StoveSpawnFood", function (len, ply)
	local recipeEnt = net.ReadString()
	local recipeTable = net.ReadTable()
	local entself = net.ReadEntity()
	
	entself.Sparking = true
	RemoveUsedIngredients(recipeEnt, recipeTable, entself)
	
	timer.Simple( Stove.SpawnDelay, function()
		local food = ents.Create(recipeEnt)
		food:SetPos(entself:GetPos() + Vector(0, 0, 25))
		food.SID = ply.SID --something about the owning player. idk yet
		food:Spawn()
		entself.Sparking = false
	end )
	
	Stove.SpawnDelay = Stove.SpawnDelay or 5
end)