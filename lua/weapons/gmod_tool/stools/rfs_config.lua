/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

AddCSLuaFile()

TOOL.Category = "Realistic Fast Food"
TOOL.Name = "Setup Addon"
TOOL.Author = "Kobralost"

if CLIENT then 
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" },
	}

	language.Add("tool.rfs_config.name", RFS.GetSentence("toolTitle"))
	language.Add("tool.rfs_config.desc", RFS.GetSentence("toolDesc"))
	language.Add("tool.rfs_config.left", RFS.GetSentence("toolLeft"))
	language.Add("tool.rfs_config.right", RFS.GetSentence("toolRight"))
	language.Add("tool.rfs_config.reload", RFS.GetSentence("toolReload"))
end

local entitiesCanBeSpawn = {
	{
		["class"] = "rfs_distributor",
		["model"] = "models/realistic_food_system/distributor.mdl",
		["angle"] = Angle(0, 90, 0),
	},
	{
		["class"] = "rfs_terminal",
		["model"] = "models/realistic_food_system/terminal.mdl",
		["angle"] = Angle(0, 90, 0),
		["func"] = function(ent)
			ent:SetBodygroup(1, 1)
		end,
	},
	{
		["class"] = "rfs_screen",
		["model"] = "models/realistic_food_system/screen.mdl",
		["angle"] = Angle(0, -180, 0),
	},
}

local classCanBeSpawn = {
	["rfs_distributor"] = true,
	["rfs_terminal"] = true,
	["rfs_screen"] = true,
}

function TOOL:Deploy()
	if SERVER then
		RFS.SetNWVariable("rfs_tool_id", 1, self:GetOwner(), true, nil, false)
	end
end

function TOOL:LeftClick(trace)
	local ply = self:GetOwner()
	if not IsValid(ply) or not ply:IsPlayer() then return end
	if not RFS.AdminRank[ply:GetUserGroup()] then return end

	local curTime = CurTime()
	
	ply.RFS = ply.RFS or {}

	ply.RFS["toolSpam"] = ply.RFS["toolSpam"] or 0
    if ply.RFS["toolSpam"] > curTime then return end
    ply.RFS["toolSpam"] = curTime + 0.5
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46

	local pos = trace.HitPos
	local ent = ply:GetEyeTrace().Entity
	local class = ent:GetClass()
	
	local trace = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 300,
		filter = function(ent) if class == "prop_physics" then return true end end
	})
	
	if SERVER then
		if classCanBeSpawn[class] then return end
		
		local angSet = Angle(0, ply:GetAimVector():Angle().Yaw, 0)
		local toolId = RFS.GetNWVariables("rfs_tool_id", ply)

		RFS.AddEntitySaved(pos, (entitiesCanBeSpawn[toolId]["angle"] + angSet), entitiesCanBeSpawn[toolId]["class"])
	else
		if IsValid(ent) && class == "rfs_screen" or class == "rfs_terminal" then
			RFS.ToolLinkTerminals = RFS.ToolLinkTerminals or {}

			if not IsValid(RFS.CurrentSelection) then
				if class == "rfs_terminal" then return end				
				RFS.CurrentSelection = ent
				
			elseif RFS.CurrentSelection:GetClass() != class then
				RFS.ToolSelections[RFS.CurrentSelection] = RFS.ToolSelections[RFS.CurrentSelection] or {}
				RFS.ToolSelections[RFS.CurrentSelection][#RFS.ToolSelections[RFS.CurrentSelection] + 1] = ent
								
				net.Start("RFS:MainNet")
					net.WriteUInt(10, 5)
					net.WriteEntity(RFS.CurrentSelection)
					net.WriteEntity(ent)
				net.SendToServer()

				RFS.CurrentSelection = nil
				RFS.ToolSelections = nil
			end
		end
	end
end

function TOOL:RightClick(trace)
	if SERVER then
		if not IsValid(trace.Entity) then return end

		if classCanBeSpawn[trace.Entity:GetClass()] then
			RFS.RemoveEntitySaved(trace.Entity.uniqueId)
			trace.Entity:Remove()
		end
	else
		RFS.CurrentSelection = nil
		RFS.ToolSelections = nil
	end
end

function TOOL:Reload()
	if SERVER then
		local ply = self:GetOwner()
		local curTime = CurTime()

		ply.RFS = ply.RFS or {}

		ply.RFS["toolSpam"] = ply.RFS["toolSpam"] or 0
		if ply.RFS["toolSpam"] > curTime then return end
		ply.RFS["toolSpam"] = curTime + 0.5
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

		local toolId = RFS.GetNWVariables("rfs_tool_id", ply)

		local newValue = (toolId or 1) + 1
		if newValue > #entitiesCanBeSpawn then newValue = 1 end

		RFS.SetNWVariable("rfs_tool_id", newValue, ply, true, nil, false)
	end
end

function TOOL:CreateRFSEnt()
	if CLIENT then
		if not IsValid(RFS.ToolGunEnt) then
 			RFS.ToolGunEnt = ClientsideModel("models/breen.mdl", RENDERGROUP_OPAQUE)
			RFS.ToolGunEnt:SetModel("models/breen.mdl")
			RFS.ToolGunEnt:Spawn()
			RFS.ToolGunEnt:Activate()	
			RFS.ToolGunEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
		end
	end 
end

local vector0 = Vector(0, 0, 0)
function TOOL:Think()
	if CLIENT then
		local ply = self:GetOwner()
		if not IsValid(ply) and not ply:IsPlayer() then return end
		if not RFS.AdminRank[ply:GetUserGroup()] then return end

		local ent = RFS.LocalPlayer:GetEyeTrace().Entity
		local class = IsValid(ent) and ent:GetClass() or ""

		local trace = util.TraceLine({
			start = RFS.LocalPlayer:EyePos(),
			endpos = RFS.LocalPlayer:EyePos() + RFS.LocalPlayer:EyeAngles():Forward() * 300,
			filter = function(ent) if class == "prop_physics" then return true end end
		})

		if class == "rfs_screen" then
			RFS.DrawScreenLink = ent:EntIndex()
		else
			RFS.DrawScreenLink = nil
		end
		
		if not classCanBeSpawn[class] && not IsValid(RFS.CurrentSelection) then
			local toolId = RFS.GetNWVariables("rfs_tool_id", ply)

			if IsValid(RFS.ToolGunEnt) && entitiesCanBeSpawn[toolId] then
				if not isvector(self.RFSLerpPos) then self.RFSLerpPos = vector0 end
				self.RFSLerpPos = Lerp(RealFrameTime()*40, self.RFSLerpPos, trace.HitPos)

				local angSet = Angle(0, RFS.LocalPlayer:GetAimVector():Angle().Yaw, 0)
				
				RFS.ToolGunEnt:SetPos(self.RFSLerpPos)
				RFS.ToolGunEnt:SetAngles(entitiesCanBeSpawn[toolId]["angle"] + angSet)
				RFS.ToolGunEnt:SetModel(entitiesCanBeSpawn[toolId]["model"])

				if isfunction(entitiesCanBeSpawn[toolId]["func"]) then
					entitiesCanBeSpawn[toolId]["func"](RFS.ToolGunEnt)
				end
			else 
				self:CreateRFSEnt() 
			end
		else
			if IsValid(RFS.ToolGunEnt) then 
				RFS.ToolGunEnt:Remove()
			end
		end
	end
end 

function TOOL:Holster()
	if CLIENT then
		local ply = self:GetOwner()
		if not IsValid(ply) and not ply:IsPlayer() then return end
		if not RFS.AdminRank[ply:GetUserGroup()] then return end
		
		if IsValid(RFS.ToolGunEnt) then 
			RFS.ToolGunEnt:Remove()
		end

		RFS.CurrentSelection = nil
		RFS.ToolSelections = nil
	end
end

--[[ Draw beam for connection ]]
hook.Add("PostDrawTranslucentRenderables", "RFS:DrawTool:Connection", function()
	if not RFS or not RFS.LocalPlayer then return end
	RFS.ToolSelections = RFS.ToolSelections or {}

	local trace = util.TraceLine({
		start = RFS.LocalPlayer:EyePos(),
		endpos = (IsValid(traceEnt) && traceEnt:GetClass() == "rfs_terminal") and traceEnt:LocalToWorld(traceEnt:OBBCenter()) or RFS.LocalPlayer:EyePos() + RFS.LocalPlayer:EyeAngles():Forward() * 100,
		filter = function(ent) if ent:GetClass() != "player" then return true end end
	})

	for ent, entTable in pairs(RFS.ToolSelections) do
		if not IsValid(ent) then continue end
		
		for k, v in ipairs(entTable) do
			RFS.DrawBeam(ent, v, RFS.Colors["orange"])
		end
	end
	
	if IsValid(RFS.CurrentSelection) then
		RFS.DrawBeam(RFS.CurrentSelection, trace.HitPos, RFS.Colors["orange"])
	end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
	
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f
	
	local activeTool = RFS.LocalPlayer:GetTool()
	if activeTool && activeTool["Mode"] != "rfs_config" && IsValid(RFS.ToolGunEnt) then
		RFS.ToolGunEnt:Remove()
	end
end)
