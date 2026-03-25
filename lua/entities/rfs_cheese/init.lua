/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2
	
	return ent
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46

function ENT:Initialize()
	self:SetModel("models/realistic_food_system/burger_cheese.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)	
end

function ENT:StartTouch(ent)
	local class = ent:GetClass()

	if class == "rfs_condiment_container" then
		RFS.Cooking.ChangeQuantity(ent, "cheese", 4, 1)
		self:Remove()

	elseif class == "rfs_plank_burger" then
		local burger = ent.burger
        if not IsValid(burger) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

		RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_cheese.mdl")
		self:Remove()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
		
	end
end
