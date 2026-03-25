/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
	
	return ent
end

function ENT:Initialize()
	self:SetModel("models/realistic_food_system/carton.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)	
end

function ENT:Use(activator)
	if not RFS.FastFoodJob[team.GetName(activator:Team())] then
		activator:RFSNotification(5, RFS.GetSentence("notCooker"))
		return 
	end

	activator.RFS = activator.RFS or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
	
	local curtTime = CurTime()

	activator.RFS["boxSpam"] = activator.RFS["boxSpam"] or 0
	if activator.RFS["boxSpam"] > curtTime then return end
	activator.RFS["boxSpam"] = curtTime + 1
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

	net.Start("RFS:MainNet")
		net.WriteUInt(7, 5)
		net.WriteEntity(self)
	net.Send(activator)

	activator.RFS["boxSelected"] = true
end
