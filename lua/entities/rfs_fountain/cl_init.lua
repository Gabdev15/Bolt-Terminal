/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")

--[[ All action of buttons ]]
local buttons = {
    ["previousSoda"] = {
        ["func"] = function(ent, args)
            net.Start("RFS:Cooking")
                net.WriteUInt(1, 5)
                net.WriteEntity(ent)
                net.WriteString(args[1])
            net.SendToServer()
        end,
    },
    ["nextSoda"] = {
        ["func"] = function(ent, args)
            net.Start("RFS:Cooking")
                net.WriteUInt(1, 5)
                net.WriteEntity(ent)
                net.WriteString(args[1])
            net.SendToServer()
        end,
    },
    ["startSoda"] = {
        ["func"] = function(ent, args)
            net.Start("RFS:Cooking")
                net.WriteUInt(1, 5)
                net.WriteEntity(ent)
                net.WriteString(args[1])
            net.SendToServer()
        end,
    },
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

function ENT:DrawMouse(ratio)
    local frameTime = FrameTime()

    --[[ Cursor Pos on terminal screen ]]
    self.lerpCursorX = self.lerpCursorX or 0
    self.lerpCursorY = self.lerpCursorY or 0
    
    if RFS.CursorPos && RFS.CursorPos.x && RFS.CursorPos.y then
        self.lerpCursorX = Lerp(frameTime*10, self.lerpCursorX, RFS.CursorPos.x/ratio)
        self.lerpCursorY = Lerp(frameTime*10, self.lerpCursorY, RFS.CursorPos.y/ratio)
        
        surface.SetMaterial(RFS.Materials["cursor"])
        surface.SetDrawColor(RFS.Colors["grey2"])
        surface.DrawTexturedRect(self.lerpCursorX, self.lerpCursorY, 30, 30)
    end
end

--[[ Init all variable of the terminal ]]
function ENT:Initialize()
    self.RFSInfo = self.RFSInfo or {
        ["use3D2D"] = true,
        ["sodaId"] = 1,
    }
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

function ENT:Draw()
    self:DrawModel()
    
    if not IsValid(RFS.LocalPlayer) then RFS.LocalPlayer = LocalPlayer() return end
    if RFS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) > 150000 then return end

    local color = RFS.GetNWVariables("rfs_soda_color", self:GetChildren()[1])
    if color then
        local colorToVector = Vector(color.r, color.g, color.b, color.a)
        colorToVector:Normalize()

        self.fluidcolor = colorToVector
    end

    local distance = RFS.LocalPlayer:GetPos():DistToSqr(self:GetPos())
    if distance > 250000 then
        return 
    end

    if halo.RenderedEntity() == self then return end

    local pos = self:GetPos() + self:GetUp() * 22 + self:GetRight() * -2.5 + self:GetForward()*-3.3
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Forward(), 0)
	ang:RotateAroundAxis(ang:Right(), 78)
	ang:RotateAroundAxis(ang:Up(), -90)
    
    RFS.Start3D2D(pos, ang, 0.05)

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
        
            draw.RoundedBox(10, -80, -60, 265, 120, RFS.Colors["white246200"])
        
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)
            
            local sodaId = RFS.GetNWVariables("rfs_soda_id", self) or 1
            if not isnumber(sodaId) then return end

            draw.RoundedBox(0, -80, -60, 265, 120, RFS.Colors["black0255"])
            draw.RoundedBox(0, -75, -55, 255, 110, RFS.Colors["white246200"])

            surface.SetMaterial(RFS.Materials["background"])
            surface.SetDrawColor(RFS.Colors["white25510"], self.LerpSoda)
            surface.DrawTexturedRect(-80, -60, 265, 120)
            
            local checkMouse = RFS.CheckMouse(self, 0, pos, ang, 20, -40, 60, 60, 0.05, buttons["startSoda"]["func"], {"startSoda"})

            self.LerpSoda = self.LerpSoda or 0
            self.LerpSoda = Lerp(FrameTime()*5, self.LerpSoda, checkMouse and 255 or 200)

            surface.SetMaterial(RFS.SodaList[sodaId]["mat"])
            surface.SetDrawColor(ColorAlpha(RFS.Colors["white"], self.LerpSoda))
            surface.DrawTexturedRect(20, -40, 60, 60)

            local checkMouse = RFS.CheckMouse(self, 0, pos, ang, -80, -20, 50, 50, 0.05, buttons["previousSoda"]["func"], {"previousSoda"})

            surface.SetMaterial(RFS.Materials["leftArrow"])
            surface.SetDrawColor(RFS.Colors["grey2"])
            surface.DrawTexturedRect(-80, -20, 50, 50)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

            local checkMouse = RFS.CheckMouse(self, 0, pos, ang, 135, -20, 50, 50, 0.05, buttons["nextSoda"]["func"], {"nextSoda"})

            surface.SetMaterial(RFS.Materials["rightArrow"])
            surface.SetDrawColor(RFS.Colors["grey2"])
            surface.DrawTexturedRect(135, -20, 50, 50)

            draw.DrawText(RFS.GetSentence(RFS.SodaList[sodaId]["uniqueName"]), "RFS:Font:3D2D:03", 50, 25, RFS.Colors["black200"], TEXT_ALIGN_CENTER)
    
            self:DrawMouse(0.05)

        render.SetStencilEnable(false)

   RFS.End3D2D()
end
