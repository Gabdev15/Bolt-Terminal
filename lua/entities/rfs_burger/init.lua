/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr, class)
	if not tr.Hit then return end
	
	local spawnPos = tr.HitPos + tr.HitNormal * 10
	local spawnAng = ply:EyeAngles()
	spawnAng.p = 0
	spawnAng.y = spawnAng.y + 180
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
	
	local ent = ents.Create(class)
	ent:SetPos(spawnPos)
	ent:SetAngles(spawnAng)
	ent:Spawn()
	ent:Activate()
	RFS.SetOwner(ent, ply)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
	
	return ent
end

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
end

function ENT:Use(activator)
	local wep = activator:GetWeapon("rfs_hand_burger")
	if IsValid(wep) then
		activator:RFSNotification(5, RFS.GetSentence("alreadyHaveSwep")) 
		return 
	end

	local parent = self:GetParent()
	if IsValid(parent) && parent:GetClass() == "rfs_plank_burger" then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

	self.RFS = self.RFS or {}

	if RFS.GiveSwep then
		local weapon = activator:Give("rfs_hand_burger")

		weapon.RFS = weapon.RFS or {}
		weapon.RFS["amountFood"] = (self.RFS["amountFood"] or 0)

		weapon.RFS["condiments"] = self.RFS["condiments"] or RFS.BaseBurger

		activator:SelectWeapon("rfs_hand_burger")
	else
		if not RFS.DisableSoundWhenEating then
			local soundBurger = CreateSound(activator, RFS.Sounds["eatSound"])
			soundBurger:Play()
		end

		activator:RFSEatSomething(self, (self.RFS["amountFood"] or 0))
	end

	self:Remove()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
