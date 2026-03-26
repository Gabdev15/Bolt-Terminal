/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")

--[[ All action of buttons ]]
local buttons = {
    ["nextStep"] = {
        ["func"] = function(ent)
            if RFS.TerminalSelected != nil && RFS.TerminalSelected != ent then
                RFS.Notification(5, RFS.GetSentence("alreadyOnATerminal"))
                return
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

            if ent.RFSInfo["stepId"] == 1 then
                net.Start("RFS:MainNet")
                    net.WriteUInt(3, 5)
                net.SendToServer()
                return
            elseif ent.RFSInfo["stepId"] == 3 then
                ent.RFSInfo["currentCommand"] = ent.RFSInfo["currentCommand"] or {}
                ent.RFSInfo["orderList"] = ent.RFSInfo["orderList"] or {}

                ent.RFSInfo["orderList"][#ent.RFSInfo["orderList"] + 1] = ent.RFSInfo["currentCommand"]
                ent.RFSInfo["currentCommand"] = {}
                ent.RFSInfo["stepId"] = 5
                return
            elseif ent.RFSInfo["stepId"] == 5 then
                net.Start("RFS:MainNet")
                    net.WriteUInt(4, 5)
                    net.WriteUInt(#ent.RFSInfo["orderList"], 6)
                    for k,v in pairs(ent.RFSInfo["orderList"]) do
                        local order = ""
                        for key, value in pairs(v) do
                            order = order..(order == "" and "" or ";")..key..":"..value
                        end
                        net.WriteString(order)
                        net.WriteUInt((v.quantity or 1), 5)
                    end
                net.SendToServer()
                return
            elseif ent.RFSInfo["stepId"] == 6 then
                ent.RFSInfo["stepId"] = 1
                RFS.TerminalSelected = nil
                return
            end

            ent.RFSInfo["stepId"] = math.Clamp(ent.RFSInfo["stepId"] + 1, 0, 5)
        end,
    },
    ["burgerQuantity"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["currentCommand"] = ent.RFSInfo["currentCommand"] or {}
            
            local uniqueName = args[2]
            
            local settings = RFS.Terminal.GetTerminalSetting(ent, "quantity") or {}

            local defaultMax = (RFS.MaxQuantity[uniqueName] or 1)
            local settingMax = (settings[uniqueName] or defaultMax)
            
            settingMax = math.Clamp(settingMax, 0, defaultMax)
            
            ent.RFSInfo["currentCommand"][uniqueName] = math.Clamp(ent.RFSInfo["currentCommand"][uniqueName] + (args[1] and 1 or -1), 0, settingMax)
        end,
    },
    ["burgerQuantityValue"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["orderList"] = ent.RFSInfo["orderList"] or {}

            local orderId = args[2]

            ent.RFSInfo["orderList"][orderId]["quantity"] = ent.RFSInfo["orderList"][orderId]["quantity"] or 1
            ent.RFSInfo["orderList"][orderId]["quantity"] = math.Clamp(ent.RFSInfo["orderList"][orderId]["quantity"] + (args[1] and 1 or -1), 0, RFS.MaxMenu)

            ent.RFSInfo["orderScrollId"] = math.Clamp(ent.RFSInfo["orderScrollId"] + 1, (-#ent.RFSInfo["orderList"] + 3), 0)

            if ent.RFSInfo["orderList"][orderId]["quantity"] == 0 then
                table.remove(ent.RFSInfo["orderList"], orderId)
            end
        end,
    },
    ["friesQuantity"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["currentCommand"] = ent.RFSInfo["currentCommand"] or {}

            local max = RFS.MaxQuantity["fries"] or 1

            local settings = RFS.Terminal.GetTerminalSetting(ent, "quantity") or {}

            local defaultMax = (RFS.MaxQuantity["fries"] or 1)
            local settingMax = (settings["fries"] or defaultMax)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
            
            settingMax = math.Clamp(settingMax, 0, defaultMax)

            ent.RFSInfo["currentCommand"]["fries"] = math.Clamp(ent.RFSInfo["currentCommand"]["fries"] + (args[1] and 1 or -1), 0, settingMax)
        end,
    },
    ["chooseSoda"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["currentCommand"] = ent.RFSInfo["currentCommand"] or {}

	if ent.RFSInfo["currentCommand"]["soda"] == args[1] then
                ent.RFSInfo["currentCommand"]["soda"] = nil
                return
            end

            ent.RFSInfo["currentCommand"]["soda"] = args[1]
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
            RFS.Terminal.Settings(ent)
        end,
    },
    ["chooseVoiture"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["currentCommand"] = ent.RFSInfo["currentCommand"] or {}
            ent.RFSInfo["currentCommand"]["voiture"] = args[1]
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
    if RFS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) > 20000 then return end
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

function ENT:GetTotalOrderPrice()
    local price = 0

    for commandeId, commandeTable in ipairs(self.RFSInfo["orderList"]) do
        if commandeTable.voiture then
            local duration = commandeTable.duration or 1
            price = price + math.floor(duration * 700 * 1.05)
        else
            local priceEnt = RFS.Terminal.GetTerminalSetting(self, "price") or {}
            for k, v in pairs(commandeTable) do
                price = price + (((priceEnt[k] or RFS.MaxPrice[k]) or 0)*(k == "soda" and 1 or v))*(commandeTable.quantity or 1)
            end
        end
    end

    return price
end

function ENT:GetCurrentOrderPrice()
    local price = RFS.BasePriceWithoutIngredients or 200
    
    for k, v in pairs(self.RFSInfo["currentCommand"]) do
        local priceEnt = RFS.Terminal.GetTerminalSetting(self, "price") or {}

        price = price + (((priceEnt[k] or RFS.MaxPrice[k]) or 0)* (k == "soda" and 1 or v))
    end

    return price
end

function ENT:Draw()
    self:DrawModel()
    
    if not IsValid(RFS.LocalPlayer) then RFS.LocalPlayer = LocalPlayer() return end

    local distance = RFS.LocalPlayer:GetPos():DistToSqr(self:GetPos())
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
    
    RFS.Start3D2D(pos, ang, 0.1)
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
        
            draw.RoundedBox(0, 0, 0, sizeX, sizeY, RFS.Colors["white"])
        
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)
        
            --[[ background of the terminal (step 1) ]]
            draw.RoundedBox(0, 0, 0, sizeX, sizeY, RFS.Colors["white246"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

            self.lerpText = self.lerpText or 0
            self.lerpText = Lerp(frameTime*5, self.lerpText, (self.RFSInfo["stepId"] == 2 and 0 or self.RFSInfo["stepId"] == 3 and -200 or self.RFSInfo["stepId"] == 4 and -400 or self.RFSInfo["stepId"] == 5 and -600 or self.RFSInfo["stepId"] == 6 and -800 or 200))
            
            surface.SetMaterial(RFS.Materials["burger"])
            surface.SetDrawColor(RFS.Colors["white"])
            surface.DrawTexturedRect(halfSizeX-50, -130 + self.lerpText, 100, 100)

            self.lerpQuantity = self.lerpQuantity or 0
            self.lerpQuantity = Lerp(frameTime*5, self.lerpQuantity, (self.RFSInfo["stepId"] == 2 and 180 or 0))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
            
            local grey = ColorAlpha(RFS.Colors["grey"], self.lerpQuantity)

            if self.RFSInfo["stepId"] == 1 then
                draw.DrawText(RFS.GetSentence("welcome"), "RFS:Font:3D2D:01", halfSizeX, 30 + self.lerpText, RFS.Colors["black"], TEXT_ALIGN_CENTER)
            else
                draw.DrawText(RFS.GetSentence("makeYourBurger"), "RFS:Font:3D2D:01", halfSizeX, 10 + self.lerpText, RFS.Colors["black"], TEXT_ALIGN_CENTER)
                draw.DrawText(RFS.GetSentence("makeYourBurger2"), "RFS:Font:3D2D:01", halfSizeX, 50 + self.lerpText, RFS.Colors["black"], TEXT_ALIGN_CENTER)
            end
            if self.RFSInfo["stepId"] == 1 then
                draw.DrawText(RFS.GetSentence("firstInstruction"), "RFS:Font:3D2D:02", halfSizeX, 90 + self.lerpText, RFS.Colors["black"], TEXT_ALIGN_CENTER)
            end
            
            --[[ Only draw selected terminal to optimise ]]
            if RFS.TerminalSelected == self then

                --[[ Customise your burger (step 2) ]] 
                self.lerpElements = self.lerpElements or 0
                self.lerpElements = Lerp(frameTime*5, self.lerpElements, (self.RFSInfo["stepId"] == 2) and 255 or 0)

                local orange = ColorAlpha(RFS.Colors["orange"], self.lerpQuantity)

                --[[ Car selection (step 2) ]]
                if self.RFSInfo["stepId"] == 2 then
                    local carNames = {"Toyota Prius", "Nissan Leaf", "Tesla"}
                    local selectedCar = self.RFSInfo["currentCommand"] and self.RFSInfo["currentCommand"]["voiture"]
                    local displayName = selectedCar and carNames[selectedCar] or "-"
                    draw.DrawText("Voiture : " .. displayName, "RFS:Font:3D2D:02", halfSizeX, 400 + self.lerpText, grey, TEXT_ALIGN_CENTER)

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
                            local checkMouse = RFS.CheckMouse(self, 2, pos, ang, startX, y + self.lerpText, cardW, cardH, 0.1, buttons["chooseVoiture"]["func"], {i})
                            local bgColor = isSelected and RFS.Colors["orange"] or (checkMouse and ColorAlpha(RFS.Colors["orange"], 120) or ColorAlpha(RFS.Colors["grey"], 80))
                            draw.RoundedBox(8, startX, y + self.lerpText, cardW, cardH, bgColor)
                            draw.DrawText(car.name, "RFS:Font:3D2D:03", halfSizeX, y + 13 + self.lerpText, RFS.Colors["black"], TEXT_ALIGN_CENTER)
                        else
                            draw.RoundedBox(8, startX, y + self.lerpText, cardW, cardH, ColorAlpha(RFS.Colors["grey"], 40))
                            draw.DrawText(car.name .. " - Bientot disponible", "RFS:Font:3D2D:04", halfSizeX, y + 18 + self.lerpText, ColorAlpha(RFS.Colors["black"], 120), TEXT_ALIGN_CENTER)
                        end
                    end
                end

                --[[ Résumé du panier (step 3) ]]
                self.lerpExtra = self.lerpExtra or 0
                self.lerpExtra = Lerp(frameTime*5, self.lerpExtra, (self.RFSInfo["stepId"] == 3 and 180 or 0))

                self.lerpBlack = self.lerpBlack or 0
                self.lerpBlack = Lerp(frameTime*5, self.lerpBlack, (self.RFSInfo["stepId"] == 3 and 255 or 0))

                if self.RFSInfo["stepId"] > 2 && self.RFSInfo["stepId"] < 4 then
                    local black  = ColorAlpha(RFS.Colors["black"], self.lerpBlack)
                    local grey   = ColorAlpha(RFS.Colors["grey"],  self.lerpExtra)
                    local orange = ColorAlpha(RFS.Colors["orange"], self.lerpExtra)

                    local carNames = {"Toyota Prius", "Nissan Leaf", "Tesla"}
                    local voitureId   = self.RFSInfo["currentCommand"]["voiture"]
                    local voitureName = voitureId and carNames[voitureId] or "Aucune"

                    self.RFSInfo["currentCommand"]["duration"] = self.RFSInfo["currentCommand"]["duration"] or 1
                    local duration    = self.RFSInfo["currentCommand"]["duration"]
                    local priceHeure  = 700
                    local subtotal    = duration * priceHeure
                    local tax         = math.floor(subtotal * 0.05)
                    local total       = subtotal + tax

                    -- Voiture sélectionnée
                    draw.DrawText("Voiture : " .. voitureName, "RFS:Font:3D2D:02", halfSizeX, 230 + self.lerpText, black, TEXT_ALIGN_CENTER)

                    -- Sélecteur de durée
                    local checkMinus = RFS.CheckMouse(self, 3, pos, ang, halfSizeX - 115, 278 + self.lerpText, 30, 30, 0.1, buttons["changeDuration"]["func"], {false})
                    draw.DrawText("-", "RFS:Font:3D2D:01", halfSizeX - 100, 273 + self.lerpText, checkMinus and orange or grey, TEXT_ALIGN_CENTER)

                    draw.DrawText(duration .. " heure" .. (duration > 1 and "s" or ""), "RFS:Font:3D2D:02", halfSizeX, 283 + self.lerpText, black, TEXT_ALIGN_CENTER)

                    local checkPlus = RFS.CheckMouse(self, 3, pos, ang, halfSizeX + 85, 278 + self.lerpText, 30, 30, 0.1, buttons["changeDuration"]["func"], {true})
                    draw.DrawText("+", "RFS:Font:3D2D:01", halfSizeX + 100, 273 + self.lerpText, checkPlus and orange or grey, TEXT_ALIGN_CENTER)

                    -- Séparateur
                    draw.RoundedBox(1, halfSizeX - 120, 325 + self.lerpText, 240, 1, grey)

                    -- Détail des prix
                    draw.DrawText("Prix / heure : " .. RFS.formatMoney(priceHeure),        "RFS:Font:3D2D:02", halfSizeX, 345 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    draw.DrawText("Durée : " .. duration .. " heure" .. (duration > 1 and "s" or ""), "RFS:Font:3D2D:02", halfSizeX, 385 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    draw.DrawText("Sous-total : " .. RFS.formatMoney(subtotal),             "RFS:Font:3D2D:02", halfSizeX, 425 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    draw.DrawText("Taxe (5%) : " .. RFS.formatMoney(tax),                   "RFS:Font:3D2D:02", halfSizeX, 465 + self.lerpText, grey,  TEXT_ALIGN_CENTER)

                    -- Séparateur
                    draw.RoundedBox(1, halfSizeX - 120, 500 + self.lerpText, 240, 1, grey)

                    -- Total
                    draw.DrawText("TOTAL : " .. RFS.formatMoney(total), "RFS:Font:3D2D:01", halfSizeX, 515 + self.lerpText, RFS.Colors["black"], TEXT_ALIGN_CENTER)
                end
                

                --[[ does the payement is approved or no ]]
                self.lerpFinalPayement = self.lerpFinalPayement or 0
                self.lerpFinalPayement = Lerp(frameTime*5, self.lerpFinalPayement, (self.RFSInfo["stepId"] == 6 and 240 or 0))

                if self.RFSInfo["stepId"] > 5 && self.RFSInfo["stepId"] < 7 then
                    local black = ColorAlpha(RFS.Colors["black"], self.lerpFinalPayement)
                    local white = ColorAlpha(RFS.Colors["white"], self.lerpFinalPayement)

                    draw.DrawText(RFS.GetSentence("payementTitle"), "RFS:Font:3D2D:01", halfSizeX, 830 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    draw.DrawText(RFS.GetSentence("payementDescription"), "RFS:Font:3D2D:02", halfSizeX, 870 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    
                    draw.DrawText("#"..(self.RFSInfo["orderUniqueId"] or 0), "RFS:Font:3D2D:02", halfSizeX, 895 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    
                    surface.SetMaterial(RFS.Materials["approved"])
                    surface.SetDrawColor(white)
                    surface.DrawTexturedRect(halfSizeX-50, 1000 + self.lerpText, 100, 100)
                end
            else
                --[[ Check if the player can manage users ]]
                local accessUsers = {}
                if IsValid(RFS.LocalPlayer) then
                    accessUsers = RFS.Terminal.GetTerminalSetting(self, "users") or {}
                end

                if true then
                    local checkMouse = RFS.CheckMouse(self, 0, pos, ang, 300, 20, 45, 45, 0.1, buttons["settings"]["func"])
            
                    self.lerpRotated = self.lerpRotated or 0
                    self.lerpRotated = Lerp(frameTime*5, self.lerpRotated, (checkMouse and -90 or 0))
        
                    surface.SetMaterial(RFS.Materials["settings"])
                    surface.SetDrawColor(RFS.Colors["grey2"])
                    surface.DrawTexturedRectRotated(320, 40, 45, 45, self.lerpRotated)
                end
            end
            
            --[[ Draw buttons for step 5 ]]
            if self.RFSInfo["stepId"] > 3 && self.RFSInfo["stepId"] < 6 then
                local black = ColorAlpha(RFS.Colors["black"], self.lerpFinal)
                local white = ColorAlpha(RFS.Colors["white"], self.lerpFinal)
                local black2 = ColorAlpha(RFS.Colors["black50"], self.lerpFinal-200)
                
                if #self.RFSInfo["orderList"] == 0 then
                    draw.DrawText(RFS.GetSentence("emptyBasket"), "RFS:Font:3D2D:02", halfSizeX, 850 + self.lerpText, black, TEXT_ALIGN_CENTER)
    
                    surface.SetMaterial(RFS.Materials["basket"])
                    surface.SetDrawColor(white)
                    surface.DrawTexturedRect(sizeX/2-50, 750 + self.lerpText, 100, 100)
                elseif #self.RFSInfo["orderList"] > 3 then
                    local checkMouse = RFS.CheckMouse(self, 5, pos, ang, 300, 920 + self.lerpText, 30, 30, 0.1, buttons["scrollOrderList"]["func"], {true})
                    surface.SetMaterial(RFS.Materials["upArrow"])
                    surface.SetDrawColor(white)
                    surface.DrawTexturedRect(300, 920 + self.lerpText, 30, 30)
                
                    local checkMouse = RFS.CheckMouse(self, 5, pos, ang, 320, 920 + self.lerpText, 30, 30, 0.1, buttons["scrollOrderList"]["func"], {false})
                    surface.SetMaterial(RFS.Materials["downArrow"])
                    surface.SetDrawColor(white)
                    surface.DrawTexturedRect(320, 920 + self.lerpText, 30, 30)
                end
                      
                draw.DrawText(RFS.GetSentence("recapTitle"), "RFS:Font:3D2D:01", halfSizeX, 630 + self.lerpText, black, TEXT_ALIGN_CENTER)
                draw.DrawText(RFS.GetSentence("recapDesc"), "RFS:Font:3D2D:02", halfSizeX, 670 + self.lerpText, black, TEXT_ALIGN_CENTER)
                
                if #self.RFSInfo["orderList"] < RFS.MaxOrder then
                    local checkMouse = RFS.CheckMouse(self, 5, pos, ang, halfSizeX-100, 995 + self.lerpText, 200, 25, 0.1, buttons["newOrder"]["func"])
                    self.lerpContinue = self.lerpContinue or 0
                    self.lerpContinue = Lerp(frameTime*5, self.lerpContinue, (self.RFSInfo["stepId"] == 5 and (checkMouse and 240 or 200) or 0))

                    local black = ColorAlpha(RFS.Colors["black"], self.lerpContinue)
    
                    draw.RoundedBox(4, halfSizeX-100, 995 + self.lerpText, 200, 25, black)
                    draw.DrawText(RFS.GetSentence("continueOrder"), "RFS:Font:3D2D:04", halfSizeX, 999 + self.lerpText, white, TEXT_ALIGN_CENTER)
                end
            end
                
            --[[ Down button to change step ]]
            local checkMouse = RFS.CheckMouse(self, 0, pos, ang, halfSizeX-100, 450, 200, 50, 0.1, buttons["nextStep"]["func"])

            self.lerpButton = self.lerpButton or 0
            self.lerpButton = Lerp(frameTime*5, self.lerpButton, (checkMouse and 255 or 200))

            -- Animation de disparition/apparition du bouton lors du changement d'étape
            self.lerpBtnScale = self.lerpBtnScale or 1
            self.lerpBtnAlpha = self.lerpBtnAlpha or 255

            local btnColor = ColorAlpha(RFS.Colors["orange"], self.lerpButton)

            draw.RoundedBox(8, halfSizeX-100, 450, 200, 50, btnColor)

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
            end

            draw.DrawText(RFS.GetSentence(buttonText):format(RFS.formatMoney(self:GetTotalOrderPrice())), "RFS:Font:3D2D:03", halfSizeX, 462, RFS.Colors["white"], TEXT_ALIGN_CENTER)

            --[[ Bottom line ]]
            draw.RoundedBox(8, halfSizeX-150, 430, 300, 1, RFS.Colors["grey"])
            
            self:DrawMouse(0.1)

        render.SetStencilEnable(false)

        --[[ Pay your command, modify info... (step 5) ]]
        self.RFSInfo["orderScrollId"] = self.RFSInfo["orderScrollId"] or 0

        self.lerpScroll = self.lerpScroll or 0
        self.lerpScroll = Lerp(frameTime*5, self.lerpScroll, self.RFSInfo["orderScrollId"])

        self.lerpFinal = self.lerpFinal or 0
        self.lerpFinal = Lerp(frameTime*5, self.lerpFinal, (self.RFSInfo["stepId"] == 5 and 240 or 0))

        if self.RFSInfo["stepId"] > 4 && self.RFSInfo["stepId"] < 6 then
            local black = ColorAlpha(RFS.Colors["black"], self.lerpFinal)
            local white = ColorAlpha(RFS.Colors["white"], self.lerpFinal)
            local black2 = ColorAlpha(RFS.Colors["black50"], self.lerpFinal-200)

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
            
                draw.RoundedBox(0, 18, 100, sizeX-36, 380, RFS.Colors["white"])

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
                    local priceHeure  = 700
                    local subtotal    = duration * priceHeure
                    local tax         = math.floor(subtotal * 0.05)
                    local total       = subtotal + tax

                    if voitureName then
                        -- Titre + prix total
                        draw.DrawText(voitureName, "RFS:Font:3D2D:03", 24, 713 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText(RFS.formatMoney(total), "RFS:Font:3D2D:03", sizeX - 24, 713 + posY, black, TEXT_ALIGN_RIGHT)
                        -- Séparateur
                        draw.RoundedBox(1, 24, 738 + posY, sizeX - 48, 1, black2)
                        -- Détail
                        draw.DrawText("Prix / heure :", "RFS:Font:3D2D:05", 24, 745 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText(RFS.formatMoney(priceHeure), "RFS:Font:3D2D:05", sizeX - 24, 745 + posY, black, TEXT_ALIGN_RIGHT)
                        draw.DrawText("Durée :", "RFS:Font:3D2D:05", 24, 762 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText(duration .. " heure" .. (duration > 1 and "s" or ""), "RFS:Font:3D2D:05", sizeX - 24, 762 + posY, black, TEXT_ALIGN_RIGHT)
                        draw.DrawText("Sous-total :", "RFS:Font:3D2D:05", 24, 779 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText(RFS.formatMoney(subtotal), "RFS:Font:3D2D:05", sizeX - 24, 779 + posY, black, TEXT_ALIGN_RIGHT)
                        draw.DrawText("Taxe (5%) :", "RFS:Font:3D2D:05", 24, 796 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText(RFS.formatMoney(tax), "RFS:Font:3D2D:05", sizeX - 24, 796 + posY, black, TEXT_ALIGN_RIGHT)
                        -- Séparateur final
                        draw.RoundedBox(1, 24, 814 + posY, sizeX - 48, 1, black2)
                        draw.DrawText("TOTAL : " .. RFS.formatMoney(total), "RFS:Font:3D2D:02", halfSizeX, 820 + posY, black, TEXT_ALIGN_CENTER)

                        -- Checkbox "Accepter les conditions d'utilisation"
                        local cbX, cbY, cbSize = 24, 845 + posY, 16
                        -- Contour de la checkbox (style SVG rounded square)
                        draw.RoundedBox(3, cbX, cbY, cbSize, cbSize, black2)
                        draw.RoundedBox(2, cbX + 2, cbY + 2, cbSize - 4, cbSize - 4, white)
                        -- Texte
                        surface.SetFont("RFS:Font:3D2D:05")
                        local tw = surface.GetTextSize("Accepter les ")
                        draw.DrawText("Accepter les ", "RFS:Font:3D2D:05", cbX + cbSize + 6, cbY + 3, black, TEXT_ALIGN_LEFT)
                        draw.DrawText("conditions d'utilisation", "RFS:Font:3D2D:05", cbX + cbSize + 6 + tw, cbY + 3, Color(50, 187, 120), TEXT_ALIGN_LEFT)
                    else
                        local replacementTitle = RFS.GetSentence("burger")
                        if v.fries and v.fries > 0 then
                            replacementTitle = (replacementTitle..", %s"):format(RFS.GetSentence("amountFries"):format(v.fries))
                        end
                        draw.DrawText(replacementTitle, "RFS:Font:3D2D:04", 90, 722 + posY, black, TEXT_ALIGN_LEFT)
                        local formatString = RFS.ReturnLine(RFS.FormatIngredients(v), 35)
                        draw.DrawText(formatString, "RFS:Font:3D2D:05", 90, 738 + posY, black, TEXT_ALIGN_LEFT)
                        draw.DrawText("X"..(v.quantity or 1), "RFS:Font:3D2D:02", 293, 730 + posY, black, TEXT_ALIGN_LEFT)
                    end
                end

                --[[ Bouton Se connecter avec Bolt (style Uiverse / Yaya12085) ]]
                if self.RFSInfo["stepId"] == 5 then
                    local loginY = 892 + self.lerpText

                    -- Sous-titre
                    draw.DrawText("Profitez d'avantages exclusifs en vous", "RFS:Font:3D2D:05", halfSizeX, loginY, RFS.Colors["grey"], TEXT_ALIGN_CENTER)
                    draw.DrawText("connectant à votre compte Bolt", "RFS:Font:3D2D:05", halfSizeX, loginY + 16, RFS.Colors["grey"], TEXT_ALIGN_CENTER)

                    -- Ombre du bouton (box-shadow CSS)
                    local bX, bY, bW, bH = halfSizeX - 95, loginY + 36, 190, 40
                    draw.RoundedBox(8, bX + 2, bY + 4, bW, bH, Color(0, 0, 0, 25))

                    -- Bouton vert (#00DA5A)
                    draw.RoundedBox(8, bX, bY, bW, bH, Color(0, 218, 90))

                    -- Icône burger à gauche dans le bouton
                    surface.SetMaterial(RFS.Materials["burger"])
                    surface.SetDrawColor(Color(255, 255, 255))
                    surface.DrawTexturedRect(bX + 10, bY + 5, 30, 30)

                    -- Texte "Se connecter avec Bolt"
                    draw.DrawText("Se connecter avec Bolt", "RFS:Font:3D2D:Bolt", bX + 48, bY + 12, RFS.Colors["white"], TEXT_ALIGN_LEFT)
                end

                self:DrawMouse(0.1)

            render.SetStencilEnable(false)
        end
    RFS.End3D2D()

    if distance > 25000 then
        self:ResetOrder()
    end
end

function ENT:ResetOrder()
    if RFS.TerminalSelected == self then 
        RFS.TerminalSelected = nil

        self.RFSInfo["stepId"] = 1
        self.RFSInfo["currentCommand"] = {}
        self.RFSInfo["orderList"] = {}
    end
end

function ENT:OnRemove()
    if RFS.TerminalSelected == self then 
        RFS.TerminalSelected = nil
    end
end
