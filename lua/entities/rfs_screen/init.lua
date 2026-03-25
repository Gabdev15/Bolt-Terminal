/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

function ENT:SpawnFunction(ply, tr, class)
	if not tr.Hit then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2
	
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

function ENT:Initialize()
	self:SetModel("models/realistic_food_system/screen.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

	self.RFS = self.RFS or {}
    self.RFS["linkedTerminals"] = self.RFS["linkedTerminals"] or {}
end
