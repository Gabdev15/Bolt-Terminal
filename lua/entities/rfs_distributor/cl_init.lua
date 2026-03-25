/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")

--[[ All action of buttons ]]
local buttons = {
    ["nextStep"] = {
        ["func"] = function(ent)
            if RFS.FastFoodJob[team.GetName(LocalPlayer():Team())] then
                RFS.Notification(5, RFS.GetSentence("youCannotDoThatHasCooker"))
                return 
            end

            if RFS.CountCookerDistributor() > 0 then
                RFS.Notification(5, RFS.GetSentence("noCooker"))
                return
            end 

            RFS.TerminalSelected = RFS.TerminalSelected or ent

            if RFS.TerminalSelected != nil && RFS.TerminalSelected != ent then
                RFS.Notification(5, RFS.GetSentence("alreadyOnATerminal"))
                return
            end

            if ent.RFSInfo["stepId"] == 2 then
                local price = ent:GetOrderPrice()
                
                if price == 0 then
                    ent:ResetOrder()
                    return
                else
                    net.Start("RFS:MainNet")
                        net.WriteUInt(7, 5)
                        net.WriteUInt(table.Count(ent.RFSInfo["orderList"]), 16)
                        for k, v in pairs(ent.RFSInfo["orderList"]) do
                            net.WriteString(k)
                            net.WriteUInt((v or 0), 16)
                        end
                    net.SendToServer()
                end
                return
            end

            ent.RFSInfo["stepId"] = math.Clamp(ent.RFSInfo["stepId"] + 1, 0, 2)
        end,
    },
    ["increaseQuantityProduct"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["orderList"] = ent.RFSInfo["orderList"] or {}
                        
            if args[2] && ent.RFSInfo["orderCount"] >= RFS.MaxInventories then return end

            local uniqueName = args[1]
            if not isstring(uniqueName) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

            ent.RFSInfo["orderList"][uniqueName] = math.Clamp(((ent.RFSInfo["orderList"][uniqueName] or 0) + (args[2] and 1 or -1)), 0, RFS.MaxInventories)
            ent.RFSInfo["orderCount"] = ent.RFSInfo["orderCount"] + (args[2] and 1 or -1)
        end,
    },
}

--[[ Init all variable of the terminal ]]
function ENT:Initialize()
    self.RFSInfo = self.RFSInfo or {
        ["use3D2D"] = true, 
        ["stepId"] = 1,
        ["orderList"]  = {},
        ["orderCount"]  = 0,
    }
end

function ENT:DrawMouse(ratio)
    if RFS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) > 10000 then return end
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

function ENT:GetOrderPrice()
    local price = 0
    
    for k, v in pairs(self.RFSInfo["orderList"]) do
        local unityPrice = RFS.Distributor[k]["price"]

        if not isnumber(unityPrice) then continue end
        if not isnumber(v) then continue end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

        price = price + unityPrice*v
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

            self.lerpText = self.lerpText or 0
            self.lerpText = Lerp(frameTime*5, self.lerpText, (self.RFSInfo["stepId"] == 2 and 0 or self.RFSInfo["stepId"] == 3 and -200 or self.RFSInfo["stepId"] == 4 and -400 or self.RFSInfo["stepId"] == 5 and -600 or self.RFSInfo["stepId"] == 6 and -800 or 200))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3
            
            surface.SetMaterial(RFS.Materials["burger"])
            surface.SetDrawColor(RFS.Colors["white"])
            surface.DrawTexturedRect(halfSizeX-50, -130 + self.lerpText, 100, 100)

            self.lerpQuantity = self.lerpQuantity or 0
            self.lerpQuantity = Lerp(frameTime*5, self.lerpQuantity, (self.RFSInfo["stepId"] == 2 and 180 or 0))
            
            local grey = ColorAlpha(RFS.Colors["grey"], self.lerpQuantity)

            draw.DrawText(RFS.GetSentence((self.RFSInfo["stepId"] == 1) and "welcome" or "makeYourOrder"), "RFS:Font:3D2D:01", halfSizeX, 30 + self.lerpText, RFS.Colors["black"], TEXT_ALIGN_CENTER)
            draw.DrawText(RFS.GetSentence((self.RFSInfo["stepId"] == 1) and "firstInstruction" or "composeYourOrder"), "RFS:Font:3D2D:02", halfSizeX, 70 + self.lerpText, RFS.Colors["black"], TEXT_ALIGN_CENTER)
            
            --[[ Only draw selected terminal to optimise ]]
            if RFS.TerminalSelected == self then

                --[[ Customise your burger (step 2) ]] 
                self.lerpElements = self.lerpElements or 0
                self.lerpElements = Lerp(frameTime*5, self.lerpElements, (self.RFSInfo["stepId"] == 2) and 255 or 0)

                local colorAlpha = ColorAlpha(RFS.Colors["white"], self.lerpElements)
                local orange = ColorAlpha(RFS.Colors["orange"], self.lerpQuantity)

                surface.SetDrawColor(colorAlpha)

                local i = 0
                local spaceBetweenButtonsX, spaceBetweenButtonsY = 10, 10
                local buttonWidth, buttonHeight = 100, 100
                local buttonsAmount = 3
                local startY = -5

                for k, v in pairs(RFS.Distributor) do
                    local mat = RFS.RenderTarget[k]
                    if not mat then continue end

                    local divide = math.floor(i / buttonsAmount)
                    local x, y = (i - divide * buttonsAmount) * (buttonWidth + spaceBetweenButtonsX), startY + divide * (buttonHeight + spaceBetweenButtonsY)
                    
                    local checkMouse = RFS.CheckMouse(self, 0, pos, ang, 25 + x, y + 125 + self.lerpText, 100, 100, 0.1, buttons["increaseQuantityProduct"]["func"], {k, true})
                    draw.RoundedBox(10, 25 + x, y + 110 + self.lerpText, 100, 100, RFS.Colors["white234"])
                    
                    surface.SetMaterial(mat)
                    surface.SetDrawColor(RFS.Colors["white"])
                    surface.DrawTexturedRect(30 + x, y + 115 + self.lerpText, 90, 90)

                    draw.RoundedBox(10, 109 + x, y + 105 + self.lerpText, 20, 20, RFS.Colors["orange"])

                    local checkMouse = RFS.CheckMouse(self, 0, pos, ang, 105 + x, y + 100 + self.lerpText, 20, 25, 0.1, buttons["increaseQuantityProduct"]["func"], {k, false})
                    draw.DrawText((checkMouse and "-" or (self.RFSInfo["orderList"][k] or 0)), "RFS:Font:3D2D:11", 119 + x, y + 108 + self.lerpText, RFS.Colors["white"], TEXT_ALIGN_CENTER)

                    draw.RoundedBox(10, 55 + x, y + 200 + self.lerpText, 40, 16, RFS.Colors["orange"])
                    draw.DrawText(RFS.formatMoney(v.price), "RFS:Font:3D2D:11", 75 + x, y + 202 + self.lerpText, RFS.Colors["white"], TEXT_ALIGN_CENTER)
                    i = i + 1
                end

                --[[ does the payement is approved or no ]]
                self.lerpFinalPayement = self.lerpFinalPayement or 0
                self.lerpFinalPayement = Lerp(frameTime*5, self.lerpFinalPayement, (self.RFSInfo["stepId"] == 6 and 240 or 0))

                if self.RFSInfo["stepId"] > 4 && self.RFSInfo["stepId"] < 7 then
                    local black = ColorAlpha(RFS.Colors["black"], self.lerpFinalPayement)
                    local white = ColorAlpha(RFS.Colors["white"], self.lerpFinalPayement)

                    draw.DrawText(RFS.GetSentence("payementTitle"), "RFS:Font:3D2D:01", halfSizeX, 830 + self.lerpText, black, TEXT_ALIGN_CENTER)
                    draw.DrawText(RFS.GetSentence("payementDescription"), "RFS:Font:3D2D:02", halfSizeX, 870 + self.lerpText, black, TEXT_ALIGN_CENTER)

                    surface.SetMaterial(RFS.Materials["approved"])
                    surface.SetDrawColor(RFS.Colors["white"])
                    surface.DrawTexturedRect(halfSizeX-50, 1000 + self.lerpText, 100, 100)
                end
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
                
            --[[ Down button to change step ]]
            local checkMouse = RFS.CheckMouse(self, 0, pos, ang, halfSizeX-100, 450, 200, 50, 0.1, buttons["nextStep"]["func"])

            self.lerpButton = self.lerpButton or 0
            self.lerpButton = Lerp(frameTime*5, self.lerpButton, (checkMouse and 255 or 200))
    
            local orangeColor = ColorAlpha(RFS.Colors["orange"], self.lerpButton)
    
            draw.RoundedBox(8, halfSizeX-100, 450, 200, 50, orangeColor)

            local price = self:GetOrderPrice()

            local buttonText = "startOrder"
            if self.RFSInfo["stepId"] == 1 then
                buttonText  = "startOrder"
            elseif self.RFSInfo["stepId"] == 2 then
                buttonText = (price == 0 and "close" or "payOrder")
            elseif self.RFSInfo["stepId"] == 6 then
                buttonText = "close"
            end
            
            draw.DrawText(RFS.GetSentence(buttonText):format(RFS.formatMoney(price)), "RFS:Font:3D2D:03", halfSizeX, 462, RFS.Colors["white"], TEXT_ALIGN_CENTER)

            --[[ Bottom line ]]
            draw.RoundedBox(8, halfSizeX-150, 430, 300, 1, RFS.Colors["grey"])
            
            self:DrawMouse(0.1)

        render.SetStencilEnable(false)
    RFS.End3D2D()

    if distance > 25000 then
        self:ResetOrder()
    end
end

function ENT:ResetOrder()
    if RFS.TerminalSelected == self then 
        self.RFSInfo["stepId"] = 1
        self.RFSInfo["orderList"] = {}
        self.RFSInfo["orderCount"] = 0
        
        RFS.TerminalSelected = nil
    end
end

function ENT:OnRemove()
    if RFS.TerminalSelected == self then 
        RFS.TerminalSelected = nil
    end
end
