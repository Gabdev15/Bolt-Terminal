/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

BT.Notify = BT.Notify or {}

function BT.Notification(time, msg)
    if BT.UseNotify then
        BT.Notify[#BT.Notify + 1] = {
            ["msg"] = msg,
            ["time"] = CurTime() + (time or 5),
            ["mat"] = BT.Materials["burger"], 
        }
    else
        notification.AddLegacy(msg, NOTIFY_GENERIC, time)
    end
end

function BT.DrawNotification()
    if BT.Notify and #BT.Notify > 0 then 
        for k,v in ipairs(BT.Notify) do 
            surface.SetFont("BT:Font:01")

            local sizeText = surface.GetTextSize(v.msg)

            if not isnumber(v.RLerp) then v.RLerp = -sizeText end 
            if not isnumber(v.RLerpY) then v.RLerpY = (BT.ScrH*0.055*k)-BT.ScrH*0.038 end

            if v.time > CurTime() then
                v.RLerp = Lerp(FrameTime()*3, v.RLerp, BT.ScrW*0.02)
            else
                v.RLerp = Lerp(FrameTime()*3, v.RLerp, (-BT.ScrW*0.25 - sizeText))
                if v.RLerp < (-BT.ScrW*0.15 - sizeText) then 
                    BT.Notify[k] = nil 
                    BT.Notify = table.ClearKeys(BT.Notify) 
                end
            end 
            
            v.RLerpY = Lerp(FrameTime()*8, v.RLerpY, (BT.ScrH*0.055*k)-BT.ScrH*0.038)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
 
            local posy = v.RLerpY
            local incline = BT.ScrH*0.055
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

            local leftPart = {
                {x = v.RLerp, y = posy},
                {x = v.RLerp + incline + sizeText + BT.ScrH*0.043, y = posy},
                {x = v.RLerp + BT.ScrH*0.043 + sizeText + BT.ScrH*0.043, y = posy + BT.ScrH*0.043},
                {x = v.RLerp, y = posy + BT.ScrH*0.043},
            }
            
            surface.SetDrawColor(BT.Colors["black18220"])
            draw.NoTexture()
            surface.DrawPoly(leftPart)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

            local rightPart = {
                {x = v.RLerp, y = posy},
                {x = v.RLerp + incline, y = posy},
                {x = v.RLerp + BT.ScrH*0.043, y = posy + BT.ScrH*0.043},
                {x = v.RLerp, y = posy + BT.ScrH*0.043},
            }
            
            surface.SetDrawColor(BT.Colors["orange100"])
            draw.NoTexture()
            surface.DrawPoly(rightPart)

            surface.SetDrawColor(BT.Colors["white"])
            surface.SetMaterial(v.mat)
            surface.DrawTexturedRect(v.RLerp + BT.ScrW*0.006, v.RLerpY + BT.ScrH*0.007, BT.ScrH*0.027, BT.ScrH*0.027)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

            draw.SimpleText(v.msg, "BT:Font:01", v.RLerp + BT.ScrW*0.037, v.RLerpY + BT.ScrH*0.041/2, BT.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

hook.Add("DrawOverlay", "BT:DrawOverlay:Notify", function()
    if IsValid(RFSMainFrame) then return end

    BT.DrawNotification()
end)

net.Receive("BT:Notification", function()
    local time = net.ReadUInt(3)
    local msg = net.ReadString()
    
    if BT.UseNotify then
        BT.Notification(time, msg)
    else
        notification.AddLegacy(msg, NOTIFY_GENERIC, time)
    end
end)
