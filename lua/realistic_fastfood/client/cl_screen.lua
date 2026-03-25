/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

RFS.Screen = RFS.Screen or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

RFS.Screen.Information = RFS.Screen.Information or {
    ["tableToSend"] = {},
}

--[[ Send settings table and save it serverSide ]]
function RFS.Screen.SaveSettings(screen)
    net.Start("RFS:MainNet")
        net.WriteUInt(8, 5)
        net.WriteEntity(screen)
        net.WriteUInt(table.Count(RFS.Screen.Information["tableToSend"]), 16)
        for k, v in pairs(RFS.Screen.Information["tableToSend"]) do
            local valueType = (IsColor(v) and "color" or type(v))
            
            net.WriteString(valueType)
            net.WriteString(k)
            
            net["Write"..RFS.TypeNet[valueType]](v, ((RFS.TypeNet[valueType] == "Int") and 32))
        end
    net.SendToServer()
end

--[[ Main menu, animations, titles and desc ]]
local settingsFrame, scroll
function RFS.Screen.Settings(screen)
    local screenIndex = screen:EntIndex()

    if IsValid(settingsFrame) then settingsFrame:Remove() end
    
    settingsFrame = vgui.Create("DFrame")
    settingsFrame:SetSize(RFS.ScrW*0.3, RFS.ScrH*0.7)
    settingsFrame:SetPos(RFS.ScrW*0.5-RFS.ScrW*0.15, RFS.ScrW*1.5)
    settingsFrame:MoveTo(settingsFrame:GetX(), RFS.ScrH*0.2, 0.5, 0, 1)
    settingsFrame:ShowCloseButton(false)
    settingsFrame:SetDraggable(false)
    settingsFrame:SetTitle("")
    settingsFrame:MakePopup()
    settingsFrame.startTime = SysTime()
    settingsFrame.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, self.startTime)
        draw.RoundedBox(4, 0, 0, w, h, RFS.Colors["white246"])
                            
        draw.DrawText(RFS.GetSentence("configScreenTitle"), "RFS:Font:04", w/2, h*0.027, RFS.Colors["grey2"], TEXT_ALIGN_CENTER)
        draw.DrawText(RFS.GetSentence("configScreenDesc"), "RFS:Font:05", w/2, h*0.075, RFS.Colors["grey2"], TEXT_ALIGN_CENTER)

        draw.RoundedBox(8, w/2-w*0.4, h*0.12, w*0.8, 1, RFS.Colors["grey4"])
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

    local playerNumber = 0

    scroll = vgui.Create("DScrollPanel", settingsFrame)
    scroll:Dock(FILL)
    scroll:DockMargin(RFS.ScrW*0.01, RFS.ScrH*0.075, RFS.ScrW*0.008, RFS.ScrH*0.12)
    scroll:GetVBar():SetSize(0,0)
    scroll.Paint = function(self, w, h)
        if playerNumber <= 0 then
            draw.DrawText(RFS.GetSentence("noManageScreen"), "RFS:Font:03", w*0.5, h*0.45, RFS.Colors["grey3"], TEXT_ALIGN_CENTER)
        end
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

    RFS.ScreenSettings = RFS.ScreenSettings or {}
    RFS.ScreenSettings[screenIndex] = RFS.ScreenSettings[screenIndex] or {}

    for k, v in ipairs(player.GetAll()) do
        if not RFS.FastFoodJob[team.GetName(v:Team())] or v == RFS.LocalPlayer then continue end

        local cooker = vgui.Create("DPanel", scroll)
        cooker:Dock(TOP)
        cooker:DockMargin(0,0,0,6)
        cooker:SetSize(0, RFS.ScrH*0.09)
        cooker.Paint = function(self, w, h)
            if not IsValid(v) then self:Remove() return end

            draw.RoundedBox(4, 0, 0, w, h, RFS.Colors["black50"])
            draw.RoundedBox(4, -5, -5, w, h, RFS.Colors["white"])

            draw.DrawText(v:Name(), "RFS:Font:02", w*0.19, h*0.15, RFS.Colors["grey2"], TEXT_ALIGN_LEFT)
            draw.DrawText(RFS.GetSentence("permissionScreen"), "RFS:Font:01", w*0.19, h*0.4, RFS.Colors["grey3"], TEXT_ALIGN_LEFT)
        end

        local avatarImage = vgui.Create("AvatarImage", cooker)
        avatarImage:SetSize(RFS.ScrH*0.068, RFS.ScrH*0.068)
        avatarImage:SetPos(RFS.ScrW*0.005, RFS.ScrW*0.005)
        avatarImage:SetPlayer(v, 64)

        local checkBox = vgui.Create("DImageButton", cooker)
        checkBox:SetSize(RFS.ScrH*0.05, RFS.ScrH*0.05)
        checkBox:SetPos(RFS.ScrW*0.235, RFS.ScrH*0.02)
        checkBox:SetText("")
        checkBox.isChecked = (RFS.ScreenSettings[screenIndex][v:SteamID64()] and true or false)
        checkBox:SetMaterial(checkBox.isChecked and RFS.Materials["check"] or RFS.Materials["uncheck"])
        checkBox:SetColor(RFS.Colors["white255100"])
        checkBox.DoClick = function()
            checkBox.isChecked = !checkBox.isChecked
            checkBox:SetMaterial(checkBox.isChecked and RFS.Materials["check"] or RFS.Materials["uncheck"])

            RFS.Screen.Information["tableToSend"][v:SteamID64()] = checkBox.isChecked
        end

        playerNumber = playerNumber + 1
    end
    
    local lerpButton = 0
    local bottomButton = vgui.Create("DButton", settingsFrame)
    bottomButton:SetSize(RFS.ScrW*0.278, RFS.ScrH*0.06)
    bottomButton:SetPos(RFS.ScrW*0.15-RFS.ScrW*0.278/2, RFS.ScrH*0.615)
    bottomButton:SetFont("RFS:Font:04")
    bottomButton:SetText(RFS.GetSentence("saveAndClose"))
    bottomButton:SetTextColor(RFS.Colors["white246"])
    bottomButton.Paint = function(self, w, h)
        lerpButton = Lerp(FrameTime()*5, lerpButton, (bottomButton:IsHovered() and 255 or 220))
        draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(RFS.Colors["orange"], lerpButton))
    end
    bottomButton.DoClick = function()
        settingsFrame:MoveTo(settingsFrame:GetX(), RFS.ScrH*1.5, 0.5, 0, 1, function()
            if IsValid(settingsFrame) then settingsFrame:Remove() end
        end)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

        RFS.Screen.SaveSettings(screen)
    end
end

net.Receive("RFS:ScreenSettings", function()
    local uInt = net.ReadUInt(5)

    --[[ Get screen settings ]]
    if uInt == 1 then
        local entCount = net.ReadUInt(16)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

        RFS.ScreenSettings = RFS.TerminalSettings or {}

        for i=1, entCount do
            local screenIndex = net.ReadUInt(16)
            local tableCount = net.ReadUInt(16)

            RFS.ScreenSettings[screenIndex] = RFS.ScreenSettings[screenIndex] or {}
            
            for i=1, tableCount do
                local steamId64 = net.ReadString()
                local allowed = net.ReadBool()

                RFS.ScreenSettings[screenIndex][steamId64] = allowed
            end
        end

    elseif uInt == 2 then
        if IsValid(scroll) then
            -- RFS.Screen.Settings(RFS.Screen.Information["terminal"], scroll)
        end
    end
end)
