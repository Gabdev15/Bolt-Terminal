/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

function ENT:SpawnFunction(ply, tr, class)
	if not tr.Hit then return end
	
	local spawnPos = tr.HitPos + tr.HitNormal * 10
	local spawnAng = ply:EyeAngles()
	spawnAng.p = 0
	spawnAng.y = spawnAng.y + 180
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
	
	local ent = ents.Create(class)
	ent:SetPos(spawnPos)
	ent:SetAngles(spawnAng)
	ent:Spawn()
	ent:Activate()
	RFS.SetOwner(ent, ply)
	
	return ent
end

function ENT:Initialize()
	self:SetModel("models/realistic_food_system/cup.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
end

function ENT:Use(activator)
	local wep = activator:GetWeapon("rfs_cup")
	if IsValid(wep) then
		activator:RFSNotification(5, RFS.GetSentence("alreadyHaveSwep")) 
		return 
	end

	local fluidColor = RFS.GetNWVariables("rfs_soda_color", self)
	if not IsColor(fluidColor) then return end

	if RFS.GiveSwep then
		activator:Give("rfs_cup")
		activator:SelectWeapon("rfs_cup")

		local wep = activator:GetWeapon("rfs_cup")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46

		RFS.SetNWVariable("rfs_soda_color", fluidColor, activator, true, nil, true)
	else
		if not RFS.DisableSoundWhenEating then
			local soundSoda = CreateSound(activator, RFS.Sounds["drinkSound"])
			soundSoda:Play()
		end

		local amountFood = RFS.AmountFood[self:GetClass()]
		activator:RFSEatSomething(self, (amountFood or 0))
	end

	self:Remove()
end

function ENT:StartTouch(ent)
	if ent:GetClass() == "rfs_fountain" && self:GetBodygroup(1) == 0 then
		local owner = RFS.GetOwner(ent)

		RFS.Cooking.CreateSodaCup(ent, owner)
		self:Remove()
	end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
