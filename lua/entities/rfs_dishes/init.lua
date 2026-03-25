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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
	
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f
	
	return ent
end

function ENT:Initialize()
	self:SetModel("models/realistic_food_system/dishes.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)	
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

function ENT:StartTouch(ent)
	ent.RFS = ent.RFS or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46

	self.RFS = self.RFS or {}

	local dishesMission = self.RFS["mission"]
    if not dishesMission or not isnumber(dishesMission["missionId"]) then return end

	if ent.RFS["distributor"] then
		local owner = RFS.GetOwner(ent)
		if IsValid(owner) then
			owner:RFSNotification(5, RFS.GetSentence("cantSellOrderDistributor"))
		end
		return 
	end

	local missionTable = RFS.Missions[dishesMission["missionId"]]
	if not istable(missionTable) then return end

	if isfunction(missionTable["check"]) then
		if not missionTable["check"](ent) then return end
	end

	RFS.Cooking.DishesCheckMission(self, ent)
end
