/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

function ENT:Draw()
    self:DrawModel()

    local steaksTable = RFS.GetNWVariables("steaks", self) or {}
    
    for k, v in pairs(steaksTable) do
        local ent = Entity(v.entIndex)
        if not IsValid(ent) then continue end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46
        
        local pos = ent:GetPos() + ent:GetUp() * 5 + ent:GetRight() * -2.5
        local ang = ent:GetAngles()

        local calcul = v.cookedTime - CurTime()
        local cookedTime = math.Clamp(v.cookedTime - CurTime(), 0, RFS.SteakTime)
        local finished = (v.flipped && cookedTime <= 0)
        
        ent.RFS = ent.RFS or {}
        ent.RFS["pourcent"] = (RFS.SteakTime-cookedTime)/RFS.SteakTime
        
        ang:RotateAroundAxis(ang:Forward(), -0)
        ang:RotateAroundAxis(ang:Right(), 90)
        ang:RotateAroundAxis(ang:Up(), -90)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
        
        ent.ColorLerp = ent.ColorLerp or 255
        ent.ColorToGo = (v.flipped and 150 or 255)
        
        local colorToGo = math.Clamp(((ent.ColorToGo/RFS.SteakTime)*cookedTime), (v.flipped and 100 or 150), ent.ColorToGo)
        local carbonised = ((math.Clamp((math.abs(calcul)/RFS.CarboniseTime), 0, 1) >= 1) and v.flipped and calcul <= 0)
        local colorSteak = (carbonised and RFS.Colors["black2"] or Color(ent.ColorLerp, ent.ColorLerp, ent.ColorLerp))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3
        
        ent.ColorLerp = Lerp(FrameTime()*5, ent.ColorLerp, colorToGo)

        if finished && IsValid(RFSClientside) && RFSClientside.parentCase == ent then RFSClientside:SetColor(colorSteak) end

        cam.Start3D2D(pos, ang, 0.001)
            draw.RoundedBox(200, 0, 0, 5000, 1000, RFS.Colors["grey3"])
            draw.RoundedBox(200, 0, 0, 5000*ent.RFS["pourcent"], 1000, RFS.Colors["green"])

            if v.flipped && calcul <= 0 then

                draw.RoundedBox(200, 0, 0, 5000*math.Clamp((math.abs(calcul)/RFS.CarboniseTime), 0, 1), 1000, RFS.Colors["red4"])

                if carbonised then
                    ent.RFS["carbonised"] = true

                    surface.SetDrawColor(RFS.Colors["white"])
                    surface.SetMaterial(RFS.Materials["trash"])
                    surface.DrawTexturedRectRotated(2500, -2000, 2000, 2000, (math.sin(CurTime())*8))
                end
            end

            if not v.flipped && cookedTime <= 0 then
                ent.RFS["rotateArrow"] = ent.RFS["rotateArrow"] or 0
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

                if ent.RFS["rotateArrow"] >= 360 then ent.RFS["rotateArrow"] = 0 end
                ent.RFS["rotateArrow"] = ent.RFS["rotateArrow"] + 1

                surface.SetDrawColor(RFS.Colors["white"])
                surface.SetMaterial(RFS.Materials["returnArrow"])
                surface.DrawTexturedRectRotated(2500, -2000, 2000, 2000, -ent.RFS["rotateArrow"])
            end

            ent:SetColor(colorSteak)
        cam.End3D2D()
    end
end
