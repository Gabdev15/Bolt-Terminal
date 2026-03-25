/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

RFS.Notify = RFS.Notify or {}

function RFS.Notification(time, msg)
    if RFS.UseNotify then
        RFS.Notify[#RFS.Notify + 1] = {
            ["msg"] = msg,
            ["time"] = CurTime() + (time or 5),
            ["mat"] = RFS.Materials["burger"], 
        }
    else
        notification.AddLegacy(msg, NOTIFY_GENERIC, time)
    end
end

function RFS.DrawNotification()
    if RFS.Notify and #RFS.Notify > 0 then 
        for k,v in ipairs(RFS.Notify) do 
            surface.SetFont("RFS:Font:01")

            local sizeText = surface.GetTextSize(v.msg)

            if not isnumber(v.RLerp) then v.RLerp = -sizeText end 
            if not isnumber(v.RLerpY) then v.RLerpY = (RFS.ScrH*0.055*k)-RFS.ScrH*0.038 end

            if v.time > CurTime() then
                v.RLerp = Lerp(FrameTime()*3, v.RLerp, RFS.ScrW*0.02)
            else
                v.RLerp = Lerp(FrameTime()*3, v.RLerp, (-RFS.ScrW*0.25 - sizeText))
                if v.RLerp < (-RFS.ScrW*0.15 - sizeText) then 
                    RFS.Notify[k] = nil 
                    RFS.Notify = table.ClearKeys(RFS.Notify) 
                end
            end 
            
            v.RLerpY = Lerp(FrameTime()*8, v.RLerpY, (RFS.ScrH*0.055*k)-RFS.ScrH*0.038)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
 
            local posy = v.RLerpY
            local incline = RFS.ScrH*0.055
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

            local leftPart = {
                {x = v.RLerp, y = posy},
                {x = v.RLerp + incline + sizeText + RFS.ScrH*0.043, y = posy},
                {x = v.RLerp + RFS.ScrH*0.043 + sizeText + RFS.ScrH*0.043, y = posy + RFS.ScrH*0.043},
                {x = v.RLerp, y = posy + RFS.ScrH*0.043},
            }
            
            surface.SetDrawColor(RFS.Colors["black18220"])
            draw.NoTexture()
            surface.DrawPoly(leftPart)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

            local rightPart = {
                {x = v.RLerp, y = posy},
                {x = v.RLerp + incline, y = posy},
                {x = v.RLerp + RFS.ScrH*0.043, y = posy + RFS.ScrH*0.043},
                {x = v.RLerp, y = posy + RFS.ScrH*0.043},
            }
            
            surface.SetDrawColor(RFS.Colors["orange100"])
            draw.NoTexture()
            surface.DrawPoly(rightPart)

            surface.SetDrawColor(RFS.Colors["white"])
            surface.SetMaterial(v.mat)
            surface.DrawTexturedRect(v.RLerp + RFS.ScrW*0.006, v.RLerpY + RFS.ScrH*0.007, RFS.ScrH*0.027, RFS.ScrH*0.027)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

            draw.SimpleText(v.msg, "RFS:Font:01", v.RLerp + RFS.ScrW*0.037, v.RLerpY + RFS.ScrH*0.041/2, RFS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

hook.Add("DrawOverlay", "RFS:DrawOverlay:Notify", function()
    if IsValid(RFSMainFrame) then return end

    RFS.DrawNotification()
end)

net.Receive("RFS:Notification", function()
    local time = net.ReadUInt(3)
    local msg = net.ReadString()
    
    if RFS.UseNotify then
        RFS.Notification(time, msg)
    else
        notification.AddLegacy(msg, NOTIFY_GENERIC, time)
    end
end)
