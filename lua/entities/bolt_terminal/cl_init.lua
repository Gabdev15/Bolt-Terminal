/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")


--[[ Popup de saisie dans le thème du terminal ]]
local boltInputFrame
local function OpenBoltInput(title, placeholder, isPassword, callback)
    if IsValid(boltInputFrame) then boltInputFrame:Remove() end

    local fw = BT.ScrW * 0.28
    local fh = BT.ScrH * 0.26

    boltInputFrame = vgui.Create("DFrame")
    boltInputFrame:SetSize(fw, fh)
    boltInputFrame:SetPos(BT.ScrW * 0.5 - fw * 0.5, BT.ScrW * 1.5)
    boltInputFrame:MoveTo(boltInputFrame:GetX(), BT.ScrH * 0.5 - fh * 0.5, 0.35, 0, 1)
    boltInputFrame:ShowCloseButton(false)
    boltInputFrame:SetDraggable(false)
    boltInputFrame:SetTitle("")
    boltInputFrame:MakePopup()
    boltInputFrame.startTime = SysTime()
    boltInputFrame.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, self.startTime)
        draw.RoundedBox(8, 0, 0, w, h, BT.Colors["white246"])
        draw.DrawText(title, "BT:Font:04", w * 0.5, h * 0.07, BT.Colors["grey2"], TEXT_ALIGN_CENTER)
        draw.RoundedBox(4, w * 0.5 - w * 0.4, h * 0.22, w * 0.8, 1, BT.Colors["grey4"])
    end

    -- Champ de saisie
    local showPass = false
    local eyeBtnW = isPassword and math.Round(fh * 0.2) or 0

    local entryBg = vgui.Create("DPanel", boltInputFrame)
    entryBg:SetPos(fw * 0.08, fh * 0.32)
    entryBg:SetSize(fw * 0.84, fh * 0.22)

    local entry = vgui.Create("DTextEntry", entryBg)
    entry:Dock(FILL)
    entry:DockMargin(BT.ScrH * 0.01, BT.ScrH * 0.008, isPassword and (eyeBtnW + 6) or BT.ScrH * 0.01, BT.ScrH * 0.008)
    entry:SetFont("BT:Font:03")
    entry:SetPlaceholderText(placeholder)
    entry:SetDrawLanguageID(false)
    entry.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        if isPassword then
            local val = self:GetValue()
            local font = "BT:Font:03"
            surface.SetFont(font)
            local _, textH = surface.GetTextSize("A")
            local cy = math.Round(h * 0.5 - textH * 0.5)
            if val == "" then
                draw.DrawText(placeholder, font, w * 0.5, cy, Color(150, 150, 150), TEXT_ALIGN_CENTER)
            elseif showPass then
                draw.DrawText(val, font, w * 0.5, cy, BT.Colors["grey2"], TEXT_ALIGN_CENTER)
            else
                draw.DrawText(string.rep("*", #val), font, w * 0.5, cy, BT.Colors["grey2"], TEXT_ALIGN_CENTER)
            end
        else
            self:DrawTextEntryText(BT.Colors["grey2"], Color(0, 218, 90), BT.Colors["grey2"])
        end
    end

    -- Bordure verte sur le conteneur quand le champ a le focus
    entryBg.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, entry:HasFocus() and Color(0, 218, 90) or Color(210, 210, 210))
        draw.RoundedBox(6, 1, 1, w - 2, h - 2, Color(242, 242, 242))
    end

    -- Bouton œil pour afficher/masquer le mot de passe
    if isPassword then
        local entryBgH = math.Round(fh * 0.22)
        local eyeBtn = vgui.Create("DButton", entryBg)
        eyeBtn:SetPos(math.Round(fw * 0.84) - eyeBtnW - 4, 4)
        eyeBtn:SetSize(eyeBtnW, entryBgH - 8)
        eyeBtn:SetText("")
        eyeBtn.Paint = function(self, w, h)
            local cx, cy = w * 0.5, h * 0.5
            local ew = math.Round(w * 0.75)
            local eh = math.Round(h * 0.42)
            local ex = math.Round(cx - ew * 0.5)
            local ey = math.Round(cy - eh * 0.5)
            local col = showPass and Color(0, 218, 90) or Color(140, 140, 140)
            -- contour de l'œil
            draw.RoundedBox(math.Round(eh * 0.5), ex, ey, ew, eh, col)
            -- intérieur blanc
            draw.RoundedBox(math.Round(eh * 0.5) - 1, ex + 1, ey + 1, ew - 2, eh - 2, Color(242, 242, 242))
            -- pupille
            local pr = math.Round(eh * 0.32)
            draw.RoundedBox(pr, math.Round(cx - pr), math.Round(cy - pr), pr * 2, pr * 2, col)
            -- barre diagonale si masqué
            if not showPass then
                surface.SetDrawColor(140, 140, 140, 200)
                surface.DrawLine(math.Round(cx - ew * 0.3), math.Round(cy + eh * 0.4), math.Round(cx + ew * 0.3), math.Round(cy - eh * 0.4))
            end
        end
        eyeBtn.DoClick = function()
            showPass = not showPass
            entry:RequestFocus()
        end
    end

    entry:RequestFocus()

    local function confirm()
        local val = entry:GetValue()
        boltInputFrame:MoveTo(boltInputFrame:GetX(), BT.ScrW * 1.5, 0.3, 0, 1, function()
            if IsValid(boltInputFrame) then boltInputFrame:Remove() end
        end)
        if isfunction(callback) then callback(val) end
    end

    entry.OnEnter = confirm

    -- Bouton Confirmer (orange terminal)
    local lerpConfirm = 0
    local confirmBtn = vgui.Create("DButton", boltInputFrame)
    confirmBtn:SetPos(fw * 0.08, fh * 0.63)
    confirmBtn:SetSize(fw * 0.84, fh * 0.22)
    confirmBtn:SetText("")
    confirmBtn.Paint = function(self, w, h)
        lerpConfirm = Lerp(FrameTime() * 5, lerpConfirm, self:IsHovered() and 255 or 220)
        draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(BT.Colors["orange"], lerpConfirm))
        draw.DrawText("Confirmer", "BT:Font:03", w * 0.5, h * 0.5 - BT.ScrH * 0.013, BT.Colors["white"], TEXT_ALIGN_CENTER)
    end
    confirmBtn.DoClick = confirm
end

--[[ All action of buttons ]]
local buttons = {
    ["nextStep"] = {
        ["func"] = function(ent)
            if BT.TerminalSelected != nil && BT.TerminalSelected != ent then
                BT.Notification(5, BT.GetSentence("alreadyOnATerminal"))
                return
            end
            if ent.loaderActive then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

            if ent.RFSInfo["stepId"] == 1 then
                net.Start("BT:MainNet")
                    net.WriteUInt(3, 5)
                net.SendToServer()
                return
            elseif ent.RFSInfo["stepId"] == 2 then
                if not (ent.RFSInfo["currentCommand"] and ent.RFSInfo["currentCommand"]["voiture"]) then
                    BT.Notification(5, "Veuillez sélectionner une voiture.")
                    return
                end
            elseif ent.RFSInfo["stepId"] == 3 then
                ent.RFSInfo["currentCommand"] = ent.RFSInfo["currentCommand"] or {}
                ent.RFSInfo["orderList"] = ent.RFSInfo["orderList"] or {}

                ent.RFSInfo["orderList"][#ent.RFSInfo["orderList"] + 1] = ent.RFSInfo["currentCommand"]
                ent.RFSInfo["currentCommand"] = {}
                ent.RFSInfo["stepId"] = 5
                return
            elseif ent.RFSInfo["stepId"] == 5 then
                if not ent.RFSInfo["cguAccepted"] then
                    BT.Notification(5, "Veuillez accepter les conditions d'utilisation.")
                    return
                end
                -- Activate truck loader for 4 seconds, then send payment
                ent.loaderActive = true
                ent.loaderStartTime = CurTime()
                local orderListCopy = {}
                for k, v in pairs(ent.RFSInfo["orderList"]) do
                    orderListCopy[k] = v
                end
                timer.Simple(4, function()
                    if not IsValid(ent) then return end
                    ent.loaderActive = false
                    net.Start("BT:MainNet")
                        net.WriteUInt(4, 5)
                        net.WriteUInt(#orderListCopy, 6)
                        for k, v in pairs(orderListCopy) do
                            local order = ""
                            for key, value in pairs(v) do
                                order = order..(order == "" and "" or ";")..key..":"..value
                            end
                            net.WriteString(order)
                            net.WriteUInt((v.quantity or 1), 5)
                        end
                    net.SendToServer()
                end)
                return
            elseif ent.RFSInfo["stepId"] == 6 then
                ent.RFSInfo["stepId"] = 1
                BT.TerminalSelected = nil
                return
            elseif ent.RFSInfo["stepId"] == 8 then
                ent.RFSInfo["stepId"] = 5
                return
            end

            ent.RFSInfo["stepId"] = math.Clamp(ent.RFSInfo["stepId"] + 1, 0, 5)
        end,
    },
    ["burgerQuantityValue"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["orderList"] = ent.RFSInfo["orderList"] or {}

            local orderId = args[2]

            ent.RFSInfo["orderList"][orderId]["quantity"] = ent.RFSInfo["orderList"][orderId]["quantity"] or 1
            ent.RFSInfo["orderList"][orderId]["quantity"] = math.Clamp(ent.RFSInfo["orderList"][orderId]["quantity"] + (args[1] and 1 or -1), 0, BT.MaxMenu)

            ent.RFSInfo["orderScrollId"] = math.Clamp(ent.RFSInfo["orderScrollId"] + 1, (-#ent.RFSInfo["orderList"] + 3), 0)

            if ent.RFSInfo["orderList"][orderId]["quantity"] == 0 then
                table.remove(ent.RFSInfo["orderList"], orderId)
            end
        end,
    },
    ["priusQuantity"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["currentCommand"] = ent.RFSInfo["currentCommand"] or {}

            local settings = BT.Terminal.GetTerminalSetting(ent, "quantity") or {}

            local defaultMax = (BT.MaxQuantity["prius"] or 5)
            local settingMax = (settings["prius"] or defaultMax)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
            
            settingMax = math.Clamp(settingMax, 0, defaultMax)

            ent.RFSInfo["currentCommand"]["prius"] = math.Clamp((ent.RFSInfo["currentCommand"]["prius"] or 1) + (args[1] and 1 or -1), 1, settingMax)
        end,
    },
    ["newOrder"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["stepId"] = 2
        end,
    },
    ["removeBurger"] = {
        ["func"] = function(ent, args)
            table.remove(ent.RFSInfo["orderList"], args[1])
        end,
    },
    ["scrollOrderList"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["orderScrollId"] = math.Clamp(ent.RFSInfo["orderScrollId"] + (args[1] and 1 or -1), (-#ent.RFSInfo["orderList"] + 3), 0)
        end,
    },
    ["settings"] = {
        ["func"] = function(ent, args)
            BT.Terminal.Settings(ent)
        end,
    },
    ["chooseVoiture"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["currentCommand"] = ent.RFSInfo["currentCommand"] or {}
            ent.RFSInfo["currentCommand"]["voiture"] = args[1]
        end,
    },
    ["toggleCGU"] = {
        ["func"] = function(ent)
            ent.RFSInfo["cguAccepted"] = not ent.RFSInfo["cguAccepted"]
        end,
    },
    ["viewCGU"] = {
        ["func"] = function(ent)
            BT.Terminal.OpenCGUPopup()
        end,
    },
    ["boltLogin"] = {
        ["func"] = function(ent)
            ent.RFSInfo["boltEmail"] = ent.RFSInfo["boltEmail"] or ""
            ent.RFSInfo["boltPass"]  = ent.RFSInfo["boltPass"]  or ""
            ent.RFSInfo["stepId"] = 8
        end,
    },
    ["boltLogout"] = {
        ["func"] = function(ent)
            ent.RFSInfo["boltUser"]  = nil
            ent.RFSInfo["boltEmail"] = ""
            ent.RFSInfo["boltPass"]  = ""
        end,
    },
    ["boltEditEmail"] = {
        ["func"] = function(ent)
            OpenBoltInput("Adresse email", "Jason.Reed@gmail.com", false, function(str)
                ent.RFSInfo["boltEmail"] = str
            end)
        end,
    },
    ["boltEditPass"] = {
        ["func"] = function(ent)
            OpenBoltInput("Mot de passe", "Mot de passe", true, function(str)
                ent.RFSInfo["boltPass"] = str
            end)
        end,
    },
    ["boltSubmit"] = {
        ["func"] = function(ent)
            local email = ent.RFSInfo["boltEmail"] or ""
            local pass  = ent.RFSInfo["boltPass"]  or ""
            if email == "" or pass == "" then
                BT.Notification(5, "Veuillez remplir tous les champs.")
                return
            end
            if ent.RFSInfo["boltLoading"] then return end
            ent.RFSInfo["boltLoading"] = true
            HTTP({
                url     = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD_4LikVG5yUw0UnpGn1gCYId2pyhQhCuM",
                method  = "POST",
                headers = { ["Content-Type"] = "application/json" },
                body    = util.TableToJSON({ email = email, password = pass, returnSecureToken = true }),
                success = function(code, body)
                    ent.RFSInfo["boltLoading"] = false
                    local data = util.JSONToTable(body) or {}
                    if code == 200 and data.localId then
                        local name = (data.displayName and data.displayName ~= "") and data.displayName or data.email
                        ent.RFSInfo["boltUser"] = name
                        ent.RFSInfo["stepId"]   = 5
                        BT.Notification(3, "Connecté en tant que " .. name)
                    else
                        local msg = (data.error and data.error.message) or "Identifiants incorrects"
                        BT.Notification(5, "Échec : " .. msg)
                    end
                end,
                failed = function()
                    ent.RFSInfo["boltLoading"] = false
                    BT.Notification(5, "Impossible de contacter Firebase.")
                end,
            })
        end,
    },
    ["changeDuration"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["currentCommand"] = ent.RFSInfo["currentCommand"] or {}
            ent.RFSInfo["currentCommand"]["duration"] = ent.RFSInfo["currentCommand"]["duration"] or 1
            ent.RFSInfo["currentCommand"]["duration"] = math.Clamp(ent.RFSInfo["currentCommand"]["duration"] + (args[1] and 1 or -1), 1, 99)
        end,
    },
}

--[[ Init all variable of the terminal ]]
function ENT:Initialize()
    self.RFSInfo = self.RFSInfo or {
        ["use3D2D"] = true, 
        ["stepId"] = 1,
        ["orderList"] = {},
        ["currentCommand"]  = {},
    }
end

function ENT:DrawMouse(ratio)
    if BT.LocalPlayer:GetPos():DistToSqr(self:GetPos()) > 20000 then return end
    local frameTime = FrameTime()

    --[[ Cursor Pos on terminal screen ]]
    self.lerpCursorX = self.lerpCursorX or 0
    self.lerpCursorY = self.lerpCursorY or 0
    
    if BT.CursorPos && BT.CursorPos.x && BT.CursorPos.y then
        self.lerpCursorX = Lerp(frameTime*10, self.lerpCursorX, BT.CursorPos.x/ratio)
        self.lerpCursorY = Lerp(frameTime*10, self.lerpCursorY, BT.CursorPos.y/ratio)
        
        surface.SetMaterial(BT.Materials["cursor"])
        surface.SetDrawColor(BT.Colors["grey2"])
        surface.DrawTexturedRect(self.lerpCursorX, self.lerpCursorY, 30, 30)
    end
end

function ENT:GetTotalOrderPrice()
    local price = 0

    for commandeId, commandeTable in ipairs(self.RFSInfo["orderList"]) do
        if commandeTable.voiture then
            local duration = commandeTable.duration or 1
            local priceEnt = BT.Terminal.GetTerminalSetting(self, "price") or {}
            local priceHeure = priceEnt["prius"] or BT.MaxPrice["prius"] or 700
            price = price + math.floor(duration * priceHeure * 1.05)
        else
            local priceEnt = BT.Terminal.GetTerminalSetting(self, "price") or {}
            for k, v in pairs(commandeTable) do
                price = price + (((priceEnt[k] or BT.MaxPrice[k]) or 0)*(k == "soda" and 1 or v))*(commandeTable.quantity or 1)
            end
        end
    end

    return price
end

function ENT:GetCurrentOrderPrice()
    local price = BT.BasePriceWithoutIngredients or 200
    
    for k, v in pairs(self.RFSInfo["currentCommand"]) do
        local priceEnt = BT.Terminal.GetTerminalSetting(self, "price") or {}

        price = price + (((priceEnt[k] or BT.MaxPrice[k]) or 0)* (k == "soda" and 1 or v))
    end

    return price
end

function ENT:Draw()
    self:DrawModel()
    
    if not IsValid(BT.LocalPlayer) then BT.LocalPlayer = LocalPlayer() return end

    local distance = BT.LocalPlayer:GetPos():DistToSqr(self:GetPos())
    if distance > 250000 then
        self:ResetOrder()
        return
    end

    if halo.RenderedEntity() == self then return end

    local frameTime = FrameTime()
    local pos = self:GetPos() + self:GetUp() * 96.6 + self:GetForward() * 18.5 + self:GetRight() * -6.9
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -180)

    BT.Start3D2D(pos, ang, 0.1)
        local sizeX, sizeY = 370, 545
        local halfSizeX = sizeX/2

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
        
            draw.RoundedBox(0, 0, 0, sizeX, sizeY, BT.Colors["white"])
        
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)
        
            --[[ background of the terminal (step 1) ]]
            draw.RoundedBox(0, 0, 0, sizeX, sizeY, BT.Colors["white246"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

            self.lerpText = self.lerpText or 0
            self.lerpText = Lerp(frameTime*5, self.lerpText, (self.RFSInfo["stepId"] == 2 and 0 or self.RFSInfo["stepId"] == 3 and -200 or self.RFSInfo["stepId"] == 4 and -400 or self.RFSInfo["stepId"] == 5 and -600 or self.RFSInfo["stepId"] == 6 and -800 or self.RFSInfo["stepId"] == 8 and -600 or 200))
            
            surface.SetMaterial(BT.Materials["burger"])
            surface.SetDrawColor(BT.Colors["white"])
            surface.DrawTexturedRect(halfSizeX-50, -130 + self.lerpText, 100, 100)

            self.lerpQuantity = self.lerpQuantity or 0
            self.lerpQuantity = Lerp(frameTime*5, self.lerpQuantity, (self.RFSInfo["stepId"] == 2 and 180 or 0))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
            
            local grey = ColorAlpha(BT.Colors["grey"], self.lerpQuantity)

            if self.RFSInfo["stepId"] == 1 then
                draw.DrawText(BT.GetSentence("welcome"), "BT:Font:3D2D:01", halfSizeX, 30 + self.lerpText, BT.Colors["black"], TEXT_ALIGN_CENTER)
            else
                draw.DrawText(BT.GetSentence("makeYourBurger"), "BT:Font:3D2D:01", halfSizeX, 10 + self.lerpText, BT.Colors["black"], TEXT_ALIGN_CENTER)
                draw.DrawText(BT.GetSentence("makeYourBurger2"), "BT:Font:3D2D:01", halfSizeX, 50 + self.lerpText, BT.Colors["black"], TEXT_ALIGN_CENTER)
            end
            if self.RFSInfo["stepId"] == 1 then
                draw.DrawText(BT.GetSentence("firstInstruction"), "BT:Font:3D2D:02", halfSizeX, 90 + self.lerpText, BT.Colors["black"], TEXT_ALIGN_CENTER)
            end
            
            --[[ Only draw selected terminal to optimise ]]
            if BT.TerminalSelected == self then

                --[[ Customise your burger (step 2) ]] 
                self.lerpElements = self.lerpElements or 0
                self.lerpElements = Lerp(frameTime*5, self.lerpElements, (self.RFSInfo["stepId"] == 2) and 255 or 0)

                local orange = ColorAlpha(BT.Colors["orange"], self.lerpQuantity)

                --[[ Car selection (step 2) ]]
                if self.RFSInfo["stepId"] == 2 then
                    local carNames = {"Toyota Prius", "Nissan Leaf", "Tesla"}
                    local selectedCar = self.RFSInfo["currentCommand"] and self.RFSInfo["currentCommand"]["voiture"]
                    local displayName = selectedCar and carNames[selectedCar] or "-"
                    draw.DrawText("Voiture : " .. displayName, "BT:Font:3D2D:02", halfSizeX, 400 + self.lerpText, grey, TEXT_ALIGN_CENTER)

                    local carList = {
                        {name = "Toyota Prius",  dispo = true},
                        {name = "Nissan Leaf",   dispo = false},
                        {name = "Tesla",         dispo = false},
                    }
                    local cardW, cardH = 220, 50
                    local startX = halfSizeX - cardW / 2
                    self.RFSInfo["currentCommand"] = self.RFSInfo["currentCommand"] or {}

                    for i, car in ipairs(carList) do
                        local y = 150 + (i - 1) * 70
                        local isSelected = self.RFSInfo["currentCommand"]["voiture"] == i
                        if car.dispo then
                            local checkMouse = BT.CheckMouse(self, 2, pos, ang, startX, y + self.lerpText, cardW, cardH, 0.1, buttons["chooseVoiture"]["func"], {i})
                            local bgColor = isSelected and BT.Colors["orange"] or (checkMouse and ColorAlpha(BT.Colors["orange"], 120) or ColorAlpha(BT.Colors["grey"], 80))
                            draw.RoundedBox(8, startX, y + self.lerpText, cardW, cardH, bgColor)
                            draw.DrawText(car.name, "BT:Font:3D2D:03", halfSizeX, y + 13 + self.lerpText, BT.Colors["black"], TEXT_ALIGN_CENTER)
                        else
                            draw.RoundedBox(8, startX, y + self.lerpText, cardW, cardH, ColorAlpha(BT.Colors["grey"], 40))
                            draw.DrawText(car.name .. " - Bientot disponible", "BT:Font:3D2D:04", halfSizeX, y + 18 + self.lerpText, ColorAlpha(BT.Colors["black"], 120), TEXT_ALIGN_CENTER)
                        end
                    end
                end

                --[[ Résumé du panier (step 3) ]]
                self.lerpExtra = self.lerpExtra or 0
                self.lerpExtra = Lerp(frameTime*5, self.lerpExtra, (self.RFSInfo["stepId"] == 3 and 180 or 0))

                self.lerpBlack = self.lerpBlack or 0
                self.lerpBlack = Lerp(frameTime*5, self.lerpBlack, (self.RFSInfo["stepId"] == 3 and 255 or 0))

                if self.RFSInfo["stepId"] > 2 && self.RFSInfo["stepId"] < 4 then
                    local black  = ColorAlpha(BT.Colors["black"], self.lerpBlack)
                    local grey   = ColorAlpha(BT.Colors["grey"],  self.lerpExtra)
                    local orange = ColorAlpha(BT.Colors["orange"], self.lerpExtra)

                    local carNames = {"Toyota Prius", "Nissan Leaf", "Tesla"}
                    local voitureId   = self.RFSInfo["currentCommand"]["voiture"]
                    local voitureName = voitureId and carNames[voitureId] or "Aucune"

                    self.RFSInfo["currentCommand"]["duration"] = self.RFSInfo["currentCommand"]["duration"] or 1
                    local duration    = self.RFSInfo["currentCommand"]["duration"]
                    local priceSettings = BT.Terminal.GetTerminalSetting(self, "price") or {}
                    local priceHeure  = priceSettings["prius"] or BT.MaxPrice["prius"] or 700
                    local subtotal    = duration * priceHeure
                    local tax         = math.floor(subtotal * 0.05)
                    local total       = subtotal + tax

                    -- ═══ Image Toyota Prius ═══
                    local imgW, imgH = 160, 105
                    local imgX = halfSizeX - imgW / 2
                    local imgY = 225 + self.lerpText
                    surface.SetMaterial(BT.Materials["prius"])
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.DrawTexturedRect(imgX, imgY, imgW, imgH)

                    -- Voiture sélectionnée
                    draw.DrawText("Voiture : " .. voitureName, "BT:Font:3D2D:03", halfSizeX, 338 + self.lerpText, black, TEXT_ALIGN_CENTER)

                    -- Sélecteur de durée
                    local checkMinus = BT.CheckMouse(self, 3, pos, ang, halfSizeX - 95, 373 + self.lerpText, 25, 25, 0.1, buttons["changeDuration"]["func"], {false})
                    draw.DrawText("-", "BT:Font:3D2D:02", halfSizeX - 85, 367 + self.lerpText, checkMinus and orange or grey, TEXT_ALIGN_CENTER)

                    draw.DrawText(duration .. " heure" .. (duration > 1 and "s" or ""), "BT:Font:3D2D:03", halfSizeX, 373 + self.lerpText, black, TEXT_ALIGN_CENTER)

                    local checkPlus = BT.CheckMouse(self, 3, pos, ang, halfSizeX + 70, 373 + self.lerpText, 25, 25, 0.1, buttons["changeDuration"]["func"], {true})
                    draw.DrawText("+", "BT:Font:3D2D:02", halfSizeX + 85, 367 + self.lerpText, checkPlus and orange or grey, TEXT_ALIGN_CENTER)

                    -- Séparateur
                    draw.RoundedBox(1, halfSizeX - 110, 410 + self.lerpText, 220, 1, grey)

                    -- Détail des prix
                    draw.DrawText("Prix / heure : " .. BT.formatMoney(priceHeure),                          "BT:Font:3D2D:03", halfSizeX, 425 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    draw.DrawText("Durée : " .. duration .. " heure" .. (duration > 1 and "s" or ""),        "BT:Font:3D2D:03", halfSizeX, 458 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    draw.DrawText("Sous-total : " .. BT.formatMoney(subtotal),                               "BT:Font:3D2D:03", halfSizeX, 491 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    draw.DrawText("Taxe (5%) : " .. BT.formatMoney(tax),                                     "BT:Font:3D2D:03", halfSizeX, 524 + self.lerpText, grey,  TEXT_ALIGN_CENTER)

                    -- Séparateur
                    draw.RoundedBox(1, halfSizeX - 110, 558 + self.lerpText, 220, 1, grey)

                    -- Total
                    draw.DrawText("TOTAL : " .. BT.formatMoney(total), "BT:Font:3D2D:02", halfSizeX, 572 + self.lerpText, BT.Colors["black"], TEXT_ALIGN_CENTER)
                end
                

                --[[ does the payement is approved or no ]]
                self.lerpFinalPayement = self.lerpFinalPayement or 0
                self.lerpFinalPayement = Lerp(frameTime*5, self.lerpFinalPayement, (self.RFSInfo["stepId"] == 6 and 240 or 0))

                if self.RFSInfo["stepId"] > 5 && self.RFSInfo["stepId"] < 7 then
                    local black = ColorAlpha(BT.Colors["black"], self.lerpFinalPayement)
                    local white = ColorAlpha(BT.Colors["white"], self.lerpFinalPayement)

                    draw.DrawText(BT.GetSentence("payementTitle"), "BT:Font:3D2D:01", halfSizeX, 830 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    draw.DrawText(BT.GetSentence("payementDescription"), "BT:Font:3D2D:02", halfSizeX, 870 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    
                    draw.DrawText("#"..(self.RFSInfo["orderUniqueId"] or 0), "BT:Font:3D2D:02", halfSizeX, 895 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    
                    surface.SetMaterial(BT.Materials["approved"])
                    surface.SetDrawColor(white)
                    surface.DrawTexturedRect(halfSizeX-50, 1000 + self.lerpText, 100, 100)
                end
            else
                --[[ Check if the player can manage users ]]
                local accessUsers = {}
                if IsValid(BT.LocalPlayer) then
                    accessUsers = BT.Terminal.GetTerminalSetting(self, "users") or {}
                end

                local lp = BT.LocalPlayer
                local isTerminalOwner = IsValid(lp) and BT.GetOwner(self) == lp
                local isRFSAdmin     = IsValid(lp) and BT.AdminRank[lp:GetUserGroup()]
                if isTerminalOwner or isRFSAdmin then
                    local checkMouse = BT.CheckMouse(self, 0, pos, ang, 300, 20, 45, 45, 0.1, buttons["settings"]["func"])
            
                    self.lerpRotated = self.lerpRotated or 0
                    self.lerpRotated = Lerp(frameTime*5, self.lerpRotated, (checkMouse and -90 or 0))
        
                    surface.SetMaterial(BT.Materials["settings"])
                    surface.SetDrawColor(BT.Colors["grey2"])
                    surface.DrawTexturedRectRotated(320, 40, 45, 45, self.lerpRotated)
                end
            end
            
            --[[ Draw buttons for step 5 ]]
            if self.RFSInfo["stepId"] > 3 && self.RFSInfo["stepId"] < 6 then
                local black = ColorAlpha(BT.Colors["black"], self.lerpFinal)
                local white = ColorAlpha(BT.Colors["white"], self.lerpFinal)
                local black2 = ColorAlpha(BT.Colors["black50"], self.lerpFinal-200)
                
                if #self.RFSInfo["orderList"] == 0 then
                    draw.DrawText(BT.GetSentence("emptyBasket"), "BT:Font:3D2D:02", halfSizeX, 850 + self.lerpText, black, TEXT_ALIGN_CENTER)
    
                    surface.SetMaterial(BT.Materials["basket"])
                    surface.SetDrawColor(white)
                    surface.DrawTexturedRect(sizeX/2-50, 750 + self.lerpText, 100, 100)
                elseif #self.RFSInfo["orderList"] > 3 then
                    local checkMouse = BT.CheckMouse(self, 5, pos, ang, 300, 920 + self.lerpText, 30, 30, 0.1, buttons["scrollOrderList"]["func"], {true})
                    surface.SetMaterial(BT.Materials["upArrow"])
                    surface.SetDrawColor(white)
                    surface.DrawTexturedRect(300, 920 + self.lerpText, 30, 30)
                
                    local checkMouse = BT.CheckMouse(self, 5, pos, ang, 320, 920 + self.lerpText, 30, 30, 0.1, buttons["scrollOrderList"]["func"], {false})
                    surface.SetMaterial(BT.Materials["downArrow"])
                    surface.SetDrawColor(white)
                    surface.DrawTexturedRect(320, 920 + self.lerpText, 30, 30)
                end
                      
                draw.DrawText(BT.GetSentence("recapTitle"), "BT:Font:3D2D:01", halfSizeX, 630 + self.lerpText, black, TEXT_ALIGN_CENTER)
                draw.DrawText(BT.GetSentence("recapDesc"), "BT:Font:3D2D:02", halfSizeX, 670 + self.lerpText, black, TEXT_ALIGN_CENTER)
                
                if true then
                    local checkMouse = BT.CheckMouse(self, 5, pos, ang, halfSizeX-100, 995 + self.lerpText, 200, 25, 0.1, buttons["newOrder"]["func"])
                    self.lerpContinue = self.lerpContinue or 0
                    self.lerpContinue = Lerp(frameTime*5, self.lerpContinue, (self.RFSInfo["stepId"] == 5 and (checkMouse and 240 or 200) or 0))

                    local black = ColorAlpha(BT.Colors["black"], self.lerpContinue)
    
                    draw.RoundedBox(4, halfSizeX-100, 995 + self.lerpText, 200, 25, black)
                    draw.DrawText(BT.GetSentence("continueOrder"), "BT:Font:3D2D:04", halfSizeX, 999 + self.lerpText, white, TEXT_ALIGN_CENTER)
                end
            end
                
            --[[ Login Bolt (step 8) — lerp dédié, indépendant de lerpText ]]
            self.lerpLogin = Lerp(frameTime * 5, self.lerpLogin or 0, self.RFSInfo["stepId"] == 8 and 1 or 0)
            if self.lerpLogin > 0.01 then
                -- Slide depuis le bas : lerpLogin 0→1 = offset sizeY→0
                local lo = math.Round((1 - self.lerpLogin) * sizeY)

                local boltGreen  = Color(0, 218, 90)
                local black      = Color(30, 30, 30)
                local grey3      = Color(160, 160, 160)
                local greyLight  = Color(242, 242, 242)
                local greyBorder = Color(210, 210, 210)
                local padX       = 28
                local fieldW     = sizeX - padX * 2   -- 314 px centré
                local fieldH     = 45

                -- Fond blanc
                draw.RoundedBox(0, 0, lo, sizeX, sizeY + 50, BT.Colors["white246"])

                -- Header vert
                draw.RoundedBox(0, 0, lo, sizeX, 115, boltGreen)

                -- Icône burger centrée dans le header
                surface.SetMaterial(BT.Materials["burger"])
                surface.SetDrawColor(BT.Colors["white"])
                surface.DrawTexturedRect(halfSizeX - 26, 14 + lo, 52, 52)

                -- Titres
                draw.DrawText("Se connecter", "BT:Font:3D2D:01", halfSizeX, 72  + lo, BT.Colors["white"], TEXT_ALIGN_CENTER)
                draw.DrawText("avec Bolt",    "BT:Font:3D2D:03", halfSizeX, 124 + lo, boltGreen,           TEXT_ALIGN_CENTER)

                -- Séparateur
                draw.RoundedBox(1, padX, 157 + lo, fieldW, 1, greyBorder)

                -- ── Email ──
                draw.DrawText("Email", "BT:Font:3D2D:04", padX, 165 + lo, grey3, TEXT_ALIGN_LEFT)
                local emailVal   = self.RFSInfo["boltEmail"] or ""
                local checkEmail = BT.CheckMouse(self, 8, pos, ang, padX, 181 + lo, fieldW, fieldH, 0.1, buttons["boltEditEmail"]["func"])
                draw.RoundedBox(6, padX,     181 + lo, fieldW,     fieldH, checkEmail and boltGreen or greyBorder)
                draw.RoundedBox(6, padX + 1, 182 + lo, fieldW - 2, fieldH - 2, greyLight)
                local emailTxt = emailVal == "" and "Jason.Reed@gmail.com" or emailVal
                draw.DrawText(emailTxt, "BT:Font:3D2D:04", padX + 10, 181 + lo + (fieldH - 15) / 2, emailVal == "" and grey3 or black, TEXT_ALIGN_LEFT)

                -- ── Mot de passe ──
                local passY = 181 + fieldH + 16    -- 242
                draw.DrawText("Mot de passe", "BT:Font:3D2D:04", padX, passY + lo, grey3, TEXT_ALIGN_LEFT)
                local passVal   = self.RFSInfo["boltPass"] or ""
                local checkPass = BT.CheckMouse(self, 8, pos, ang, padX, passY + 16 + lo, fieldW, fieldH, 0.1, buttons["boltEditPass"]["func"])
                draw.RoundedBox(6, padX,     passY + 16 + lo, fieldW,     fieldH, checkPass and boltGreen or greyBorder)
                draw.RoundedBox(6, padX + 1, passY + 17 + lo, fieldW - 2, fieldH - 2, greyLight)
                local passTxt = passVal == "" and "Mot de passe" or string.rep("*", math.min(#passVal, 24))
                draw.DrawText(passTxt, "BT:Font:3D2D:04", padX + 10, passY + 16 + lo + (fieldH - 15) / 2, passVal == "" and grey3 or black, TEXT_ALIGN_LEFT)

                -- ── Bouton Se connecter ──
                local btnY      = passY + 16 + fieldH + 18   -- 321
                local btnH      = 46
                local isLoading = self.RFSInfo["boltLoading"]
                local checkSubmit = (not isLoading) and BT.CheckMouse(self, 8, pos, ang, padX, btnY + lo, fieldW, btnH, 0.1, buttons["boltSubmit"]["func"])
                self.lerpBoltSubmit = Lerp(frameTime * 6, self.lerpBoltSubmit or 0, checkSubmit and 1 or 0)
                local submitG = math.Round(Lerp(self.lerpBoltSubmit, isLoading and 160 or 218, 192))
                local submitB = math.Round(Lerp(self.lerpBoltSubmit, isLoading and 60 or 90, 72))
                draw.RoundedBox(8, padX + 2, btnY + 3 + lo, fieldW, btnH, Color(0, 0, 0, 20))
                draw.RoundedBox(8, padX,     btnY     + lo, fieldW, btnH, Color(0, submitG, submitB))
                local btnLabel = isLoading and "Connexion..." or "Se connecter"
                draw.DrawText(btnLabel, "BT:Font:3D2D:03", halfSizeX, btnY + 10 + lo, BT.Colors["white"], TEXT_ALIGN_CENTER)

                -- Card QR Code
                local cardY  = btnY + btnH + 10 + lo
                local cardH  = 64
                local qrSize = 50
                local qrX    = padX + fieldW - qrSize - 8
                local qrY    = cardY + (cardH - qrSize) / 2

                -- Fond de la carte
                draw.RoundedBox(8, padX + 2, cardY + 3, fieldW, cardH, Color(0, 0, 0, 15))
                draw.RoundedBox(8, padX,     cardY,     fieldW, cardH, Color(240, 240, 240, 220))
                -- Texte à gauche
                draw.DrawText("Rejoignez Bolt",         "BT:Font:3D2D:04", padX + 14, cardY + 8,  black, TEXT_ALIGN_LEFT)
                draw.DrawText("Inscrivez-vous",          "BT:Font:3D2D:05", padX + 14, cardY + 26, grey3, TEXT_ALIGN_LEFT)
                draw.DrawText("Scannez le QR code ->",  "BT:Font:3D2D:05", padX + 14, cardY + 42, grey3, TEXT_ALIGN_LEFT)

                -- QR code à droite
                surface.SetMaterial(BT.Materials["qrbolt"])
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawTexturedRect(qrX, qrY, qrSize, qrSize)
            end

            --[[ Down button to change step ]]
            local isStep8 = self.RFSInfo["stepId"] == 8
            local btnY2   = isStep8 and 480 or 450
            local lineY2  = isStep8 and 460 or 430
            local textY2  = isStep8 and 492 or 462

            local checkMouse = BT.CheckMouse(self, 0, pos, ang, halfSizeX-100, btnY2, 200, 50, 0.1, buttons["nextStep"]["func"])

            self.lerpButton = self.lerpButton or 0
            self.lerpButton = Lerp(frameTime*5, self.lerpButton, (checkMouse and 255 or 200))

            -- Animation de disparition/apparition du bouton lors du changement d'étape
            self.lerpBtnScale = self.lerpBtnScale or 1
            self.lerpBtnAlpha = self.lerpBtnAlpha or 255

            local btnColor = ColorAlpha(BT.Colors["orange"], self.lerpButton)

            draw.RoundedBox(8, halfSizeX-100, btnY2, 200, 50, btnColor)

            local buttonText = "startOrder"
            if self.RFSInfo["stepId"] == 1 then
                buttonText = "startOrder"
            elseif self.RFSInfo["stepId"] == 3 then
                buttonText = "checkout"
            elseif self.RFSInfo["stepId"] > 1 && self.RFSInfo["stepId"] < 5 then
                buttonText = "next"
            elseif self.RFSInfo["stepId"] == 5 then
                buttonText = "payOrder"
            elseif self.RFSInfo["stepId"] == 6 then
                buttonText = "close"
            elseif self.RFSInfo["stepId"] == 8 then
                buttonText = "closeMenu"
            end

            draw.DrawText(BT.GetSentence(buttonText):format(BT.formatMoney(self:GetTotalOrderPrice())), "BT:Font:3D2D:03", halfSizeX, textY2, BT.Colors["white"], TEXT_ALIGN_CENTER)

            --[[ Bottom line ]]
            draw.RoundedBox(8, halfSizeX-150, lineY2, 300, 1, BT.Colors["grey"])

            self:DrawMouse(0.1)

        render.SetStencilEnable(false)

        --[[ Pay your command, modify info... (step 5) ]]
        self.RFSInfo["orderScrollId"] = self.RFSInfo["orderScrollId"] or 0

        self.lerpScroll = self.lerpScroll or 0
        self.lerpScroll = Lerp(frameTime*5, self.lerpScroll, self.RFSInfo["orderScrollId"])

        self.lerpFinal = self.lerpFinal or 0
        self.lerpFinal = Lerp(frameTime*5, self.lerpFinal, (self.RFSInfo["stepId"] == 5 and 240 or 0))

        if self.RFSInfo["stepId"] > 4 && self.RFSInfo["stepId"] < 6 then
            local black = ColorAlpha(BT.Colors["black"], self.lerpFinal)
            local white = ColorAlpha(BT.Colors["white"], self.lerpFinal)
            local black2 = ColorAlpha(BT.Colors["black50"], self.lerpFinal-200)

            self.RFSInfo["orderList"] = self.RFSInfo["orderList"] or {}
            
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
            
                draw.RoundedBox(0, 18, 100, sizeX-36, 380, BT.Colors["white"])

            render.SetStencilCompareFunction(STENCIL_EQUAL)
            render.SetStencilFailOperation(STENCIL_KEEP)
                for k, v in ipairs(self.RFSInfo["orderList"]) do
                    local posY = (self.lerpText + ((k-1)*195)) + self.lerpScroll*195
                    local cardH = 185

                    draw.RoundedBox(8, 23, 715 + posY, sizeX-37.5, cardH, black2)
                    draw.RoundedBox(8, 20, 710 + posY, sizeX-40, cardH, white)

                    local carNames = {"Toyota Prius", "Nissan Leaf", "Tesla"}
                    local voitureId   = v.voiture
                    local voitureName = voitureId and carNames[voitureId] or nil
                    local duration    = v.duration or 1
                    local priceSettings = BT.Terminal.GetTerminalSetting(self, "price") or {}
                    local priceHeure  = priceSettings["prius"] or BT.MaxPrice["prius"] or 700
                    local subtotal    = duration * priceHeure
                    local tax         = math.floor(subtotal * 0.05)
                    local total       = subtotal + tax

                    if voitureName then
                        -- Titre + prix total
                        draw.DrawText(voitureName, "BT:Font:3D2D:03", 24, 713 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText(BT.formatMoney(total), "BT:Font:3D2D:03", sizeX - 24, 713 + posY, black, TEXT_ALIGN_RIGHT)
                        -- Séparateur
                        draw.RoundedBox(1, 24, 738 + posY, sizeX - 48, 1, black2)
                        -- Détail
                        draw.DrawText("Prix / heure :", "BT:Font:3D2D:05", 24, 745 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText(BT.formatMoney(priceHeure), "BT:Font:3D2D:05", sizeX - 24, 745 + posY, black, TEXT_ALIGN_RIGHT)
                        draw.DrawText("Durée :", "BT:Font:3D2D:05", 24, 762 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText(duration .. " heure" .. (duration > 1 and "s" or ""), "BT:Font:3D2D:05", sizeX - 24, 762 + posY, black, TEXT_ALIGN_RIGHT)
                        draw.DrawText("Sous-total :", "BT:Font:3D2D:05", 24, 779 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText(BT.formatMoney(subtotal), "BT:Font:3D2D:05", sizeX - 24, 779 + posY, black, TEXT_ALIGN_RIGHT)
                        draw.DrawText("Taxe (5%) :", "BT:Font:3D2D:05", 24, 796 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText(BT.formatMoney(tax), "BT:Font:3D2D:05", sizeX - 24, 796 + posY, black, TEXT_ALIGN_RIGHT)
                        -- Séparateur final
                        draw.RoundedBox(1, 24, 814 + posY, sizeX - 48, 1, black2)
                        draw.DrawText("TOTAL : " .. BT.formatMoney(total), "BT:Font:3D2D:02", halfSizeX, 820 + posY, black, TEXT_ALIGN_CENTER)

                        -- Checkbox "Accepter les conditions d'utilisation"
                        local cbX, cbY, cbSize = 24, 848 + posY, 16
                        local cguChecked = self.RFSInfo["cguAccepted"] or false
                        BT.CheckMouse(self, 5, pos, ang, cbX, cbY, cbSize, cbSize, 0.1, buttons["toggleCGU"]["func"])
                        -- Contour
                        draw.RoundedBox(3, cbX, cbY, cbSize, cbSize, black2)
                        -- Fond : vert si coché, blanc sinon
                        draw.RoundedBox(2, cbX + 2, cbY + 2, cbSize - 4, cbSize - 4, cguChecked and Color(50, 187, 120) or white)
                        -- Coche
                        if cguChecked then
                            draw.DrawText("✓", "BT:Font:3D2D:05", cbX + cbSize / 2, cbY + 2, BT.Colors["white"], TEXT_ALIGN_CENTER)
                        end
                        -- Texte
                        surface.SetFont("BT:Font:3D2D:05")
                        local tw  = surface.GetTextSize("Accepter les ")
                        local twc = surface.GetTextSize("conditions d'utilisation")
                        local linkX = cbX + cbSize + 6 + tw
                        local linkY = cbY + 3
                        local linkH = 14
                        local hoverCGU = BT.CheckMouse(self, 5, pos, ang, linkX, linkY, twc, linkH, 0.1, buttons["viewCGU"]["func"])
                        local linkCol = hoverCGU and Color(30, 150, 90) or Color(50, 187, 120)
                        draw.DrawText("Accepter les ", "BT:Font:3D2D:05", cbX + cbSize + 6, cbY + 3, black, TEXT_ALIGN_LEFT)
                        draw.DrawText("conditions d'utilisation", "BT:Font:3D2D:05", linkX, linkY, linkCol, TEXT_ALIGN_LEFT)
                        -- Soulignement
                        draw.RoundedBox(0, linkX, linkY + linkH, twc, 1, linkCol)
                    else
                        local replacementTitle = BT.GetSentence("burger")
                        if v.fries and v.fries > 0 then
                            replacementTitle = (replacementTitle..", %s"):format(BT.GetSentence("amountFries"):format(v.fries))
                        end
                        draw.DrawText(replacementTitle, "BT:Font:3D2D:04", 90, 722 + posY, black, TEXT_ALIGN_LEFT)
                        local formatString = BT.ReturnLine(BT.FormatIngredients(v), 35)
                        draw.DrawText(formatString, "BT:Font:3D2D:05", 90, 738 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText("X"..(v.quantity or 1), "BT:Font:3D2D:02", 293, 730 + posY, black, TEXT_ALIGN_LEFT)
                    end
                end

                --[[ Bouton Se connecter avec Bolt (style Uiverse / Yaya12085) ]]
                if self.RFSInfo["stepId"] == 5 then
                    local loginY = 918 + self.lerpText
                    local bX, bY, bW, bH = halfSizeX - 95, loginY + 36, 190, 40

                    if self.RFSInfo["boltUser"] then
                        -- ── Déjà connecté — sous-titre + bouton déconnexion ──
                        local name = self.RFSInfo["boltUser"]
                        draw.DrawText("Connecté en tant que", "BT:Font:3D2D:05", halfSizeX, loginY,      Color(0, 160, 60), TEXT_ALIGN_CENTER)
                        draw.DrawText(name,                   "BT:Font:3D2D:03", halfSizeX, loginY + 16, Color(0, 160, 60), TEXT_ALIGN_CENTER)

                        local dX, dY, dW, dH = halfSizeX - 60, loginY + 46, 120, 26
                        local checkLogout = BT.CheckMouse(self, 5, pos, ang, dX, dY, dW, dH, 0.1, buttons["boltLogout"]["func"])
                        self.lerpLogout = Lerp(frameTime * 6, self.lerpLogout or 0, checkLogout and 1 or 0)
                        local logoutA = math.Round(Lerp(self.lerpLogout, 180, 220))
                        draw.RoundedBox(6, dX, dY, dW, dH, Color(200, 50, 50, logoutA))
                        draw.DrawText("Se déconnecter", "BT:Font:3D2D:05", halfSizeX, dY + 7, BT.Colors["white"], TEXT_ALIGN_CENTER)
                    else
                        -- ── Pas encore connecté ──
                        draw.DrawText("Profitez d'avantages exclusifs en vous", "BT:Font:3D2D:05", halfSizeX, loginY,      BT.Colors["grey"], TEXT_ALIGN_CENTER)
                        draw.DrawText("connectant à votre compte Bolt",         "BT:Font:3D2D:05", halfSizeX, loginY + 16, BT.Colors["grey"], TEXT_ALIGN_CENTER)

                        local checkBolt = BT.CheckMouse(self, 5, pos, ang, bX, bY, bW, bH, 0.1, buttons["boltLogin"]["func"])
                        self.lerpBolt = Lerp(frameTime * 6, self.lerpBolt or 0, checkBolt and 1 or 0)

                        draw.RoundedBox(8, bX + 2, bY + 4, bW, bH, Color(0, 0, 0, 25))

                        local boltG = math.Round(Lerp(self.lerpBolt, 218, 192))
                        local boltB = math.Round(Lerp(self.lerpBolt, 90, 72))
                        draw.RoundedBox(8, bX, bY, bW, bH, Color(0, boltG, boltB))

                        surface.SetMaterial(BT.Materials["burger"])
                        surface.SetDrawColor(Color(255, 255, 255))
                        surface.DrawTexturedRect(bX + 10, bY + 5, 30, 30)

                        draw.DrawText("Se connecter avec Bolt", "BT:Font:3D2D:Bolt", bX + 48, bY + 12, BT.Colors["white"], TEXT_ALIGN_LEFT)
                    end
                end

                self:DrawMouse(0.1)

            render.SetStencilEnable(false)
        end

        --[[ Loader spinner standard — affiché au premier plan lors du paiement ]]
        if self.loaderActive then
            local t       = CurTime()
            local elapsed = t - (self.loaderStartTime or t)

            -- Fond semi-transparent
            draw.RoundedBox(0, 0, 0, sizeX, sizeY, Color(255, 255, 255, 230))

            -- ============================================================
            -- SPINNER CIRCULAIRE
            -- ============================================================
            local cx  = halfSizeX
            local cy  = sizeY / 2 - 30
            local R   = 36        -- rayon extérieur
            local sw  = 7         -- épaisseur du trait
            local arc = 270       -- degrés d'arc affiché
            local spd = 360       -- degrés par seconde

            local angle = (t * spd) % 360

            -- Cercle de fond (gris clair)
            surface.SetDrawColor(Color(220, 220, 220))
            local bgPts = {}
            for a = 0, 358, 2 do
                local rad = math.rad(a)
                for _, rv in ipairs({R, R - sw}) do
                    bgPts[#bgPts+1] = {x = cx + math.cos(rad)*rv, y = cy + math.sin(rad)*rv}
                end
            end
            -- anneau fond via triangles
            for a = 0, 356, 2 do
                local r1 = math.rad(a)
                local r2 = math.rad(a + 2)
                surface.SetDrawColor(Color(220, 220, 220))
                surface.DrawPoly({
                    {x = cx + math.cos(r1)*R,      y = cy + math.sin(r1)*R},
                    {x = cx + math.cos(r2)*R,      y = cy + math.sin(r2)*R},
                    {x = cx + math.cos(r2)*(R-sw), y = cy + math.sin(r2)*(R-sw)},
                    {x = cx + math.cos(r1)*(R-sw), y = cy + math.sin(r1)*(R-sw)},
                })
            end

            -- Arc coloré (orange BT)
            local col = BT.Colors["orange"] or Color(255, 140, 0)
            for a = 0, arc - 2, 2 do
                local r1 = math.rad(angle + a)
                local r2 = math.rad(angle + a + 2)
                -- dégradé d'opacité : plus opaque en tête
                local alpha = math.floor(80 + 175 * (a / arc))
                surface.SetDrawColor(ColorAlpha(col, alpha))
                surface.DrawPoly({
                    {x = cx + math.cos(r1)*R,      y = cy + math.sin(r1)*R},
                    {x = cx + math.cos(r2)*R,      y = cy + math.sin(r2)*R},
                    {x = cx + math.cos(r2)*(R-sw), y = cy + math.sin(r2)*(R-sw)},
                    {x = cx + math.cos(r1)*(R-sw), y = cy + math.sin(r1)*(R-sw)},
                })
            end

            -- ============================================================
            -- TEXTE + BARRE DE PROGRESSION
            -- ============================================================
            local dots  = string.rep(".", math.floor(elapsed * 2) % 4)
            local textY = cy + R + 18
            draw.DrawText("Paiement en cours" .. dots, "BT:Font:3D2D:04", halfSizeX, textY, Color(40, 40, 40), TEXT_ALIGN_CENTER)

            local barW = 200
            local barY = textY + 28
            draw.RoundedBox(4, halfSizeX - barW/2, barY, barW,                              6, Color(200, 200, 200))
            draw.RoundedBox(4, halfSizeX - barW/2, barY, barW * math.Clamp(elapsed/4,0,1), 6, col)

            self:DrawMouse(0.1)
        end

    BT.End3D2D()

    if distance > 25000 then
        self:ResetOrder()
    end
end

function ENT:ResetOrder()
    if BT.TerminalSelected == self then 
        BT.TerminalSelected = nil

        self.RFSInfo["stepId"] = 1
        self.RFSInfo["currentCommand"] = {}
        self.RFSInfo["orderList"] = {}
    end
end

function ENT:OnRemove()
    if BT.TerminalSelected == self then 
        BT.TerminalSelected = nil
    end
end
