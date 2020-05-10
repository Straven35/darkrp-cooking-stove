AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include( "shared.lua" )

ENT.foodstuff = 5
ENT.foodModel = "models/props_junk/garbage_bag001a.mdl"
ENT.foodSound = "foodmod/eating.wav"

function ENT:SpawnFunction( ply, tr, class )
	if ( !tr.Hit ) then return end
	local pos = tr.HitPos + tr.HitNormal * 4
	local ent = ents.Create( class )
	ent:SetPos( pos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel( self.foodModel )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use( activator )
	if foodmod.mode == 1 then
		local health = activator:Health()
		activator:SetHealth( math.Clamp( ( health or 100 ) + foodstuff, 0, 100 ) )
	end
	
	if foodmod.mode == 2 then
		local energy = activator:getDarkRPVar("Energy")
		activator:setSelfDarkRPVar( "Energy", math.Clamp( (energy or 100) + 5, 0, 100 ) )
	end
	
	if foodmod.enablesound then
		activator:EmitSound( self.foodSound, 50, 100 )
	end
	self:Remove()
end