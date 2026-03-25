/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")

--[[ All action of buttons ]]
local buttons = {
    ["activateService"] = {
        ["func"] = function(ent)
            net.Start("RFS:MainNet")
                net.WriteUInt(9, 5)
                net.WriteEntity(ent)
            net.SendToServer()
        end,
    },
}

--[[ Init all variable of the terminal ]]
function ENT:Initialize()
    self.RFSInfo = self.RFSInfo or {
        ["use3D2D"] = true, 
        ["stepId"] = 0,
    }
end

function ENT:Draw()
    self:DrawModel()
    
    if not IsValid(RFS.LocalPlayer) then RFS.LocalPlayer = LocalPlayer() return end

    local distance = RFS.LocalPlayer:GetPos():DistToSqr(self:GetPos())
    if distance > 250000 then
        return 
    end

    if halo.RenderedEntity() == self then return end

    local parent = self:GetChildren()
    if IsValid(parent[1]) then return end

    local animationY = 20*math.sin(CurTime()*2)

    local pos = self:GetPos() + self:GetUp() * 22 + self:GetRight() * 0
    local ang = RFS.LocalPlayer:EyeAngles()
    local camAng = Angle(0, ang.yaw - 90, 90)

    local isActivate = RFS.GetNWVariables("rfs_dishes_status", self)

    local timeEnd = RFS.GetNWVariables("rfs_dishes_timeEnd", self)
    local missionId = RFS.GetNWVariables("rfs_dishes_missionID", self)
    local maxTime = RFS.GetNWVariables("rfs_dishes_maxTime", self)

    RFS.Start3D2D(pos, camAng, 0.05)
        local checkMouse = RFS.CheckMouse(self, 0, pos, camAng, -150, 290 + animationY, 300, 60, 0.05, buttons["activateService"]["func"], {self})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

        self.LerpAlpha = self.LerpAlpha or 0
        self.LerpAlpha = Lerp(FrameTime()*5, self.LerpAlpha, (checkMouse and 255 or 200))

        draw.RoundedBox(10, -150, 290 + animationY, 300, 60, RFS.Colors["white234"])
        draw.DrawText(isActivate and RFS.GetSentence("disableDishes") or RFS.GetSentence("enableDishes"), "RFS:Font:3D2D:10", 0, 308 + animationY, ColorAlpha(RFS.Colors[(isActivate and "red3" or "orange2")], self.LerpAlpha), TEXT_ALIGN_CENTER)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2
        
        local missionTable = RFS.Missions[missionId]
        if isActivate && istable(missionTable) then
            local curTime = CurTime()
            local timeEndCalculate = math.Clamp(math.Round((timeEnd or curTime) - curTime), 0, maxTime)

            local faceId = math.Clamp(math.ceil(timeEndCalculate/(maxTime/(#RFS.Status + 1))), 1, #RFS.Status)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46

            draw.DrawText(RFS.GetSentence("prepareCommand"), "RFS:Font:3D2D:08", 0, -120 + animationY, RFS.Colors["white"], TEXT_ALIGN_CENTER)
            draw.DrawText(RFS.GetSentence("remainingTime"):format(timeEndCalculate), "RFS:Font:3D2D:09", 0, -70 + animationY, RFS.Colors["white"], TEXT_ALIGN_CENTER)
            
            surface.SetMaterial(RFS.Materials[RFS.Status[faceId]])
            surface.SetDrawColor(RFS.Colors["white"])
            surface.DrawTexturedRect(-75, -300 + animationY, 150, 150)
            
            draw.RoundedBox(20, -150, -25 + animationY, 300, 300, RFS.Colors["white234"])
        end

        render.SetStencilWriteMask(0xFF)
        render.SetStencilTestMask(0xFF)
        render.SetStencilReferenceValue(0)
        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        render.ClearStencil()

        render.SetStencilEnable(true)
        render.SetStencilReferenceValue(1)
        render.SetStencilCompareFunction(STENCIL_NEVER)
        render.SetStencilFailOperation(STENCIL_REPLACE)
        
            draw.RoundedBox(0, -125, 0 + animationY, 250, 250, RFS.Colors["white246200"])
        
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)
            local missionTable = RFS.Missions[missionId]
            if istable(missionTable) then

                local checkMouse = RFS.CheckMouse(self, 0, pos, camAng, -150, -25 + animationY, 300, 300, 0.05, {})
                if not checkMouse then
                    if RFS.RenderTarget["rfs_missions_"..missionId] then
                        surface.SetMaterial(RFS.RenderTarget["rfs_missions_"..missionId])
                        surface.SetDrawColor(ColorAlpha(RFS.Colors["white"], 255))
                        surface.DrawTexturedRect(-125, 0 + animationY, 250, 250)
                    end
                else
                    draw.DrawText(RFS.GetSentence("ingredientsList"), "RFS:Font:3D2D:03", 0, 10 + animationY - 8, RFS.Colors["black"], TEXT_ALIGN_CENTER)

                    missionTable["ingredientsTable"] = missionTable["ingredientsTable"] or {}
                    
                    local tableRevert = table.Reverse(missionTable["ingredientsTable"])

                    local tableToDraw, modelCount, modelAlreadyInList = {}, {}, {}

                    for k, v in pairs(tableRevert) do
                        modelCount[v] = (modelCount[v] and modelCount[v] + 1 or 1)

                        if modelAlreadyInList[v] then continue end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

                        tableToDraw[#tableToDraw + 1] = {
                            ["count"] = modelCount[v] + 1,
                            ["model"] = v,
                        }

                        modelAlreadyInList[v] = true
                    end
                    
                    for k, v in pairs(tableToDraw) do
                        if not isstring(v.model) then continue end
    
                        local name = RFS.ModelsToName[v.model]
                        if not isstring(name) then continue end
    
                        draw.DrawText(string.Left(RFS.GetSentence(name), 20).." X"..(modelCount[v.model] or 1), "RFS:Font:3D2D:02", 0, 23*k + animationY + 20, RFS.Colors["grey2"], TEXT_ALIGN_CENTER)
                    end
                end
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

        render.SetStencilEnable(false)
   RFS.End3D2D()
end
