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
	BT.SetOwner(ent, ply)
	
	return ent
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

function ENT:Initialize()
	self:SetModel("models/bolt_terminal/terminal.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

	self.BT = self.BT or {}
    self.BT["linkedScreens"] = self.BT["linkedScreens"] or {}
    self.BT["orders"] = self.BT["orders"] or {}

	self:SetBodygroup(1, 1)
end
