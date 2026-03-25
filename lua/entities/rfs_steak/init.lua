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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
	
	local ent = ents.Create(class)
	ent:SetPos(spawnPos)
	ent:SetAngles(spawnAng)
	ent:Spawn()
	ent:Activate()
	RFS.SetOwner(ent, ply)
	
	return ent
end

function ENT:Initialize()
	self:SetModel("models/realistic_food_system/burger_steak.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self.RFS = self.RFS or {}
	self.RFS["flipped"] = false
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

function ENT:Use(activator)
	if self.RFS["carbonised"] then self:Remove() end

	local grill = self.RFS["parentGrill"]
	if not IsValid(grill) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

	local placeId = self.RFS["placeId"]
    local steakTable = grill.RFS["steaks"][placeId] or {}
    
	local cookedTime = (steakTable["cookedTime"] - CurTime())
	if not isnumber(cookedTime) or cookedTime > 0 then return end

	if not self.RFS["flipped"] then
		RFS.TurnSteak(self, grill, placeId)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

	elseif not self.RFS["carbonised"] then
		net.Start("RFS:Cooking")
			net.WriteUInt(5, 5)
			net.WriteEntity(self)
			net.WriteString("steak")
		net.Send(activator)
	end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46

function ENT:StartTouch(ent)
	if ent:GetClass() == "rfs_grill" then
		RFS.Cooking.AddSteak(ent)
		self:Remove()
	end
end
