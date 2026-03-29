/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/


BT.Terminal = BT.Terminal or {}

BT.Terminal.Information = BT.Terminal.Information or {
    ["selectedMenu"] = 0,
    ["tableToSend"] = {},
    ["terminal"] = nil,
}

BT.Terminal.ParamsModules = {
    {
        ["moduleName"] = "users",
        ["title"] = "manageUserTitle",
        ["desc"] = "manageUserDesc",
        ["img"] = BT.Materials["lock"],
        ["func"] = function(terminal, scroll)
            BT.Terminal.ManageUsers(terminal, scroll)
        end,
        ["onClose"] = function(terminal, moduleName)
            BT.Terminal.SaveSettings(terminal, moduleName)
        end,
    },
    {
        ["moduleName"] = "price",
        ["title"] = "managePriceTitle",
        ["desc"] = "managePriceDesc",
        ["img"] = BT.Materials["reduction"],
        ["func"] = function(terminal, scroll)
            BT.Terminal.ManagePrice(terminal, scroll)
        end,
        ["onClose"] = function(terminal, moduleName)
            BT.Terminal.SaveSettings(terminal, moduleName)
        end,
    },
    {
        ["moduleName"] = "quantity",
        ["title"] = "manageQuantityTitle",
        ["desc"] = "manageQuantityDesc",
        ["img"] = BT.Materials["boxes"],
        ["func"] = function(terminal, scroll)
            BT.Terminal.ManageQuantity(terminal, scroll)
        end,
        ["onClose"] = function(terminal, moduleName)
            BT.Terminal.SaveSettings(terminal, moduleName)
        end,
    },
}

--[[ Send settings table and save it serverSide ]]
function BT.Terminal.SaveSettings(terminal, moduleName)
    net.Start("BT:MainNet")
        net.WriteUInt(6, 5)
        net.WriteEntity(terminal)
        net.WriteUInt(table.Count(BT.Terminal.Information["tableToSend"]), 16)
        for k, v in pairs(BT.Terminal.Information["tableToSend"]) do
            local valueType = (IsColor(v) and "color" or type(v))
            
            net.WriteString(valueType)
            net.WriteString(k)
            
            net["Write"..BT.TypeNet[valueType]](v, ((BT.TypeNet[valueType] == "Int") and 32))
        end
        net.WriteString(moduleName)
    net.SendToServer()
end

--[[ Menu to manage use who can use the terminal ]]
function BT.Terminal.ManageUsers(terminal, scroll)
    scroll:Clear()
    
    BT.Terminal.Information["tableToSend"] = {}

    local terminalIndex = terminal:EntIndex()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

    BT.TerminalSettings = BT.TerminalSettings or {}
    BT.TerminalSettings[terminalIndex] = BT.TerminalSettings[terminalIndex] or {}
    BT.TerminalSettings[terminalIndex]["users"] = BT.TerminalSettings[terminalIndex]["users"] or {}

    local playerNumber = 0
    for k, v in ipairs(player.GetAll()) do
        if v == BT.LocalPlayer then continue end

        local cooker = vgui.Create("DPanel", scroll)
        cooker:Dock(TOP)
        cooker:DockMargin(0,0,0,6)
        cooker:SetSize(0, BT.ScrH*0.09)
        cooker.Paint = function(self, w, h)
            if not IsValid(v) then self:Remove() return end

            draw.RoundedBox(4, 0, 0, w, h, BT.Colors["black50"])
            draw.RoundedBox(4, -5, -5, w, h, BT.Colors["white"])

            draw.DrawText(v:Name(), "BT:Font:02", w*0.19, h*0.15, BT.Colors["grey2"], TEXT_ALIGN_LEFT)
            draw.DrawText(BT.GetSentence("permissionTerminal"), "BT:Font:01", w*0.19, h*0.4, BT.Colors["grey3"], TEXT_ALIGN_LEFT)
        end

        local avatarImage = vgui.Create("AvatarImage", cooker)
        avatarImage:SetSize(BT.ScrH*0.068, BT.ScrH*0.068)
        avatarImage:SetPos(BT.ScrW*0.005, BT.ScrW*0.005)
        avatarImage:SetPlayer(v, 64)

        local checkBox = vgui.Create("DImageButton", cooker)
        checkBox:SetSize(BT.ScrH*0.05, BT.ScrH*0.05)
        checkBox:SetPos(BT.ScrW*0.235, BT.ScrH*0.02)
        checkBox:SetText("")
        checkBox.isChecked = (BT.TerminalSettings[terminalIndex]["users"][v:SteamID64()] and true or false)
        checkBox:SetMaterial(checkBox.isChecked and BT.Materials["check"] or BT.Materials["uncheck"])
        checkBox:SetColor(BT.Colors["white255100"])
        checkBox.DoClick = function()
            checkBox.isChecked = !checkBox.isChecked
            checkBox:SetMaterial(checkBox.isChecked and BT.Materials["check"] or BT.Materials["uncheck"])

            BT.Terminal.Information["tableToSend"][v:SteamID64()] = checkBox.isChecked
        end

        playerNumber = playerNumber + 1
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

    scroll.Paint = function(self, w, h)
        if playerNumber <= 0 then
            draw.DrawText(BT.GetSentence("noManage"), "BT:Font:03", w*0.5, h*0.45, BT.Colors["grey3"], TEXT_ALIGN_CENTER)
        end
    end
end

--[[ Menu to manage price of ingredients, soda, fries ]]
function BT.Terminal.ManagePrice(terminal, scroll)
    scroll:Clear()
    BT.Terminal.Information["tableToSend"] = {}

    local terminalIndex = terminal:EntIndex()

    BT.TerminalSettings = BT.TerminalSettings or {}
    BT.TerminalSettings[terminalIndex] = BT.TerminalSettings[terminalIndex] or {}
    BT.TerminalSettings[terminalIndex]["price"] = BT.TerminalSettings[terminalIndex]["price"] or {}
    
    for k, v in ipairs(BT.BurgerElements) do
        if not v.canModify then continue end
        local maxPrice = BT.MaxPrice[v.uniqueName] or 100

        local elements = vgui.Create("DPanel", scroll)
        elements:Dock(TOP)
        elements:DockMargin(0,0,0,6)
        elements:SetSize(0, BT.ScrH*0.09)
        elements.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, BT.Colors["black50"])
            draw.RoundedBox(4, -5, -5, w, h, BT.Colors["white"])

            draw.DrawText(BT.GetSentence(v.uniqueName), "BT:Font:02", w*0.19, h*0.15, BT.Colors["grey2"], TEXT_ALIGN_LEFT)
            draw.DrawText(BT.GetSentence("configurePrice"):format(BT.formatMoney(maxPrice)), "BT:Font:01", w*0.19, h*0.4, BT.Colors["grey3"], TEXT_ALIGN_LEFT)
    
            surface.SetMaterial(v.mat)
            surface.SetDrawColor(BT.Colors["white"])
            surface.DrawTexturedRect(w*0.025, h*0.5-BT.ScrH*0.06/2, BT.ScrH*0.06, BT.ScrH*0.06)
        end

        local pricePanel = vgui.Create("DPanel", elements)
        pricePanel:SetSize(BT.ScrH*0.08, BT.ScrH*0.05)
        pricePanel:SetPos(BT.ScrW*0.215, BT.ScrH*0.017)
        pricePanel.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, BT.Colors["black25"])
        end

        local price = vgui.Create("DTextEntry", pricePanel)
        price:Dock(FILL)
        price:DockMargin(BT.ScrH*0.01, BT.ScrH*0.01, BT.ScrH*0.01, BT.ScrH*0.01)
        price:SetFont("BT:Font:01")
        price:SetContentAlignment(5)
        price:SetNumeric(true)
        price:SetDrawLanguageID(false)
        price.Paint = function(self, w, h)
            self:DrawTextEntryText(BT.Colors["black200"], BT.Colors["black200"], BT.Colors["black200"], BT.Colors["black200"])
        end
        
        local priceSettings = BT.TerminalSettings[terminalIndex]["price"][v.uniqueName]
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

        if priceSettings then
            price:SetValue(priceSettings)
        elseif BT.MaxPrice[v.uniqueName] && not priceSettings then
            price:SetValue(BT.MaxPrice[v.uniqueName])
        end

        price.OnChange = function(self)
            local value = tonumber(self:GetValue())
            if not isnumber(value) then return end

            BT.Terminal.Information["tableToSend"][v.uniqueName] = math.Clamp(value, 0, maxPrice)
        end
    end
end

--[[ Menu to manage quantities of ingredients, soda, fries ]]
function BT.Terminal.ManageQuantity(terminal, scroll)
    scroll:Clear()
    BT.Terminal.Information["tableToSend"] = {}

    local terminalIndex = terminal:EntIndex()

    BT.TerminalSettings = BT.TerminalSettings or {}
    BT.TerminalSettings[terminalIndex] = BT.TerminalSettings[terminalIndex] or {}
    BT.TerminalSettings[terminalIndex]["quantity"] = BT.TerminalSettings[terminalIndex]["quantity"] or {}

    for k, v in ipairs(BT.BurgerElements) do
        if not v.canModify then continue end
        local maxQuantity = BT.MaxQuantity[v.uniqueName] or 1

        local elements = vgui.Create("DPanel", scroll)
        elements:Dock(TOP)
        elements:DockMargin(0,0,0,6)
        elements:SetSize(0, BT.ScrH*0.09)
        elements.maxCount = 1
        elements.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, BT.Colors["black50"])
            draw.RoundedBox(4, -5, -5, w, h, BT.Colors["white"])

            draw.DrawText(BT.GetSentence(v.uniqueName), "BT:Font:02", w*0.19, h*0.15, BT.Colors["grey2"], TEXT_ALIGN_LEFT)
            draw.DrawText(BT.GetSentence("configureQuantity"):format(maxQuantity), "BT:Font:01", w*0.19, h*0.4, BT.Colors["grey3"], TEXT_ALIGN_LEFT)
            draw.DrawText(self.maxCount, "BT:Font:03", w*0.87, h*0.33, BT.Colors["grey3"], TEXT_ALIGN_CENTER)
    
            surface.SetMaterial(v.mat)
            surface.SetDrawColor(BT.Colors["white"])
            surface.DrawTexturedRect(w*0.025, h*0.5-BT.ScrH*0.06/2, BT.ScrH*0.06, BT.ScrH*0.06)
        end

        local leftArrow = vgui.Create("DImageButton", elements)
        leftArrow:SetSize(BT.ScrH*0.03, BT.ScrH*0.03)
        leftArrow:SetPos(BT.ScrW*0.215, BT.ScrH*0.028)
        leftArrow:SetText("")
        leftArrow:SetMaterial(BT.Materials["leftArrow"])
        leftArrow:SetColor(BT.Colors["grey"])
        leftArrow.DoClick = function(self)
            local newAmount = elements.maxCount - 1
            elements.maxCount = math.Clamp(newAmount, 1, maxQuantity)

            BT.Terminal.Information["tableToSend"][v.uniqueName] = elements.maxCount
        end

        local rightArrow = vgui.Create("DImageButton", elements)
        rightArrow:SetSize(BT.ScrH*0.03, BT.ScrH*0.03)
        rightArrow:SetPos(BT.ScrW*0.25, BT.ScrH*0.028)
        rightArrow:SetText("")
        rightArrow:SetMaterial(BT.Materials["rightArrow"])
        rightArrow:SetColor(BT.Colors["grey"])
        rightArrow.DoClick = function(self)
            local newAmount = elements.maxCount + 1
            elements.maxCount = math.Clamp(newAmount, 1, maxQuantity)

            BT.Terminal.Information["tableToSend"][v.uniqueName] = elements.maxCount
        end

        if BT.TerminalSettings[terminalIndex]["quantity"][v.uniqueName] then
            elements.maxCount = math.Clamp(BT.TerminalSettings[terminalIndex]["quantity"][v.uniqueName], 1, maxQuantity)
        end
    end
end

--[[ Modules selector ]]
function BT.Terminal.MainMenu(terminal, scroll)
    scroll:Clear()
    BT.Terminal.Information["selectedMenu"] = 0
    BT.Terminal.Information["tableToSend"] = {}

    for k,v in ipairs(BT.Terminal.ParamsModules) do
        local cat = vgui.Create("DPanel", scroll)
        cat:Dock(TOP)
        cat:DockMargin(0,0,0,6)
        cat:SetSize(0, BT.ScrH*0.09)
        cat.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, BT.Colors["black50"])
            draw.RoundedBox(4, -5, -5, w, h, BT.Colors["white"])
            
            draw.DrawText(BT.GetSentence(v.title), "BT:Font:02", w*0.19, h*0.15, BT.Colors["grey2"], TEXT_ALIGN_LEFT)
            draw.DrawText(BT.GetSentence(v.desc), "BT:Font:01", w*0.19, h*0.4, BT.Colors["grey3"], TEXT_ALIGN_LEFT)
            
            surface.SetMaterial(v.img)
            surface.SetDrawColor(BT.Colors["white"])
            surface.DrawTexturedRect(w*0.025, h*0.5-BT.ScrH*0.06/2, BT.ScrH*0.06, BT.ScrH*0.06)
        end
        
        local button = vgui.Create("DImageButton", cat)
        button:SetSize(BT.ScrH*0.05, BT.ScrH*0.05)
        button:SetPos(BT.ScrW*0.235, BT.ScrH*0.017)
        button:SetText("")
        button:SetMaterial(BT.Materials["settings"])
        button:SetColor(BT.Colors["white255100"])
        button.DoClick = function()
            v.func(terminal, scroll)
            BT.Terminal.Information["selectedMenu"] = k
        end
    end
end

--[[ Main menu, animations, titles and desc ]]
local settingsFrame, scroll
function BT.Terminal.Settings(terminal)
    if IsValid(settingsFrame) then settingsFrame:Remove() end
    
    BT.Terminal.Information["terminal"] = terminal

    settingsFrame = vgui.Create("DFrame")
    settingsFrame:SetSize(BT.ScrW*0.3, BT.ScrH*0.7)
    settingsFrame:SetPos(BT.ScrW*0.5-BT.ScrW*0.15, BT.ScrW*1.5)
    settingsFrame:MoveTo(settingsFrame:GetX(), BT.ScrH*0.2, 0.5, 0, 1)
    settingsFrame:ShowCloseButton(false)
    settingsFrame:SetDraggable(false)
    settingsFrame:SetTitle("")
    settingsFrame:MakePopup()
    settingsFrame.startTime = SysTime()
    settingsFrame.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, self.startTime)
        draw.RoundedBox(4, 0, 0, w, h, BT.Colors["white246"])
                            
        draw.DrawText(BT.GetSentence("configTerminalTitle"), "BT:Font:04", w/2, h*0.027, BT.Colors["grey2"], TEXT_ALIGN_CENTER)
        draw.DrawText(BT.GetSentence("configTerminalDesc"), "BT:Font:05", w/2, h*0.075, BT.Colors["grey2"], TEXT_ALIGN_CENTER)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

        draw.RoundedBox(8, w/2-w*0.4, h*0.12, w*0.8, 1, BT.Colors["grey4"])
    end

    scroll = vgui.Create("DScrollPanel", settingsFrame)
    scroll:Dock(FILL)
    scroll:DockMargin(BT.ScrW*0.01, BT.ScrH*0.07, BT.ScrW*0.008, BT.ScrH*0.105)
    scroll:GetVBar():SetSize(0,0)
    
    BT.Terminal.MainMenu(terminal, scroll)

    local lerpButton = 0
    local bottomButton = vgui.Create("DButton", settingsFrame)
    bottomButton:SetSize(BT.ScrW*0.278, BT.ScrH*0.06)
    bottomButton:SetPos(BT.ScrW*0.15-BT.ScrW*0.278/2, BT.ScrH*0.615)
    bottomButton:SetFont("BT:Font:04")
    bottomButton:SetText(BT.GetSentence("closeMenu"))
    bottomButton:SetTextColor(BT.Colors["white246"])
    bottomButton.Paint = function(self, w, h)
        lerpButton = Lerp(FrameTime()*5, lerpButton, (bottomButton:IsHovered() and 255 or 220))
        draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(BT.Colors["orange"], lerpButton))

        local selectedMenu = BT.Terminal.Information["selectedMenu"]
        if selectedMenu == 0 then
            bottomButton:SetText(BT.GetSentence("closeMenu"))
        else
            bottomButton:SetText(BT.GetSentence("saveAndClose"))
        end
    end
    bottomButton.DoClick = function()
        local selectedMenu = BT.Terminal.Information["selectedMenu"]
        if selectedMenu == 0 then
            settingsFrame:MoveTo(settingsFrame:GetX(), BT.ScrH*1.5, 0.5, 0, 1, function()
                if IsValid(settingsFrame) then settingsFrame:Remove() end
            end)
        else 
            if BT.Terminal.ParamsModules && BT.Terminal.ParamsModules[selectedMenu] && isfunction(BT.Terminal.ParamsModules[selectedMenu]["onClose"]) then
                BT.Terminal.ParamsModules[selectedMenu]["onClose"](terminal, BT.Terminal.ParamsModules[selectedMenu]["moduleName"])
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

            BT.Terminal.MainMenu(BT.Terminal.Information["terminal"], scroll)
        end
    end
end

--[[ Popup conditions d'utilisation (même style que le panel settings) ]]
local cguFrame
function BT.Terminal.OpenCGUPopup()
    if IsValid(cguFrame) then cguFrame:Remove() end

    local sw, sh = BT.ScrW, BT.ScrH
    local fw, fh = sw * 0.45, sh * 0.75

    cguFrame = vgui.Create("DFrame")
    cguFrame:SetSize(fw, fh)
    cguFrame:SetPos(sw * 0.5 - fw * 0.5, sw * 1.5)
    cguFrame:MoveTo(sw * 0.5 - fw * 0.5, sh * 0.5 - fh * 0.5, 0.5, 0, 1)
    cguFrame:ShowCloseButton(false)
    cguFrame:SetDraggable(false)
    cguFrame:SetTitle("")
    cguFrame:MakePopup()
    cguFrame.startTime = SysTime()
    cguFrame.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, self.startTime)
        draw.RoundedBox(4, 0, 0, w, h, BT.Colors["white246"])
        draw.DrawText("Conditions d'utilisation", "BT:Font:04", w / 2, h * 0.027, BT.Colors["grey2"], TEXT_ALIGN_CENTER)
        draw.RoundedBox(8, w * 0.05, h * 0.075, w * 0.9, 1, BT.Colors["grey4"])
    end

    local html = vgui.Create("DHTML", cguFrame)
    html:SetPos(fw * 0.025, fh * 0.09)
    html:SetSize(fw * 0.95, fh * 0.8)
    html:OpenURL(BT.CGUPdfUrl or "about:blank")
    html:SetAllowLua(false)

    local lerpClose = 0
    local closeBtn = vgui.Create("DButton", cguFrame)
    closeBtn:SetSize(fw * 0.9, fh * 0.07)
    closeBtn:SetPos(fw * 0.05, fh * 0.915)
    closeBtn:SetFont("BT:Font:04")
    closeBtn:SetText(BT.GetSentence("closeMenu"))
    closeBtn:SetTextColor(BT.Colors["white246"])
    closeBtn.Paint = function(self, w, h)
        lerpClose = Lerp(FrameTime() * 5, lerpClose, self:IsHovered() and 255 or 220)
        draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(BT.Colors["orange"], lerpClose))
    end
    closeBtn.DoClick = function()
        cguFrame:MoveTo(cguFrame:GetX(), sw * 1.5, 0.5, 0, 1, function()
            if IsValid(cguFrame) then cguFrame:Remove() end
        end)
    end
end

--[[ Get setting with key of a terminal ]]
function BT.Terminal.GetTerminalSetting(terminal, key)
    local terminalIndex = terminal:EntIndex()

    BT.TerminalSettings = BT.TerminalSettings or {}
    BT.TerminalSettings[terminalIndex] = BT.TerminalSettings[terminalIndex] or {}

    return BT.TerminalSettings[terminalIndex][key]
end

--[[ Receive all settings of the terminal ]]
net.Receive("BT:TerminalSettings", function()
    local uInt = net.ReadUInt(5)

    if uInt == 1 then
        local entCount = net.ReadUInt(16)
        BT.TerminalSettings = BT.TerminalSettings or {}
        
        for i=1, entCount do
            local terminalIndex = net.ReadUInt(16)
            local moduleCount = net.ReadUInt(16)
            
            BT.TerminalSettings[terminalIndex] = BT.TerminalSettings[terminalIndex] or {}
            
            for i=1, moduleCount do
                local moduleName = net.ReadString()
                local tableCount = net.ReadUInt(16)
    
                BT.TerminalSettings[terminalIndex][moduleName] = BT.TerminalSettings[terminalIndex][moduleName] or {}
                
                for i=1, tableCount do
                    local valueType = net.ReadString()
                    local key = net.ReadString()
                    local value = net["Read"..BT.TypeNet[valueType]](((BT.TypeNet[valueType] == "Int") and 32))
                
                    BT.TerminalSettings[terminalIndex][moduleName][key] = value
                end
            end
        end
    elseif uInt == 2 then
        if IsValid(scroll) then
            BT.Terminal.MainMenu(BT.Terminal.Information["terminal"], scroll)
        end
    end
end)
