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
	
	local ent = ents.Create(class)
	ent:SetPos(spawnPos)
	ent:SetAngles(spawnAng)
	ent:Spawn()
	ent:Activate()
	RFS.SetOwner(ent, ply)
	
	return ent
end

function ENT:Initialize()
	self:SetModel("models/realistic_food_system/fries_bag.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

function ENT:Use(activator)
	local wep = activator:GetWeapon("rfs_fries")
	if IsValid(wep) then
		activator:RFSNotification(5, RFS.GetSentence("alreadyHaveSwep"))  
		return 
	end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2
	
	if self:GetBodygroup(1) != 1 then return end
	
	if RFS.GiveSwep then
		activator:Give("rfs_fries")
		activator:SelectWeapon("rfs_fries")
	else
		if not RFS.DisableSoundWhenEating then
			local soundFries = CreateSound(activator, RFS.Sounds["eatSound"])
			soundFries:Play()
		end

		local amountFood = RFS.AmountFood[self:GetClass()]
		activator:RFSEatSomething(self, (amountFood or 0))
	end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

	self:Remove()
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

function ENT:StartTouch(ent)
	if ent:GetClass() == "rfs_fryer" && ent:GetSkin() == 1 && self:GetBodygroup(1) != 1 then
		RFS.Cooking.RemoveFries(0, ent)
		
		self:SetBodygroup(1, 1)
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
