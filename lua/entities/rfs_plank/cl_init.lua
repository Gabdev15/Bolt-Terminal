/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")

--[[ All action of buttons ]]
local buttons = {
    ["place"] = {
        ["func"] = function(ent, args)
            net.Start("RFS:Cooking")
                net.WriteUInt(2, 5)
                net.WriteEntity(ent)
                net.WriteString(args[1])
            net.SendToServer()
        end,
    },
    ["remove"] = {
        ["func"] = function(ent, args)
            net.Start("RFS:Cooking")
                net.WriteUInt(4, 5)
                net.WriteEntity(ent)
            net.SendToServer()
        end,
    },
}

--[[ Init all variable of the terminal ]]
function ENT:Initialize()
    self.RFSInfo = self.RFSInfo or {
        ["use3D2D"] = true,
    }
end

function ENT:Draw()
    self:DrawModel()

    if not IsValid(RFS.LocalPlayer) then return end

    local distance = RFS.LocalPlayer:GetPos():DistToSqr(self:GetPos())
    if distance > 250000 then
        return 
    end

    if halo.RenderedEntity() == self then return end

    local pos = self:GetPos() + self:GetUp() * 1.8 + self:GetRight() * -8.5 + self:GetForward()*7
	local ang = self:GetAngles()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f
	
	ang:RotateAroundAxis(ang:Forward(), 0)
	ang:RotateAroundAxis(ang:Right(), 0)
	ang:RotateAroundAxis(ang:Up(), 180)

    self.LerpAlpha = self.LerpAlpha or 120
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
    
    RFS.Start3D2D(pos, ang, 0.05)
        local canPlace = (self:GetBodygroup(2) == 4)
        if canPlace then 
            local entSkin = self:GetSkin()
            
            local checkMouse = RFS.CheckMouse(self, 0, pos, ang, 270, -280, 40, 40, 0.05, buttons["remove"]["func"])
            
            self.lerpRotated = self.lerpRotated or 0
            self.lerpRotated = Lerp(FrameTime()*5, self.lerpRotated, (checkMouse and -10 or 0))

            surface.SetMaterial(RFS.Materials["trash"])
            surface.SetDrawColor(RFS.Colors["white"])
            surface.DrawTexturedRectRotated(300, -260, 40, 40, self.lerpRotated)
            
            local checkMouse = RFS.CheckMouse(self, 0, pos, ang, 45, -100, 200, 40, 0.05, buttons["place"]["func"], {(entSkin == 1 and "cuttedOnion" or "cuttedTomato"), (entSkin == 1 and "models/realistic_food_system/burger_onion.mdl" or "models/realistic_food_system/burger_tomato.mdl")})
            self.LerpAlpha = Lerp(FrameTime()*5, self.LerpAlpha, (checkMouse and 80 or 120))

            draw.RoundedBox(8, 45, -100, 200, 40, ColorAlpha(RFS.Colors["black18100"], self.LerpAlpha))
            draw.DrawText(RFS.GetSentence("move"), "RFS:Font:3D2D:02", 145, -90, RFS.Colors["white"], TEXT_ALIGN_CENTER) 
        end
    RFS.End3D2D()
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
