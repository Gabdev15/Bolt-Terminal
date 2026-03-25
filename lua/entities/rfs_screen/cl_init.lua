/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")

--[[ All action of buttons ]]
local buttons = {
    ["linkTerminal"] = {
        ["func"] = function(ent)
            RFS.LinkTerminal = {
                [1] = ent,
                [2] = nil,
            }

            RFS.DrawScreenLink = ent:EntIndex()

            net.Start("RFS:MainNet")
                net.WriteUInt(2, 5)
            net.SendToServer()
        end,
    },
    ["scrollOrderList"] = {
        ["func"] = function(ent, args)
            ent.RFSInfo["orderScrollId"] = math.Clamp(ent.RFSInfo["orderScrollId"] + (args[2] and 1 or -1), (-ent:CountOrders(ent:EntIndex()) + 3), 0)
        end,
    },
    ["settings"] = {
        ["func"] = function(ent, args)
            RFS.Screen.Settings(ent)
        end,
    },
    ["claim"] = {
        ["func"] = function(ent, args)
            net.Start("RFS:MainNet")
                net.WriteUInt(5, 5)
                net.WriteUInt(args[1], 16)
                net.WriteUInt(args[3], 16)
            net.SendToServer()
        end,
    },
}

--[[ Init all variable of the terminal ]]
function ENT:Initialize()
    self.RFSInfo = self.RFSInfo or {
        ["use3D2D"] = true, 
        ["stepId"] = 1,
        ["orderScrollId"] = 0,
    }
end

--[[ Cursor Pos on terminal screen ]]
function ENT:DrawMouse(ratio)
    if RFS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) > 20000 then return end
    local frameTime = FrameTime()

    self.lerpCursorX = self.lerpCursorX or 0
    self.lerpCursorY = self.lerpCursorY or 0
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
    
    if RFS.CursorPos && RFS.CursorPos.x && RFS.CursorPos.y then
        self.lerpCursorX = Lerp(frameTime*10, self.lerpCursorX, RFS.CursorPos.x/ratio)
        self.lerpCursorY = Lerp(frameTime*10, self.lerpCursorY, RFS.CursorPos.y/ratio)
        
        surface.SetMaterial(RFS.Materials["cursor"])
        surface.SetDrawColor(RFS.Colors["grey2"])
        surface.DrawTexturedRect(self.lerpCursorX, self.lerpCursorY, 30, 30)
    end
end

--[[ Count all order of the screen ]]
function ENT:CountOrders(screenIndex)
    if not isnumber(screenIndex) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

    RFS.LinkedTerminal = RFS.LinkedTerminal or {}
    RFS.TerminalOrders = RFS.TerminalOrders or {}
    
    RFS.LinkedTerminal[screenIndex] = RFS.LinkedTerminal[screenIndex] or {}

    local countOrders = 0
    for terminalIndex, _ in pairs(RFS.LinkedTerminal[screenIndex]) do
        RFS.TerminalOrders[terminalIndex] = RFS.TerminalOrders[terminalIndex] or {}

        countOrders = countOrders + table.Count(RFS.TerminalOrders[terminalIndex])
    end
    
    return countOrders
end

function ENT:Draw()
    self:DrawModel()

    if not IsValid(RFS.LocalPlayer) then RFS.LocalPlayer = LocalPlayer() return end

    if RFS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) > 250000 then return end
    if halo.RenderedEntity() == self then return end

    local frameTime = FrameTime()
    local screenIndex = self:EntIndex()
    local pos = self:GetPos() + self:GetUp() * 36 + self:GetForward() * 6.25 + self:GetRight() * 28
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Forward(), -0)
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
    
    local countOrders = self:CountOrders(screenIndex)

    RFS.Start3D2D(pos, ang, 0.05)
        local sizeX, sizeY = 1120, 700
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

            draw.RoundedBox(0, 0, 0, sizeX, sizeY, RFS.Colors["white246"])
            
            if true then
                local checkMouse = RFS.CheckMouse(self, 0, pos, ang, 915, 50, 70, 70, 0.05, buttons["settings"]["func"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

                self.lerpRotated = self.lerpRotated or 0
                self.lerpRotated = Lerp(frameTime*5, self.lerpRotated, (checkMouse and -90 or 0))

                surface.SetMaterial(RFS.Materials["settings"])
                surface.SetDrawColor(RFS.Colors["grey2"])
                surface.DrawTexturedRectRotated(950, 82, 70, 70, self.lerpRotated)
                
                local checkMouse = RFS.CheckMouse(self, 0, pos, ang, 1008, 50, 70, 70, 0.05, buttons["linkTerminal"]["func"])
                
                surface.SetMaterial(RFS.Materials["link"])
                surface.SetDrawColor(RFS.Colors["white"])
                surface.DrawTexturedRect(1008, 50, 70, 70)
            end
            
            draw.DrawText(RFS.GetSentence("orderProcessing"), "RFS:Font:3D2D:08", 46, 50, RFS.Colors["grey2"], TEXT_ALIGN_LEFT)
            draw.DrawText(RFS.GetSentence("orderInProcess"):format(countOrders), "RFS:Font:3D2D:09", 50, 100, RFS.Colors["grey2"], TEXT_ALIGN_LEFT)
            
            if countOrders > 3 then
                local checkMouse = RFS.CheckMouse(self, 0, pos, ang, halfSizeX-40, 565, 70, 70, 0.05, buttons["scrollOrderList"]["func"], {self, true})
                surface.SetMaterial(RFS.Materials["upArrow"])
                surface.SetDrawColor(RFS.Colors["grey2"])
                surface.DrawTexturedRect(halfSizeX-40, 565, 70, 70)
            
                local checkMouse = RFS.CheckMouse(self, 0, pos, ang, halfSizeX+5, 565, 70, 70, 0.05, buttons["scrollOrderList"]["func"], {self, false})
                surface.SetMaterial(RFS.Materials["downArrow"])
                surface.SetDrawColor(RFS.Colors["grey2"])
                surface.DrawTexturedRect(halfSizeX+5, 565, 70, 70)
            elseif countOrders == 0 then
                draw.DrawText(RFS.GetSentence("noOrdersInProgress"), "RFS:Font:3D2D:08", sizeX/2, 320, RFS.Colors["grey3"], TEXT_ALIGN_CENTER)
            end

            self:DrawMouse(0.05)
    
            --[[ Bottom line ]]
            draw.RoundedBox(8, halfSizeX-400, 630, 800, 1, RFS.Colors["grey"])
        
        render.SetStencilEnable(false)

        render.SetStencilWriteMask(0xFF)
        render.SetStencilTestMask(0xFF)
        render.SetStencilReferenceValue(0)
        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        render.ClearStencil()

        self.lerpScroll = self.lerpScroll or 0
        self.lerpScroll = Lerp(frameTime*5, self.lerpScroll, math.Clamp(self.RFSInfo["orderScrollId"], -countOrders+3, 0))

        render.SetStencilEnable(true)
        render.SetStencilReferenceValue(1)
        render.SetStencilCompareFunction(STENCIL_NEVER)
        render.SetStencilFailOperation(STENCIL_REPLACE)
        
            draw.RoundedBox(0, 18, 150, sizeX-36, 420, RFS.Colors["white"])
        
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)

            RFS.LinkedTerminal = RFS.LinkedTerminal or {}
            RFS.TerminalOrders = RFS.TerminalOrders or {}
            
            RFS.LinkedTerminal[screenIndex] = RFS.LinkedTerminal[screenIndex] or {}

            RFS.ScreenSettings = RFS.ScreenSettings or {}
            RFS.ScreenSettings[screenIndex] = RFS.ScreenSettings[screenIndex] or {}
            
            local i = 0
            for terminalIndex, _ in pairs(RFS.LinkedTerminal[screenIndex]) do
                RFS.TerminalOrders[terminalIndex] = RFS.TerminalOrders[terminalIndex] or {}
                
                for k, v in pairs(RFS.TerminalOrders[terminalIndex]) do
                    i = i + 1

                    self.lerpScrollY = self.lerpScrollY or {}
                    self.lerpScrollY[i] = self.lerpScrollY[i] or 0
                
                    local posY = ((i-1)*140) + 100 + self.lerpScroll*140 - math.max(0, self.lerpScroll*140)
                    self.lerpScrollY[i] = Lerp(frameTime*5, self.lerpScrollY[i], posY)
			
                    draw.RoundedBox(4, 40, 60 +  self.lerpScrollY[i], sizeX-80, 120, RFS.Colors["orange2"])
                    draw.RoundedBox(8, 40, 60 +  self.lerpScrollY[i], sizeX-80, 5, RFS.Colors["grey"])
        
                    draw.RoundedBox(8, 40, 60 +  self.lerpScrollY[i] + 115, sizeX-80, 5, RFS.Colors["grey"])
        
                    surface.SetMaterial(RFS.Materials["burger"])
                    surface.SetDrawColor(RFS.Colors["white"])
                    surface.DrawTexturedRect(60, 70 +  self.lerpScrollY[i], 100, 100)

                    local orderTableQuantity = string.Explode(";", v["order"])
                    local formatTable = {}
                    for k, v in pairs(orderTableQuantity) do
                        local explode = string.Explode(":", v)
                        
                        formatTable[explode[1]] = explode[2]
                    end

                    local formatString = RFS.FormatIngredients(formatTable)
                    local titleMenu = RFS.FormatTitleMenu(formatTable)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

                    draw.DrawText(titleMenu.." - #"..v.uniqueId, "RFS:Font:3D2D:06", 180, 80 +  self.lerpScrollY[i], black, TEXT_ALIGN_LEFT)
                    draw.DrawText("X"..(v.quantity or 1), "RFS:Font:3D2D:08", 750, 92 +  self.lerpScrollY[i], black, TEXT_ALIGN_LEFT)
                    draw.DrawText(formatString, "RFS:Font:3D2D:07", 180, 120 +  self.lerpScrollY[i], black, TEXT_ALIGN_LEFT)
                    
                    draw.DrawText(RFS.GetSentence("time"):format(math.Round(CurTime()-v.startTime)), "RFS:Font:3D2D:06", 1060, 80 +  self.lerpScrollY[i], black, TEXT_ALIGN_RIGHT)
                    draw.DrawText(RFS.GetSentence("customer").." : "..v.clientName, "RFS:Font:3D2D:07", 180, 140 + self.lerpScrollY[i], black, TEXT_ALIGN_LEFT)
                    
                    local state, color = ""

                    local spawnedByTheServer = RFS.GetNWVariables("rfs_spawned_by_server", self)
                    if true then
                        local checkMouse = RFS.CheckMouse(self, 0, pos, ang, 925, 120 +  self.lerpScrollY[i], 140, 40, 0.05, buttons["claim"]["func"], {terminalIndex, self:EntIndex(), k})
                        
                        self.lerpButton = self.lerpButton or {}
                        self.lerpButton[k] = self.lerpButton[k] or 0
                        self.lerpButton[k] = Lerp(frameTime*5, self.lerpButton[k], (checkMouse and 255 or 180))

                        if v.claimState == 1 then
                            state = RFS.GetSentence("claim")
                            color = RFS.Colors["green"]
                        elseif v.claimState == 2 then
                            state = RFS.GetSentence("finish")
                            color = RFS.Colors["orange"]
                        else
                            state = RFS.GetSentence("close")
                            color = RFS.Colors["red"]
                        end
                        
                        surface.SetFont("RFS:Font:3D2D:06")
                        local textSizeX = surface.GetTextSize(state) + 50
                        local posX = (1060 - textSizeX)

                        draw.RoundedBox(5, posX, 120 +  self.lerpScrollY[i], textSizeX, 40, ColorAlpha(color, self.lerpButton[k]))
                        draw.DrawText(state, "RFS:Font:3D2D:06", posX + textSizeX/2, 125 + self.lerpScrollY[i], black, TEXT_ALIGN_CENTER)
                    else
                        if v.claimState == 1 then
                            state = RFS.GetSentence("pending")
                            color = RFS.Colors["green"]
                        elseif v.claimState == 2 then
                            state = RFS.GetSentence("inPorgress")
                            color = RFS.Colors["orange"]
                        else
                            state = RFS.GetSentence("finished")
                            color = RFS.Colors["red"]
                        end

                        surface.SetFont("RFS:Font:3D2D:06")
                        local textSizeX = surface.GetTextSize(state) + 50
                        local posX = (1060 - textSizeX)

                        draw.RoundedBox(5, posX, 120 +  self.lerpScrollY[i], textSizeX, 40, color)
                        draw.DrawText(state, "RFS:Font:3D2D:06", posX + textSizeX/2, 125 +  self.lerpScrollY[i], black, TEXT_ALIGN_CENTER)
                    end
                end
            end

            self:DrawMouse(0.05)
            
        render.SetStencilEnable(false)
    RFS.End3D2D()
end

local antiSpam
hook.Add("PlayerButtonDown", "RFS:PlayerButtonDown:ConfirmLink", function(ply, button)
    if RFS.DrawScreenLink then
        if button == KEY_E or button == MOUSE_LEFT then
            local curTime = CurTime()

            antiSpam = antiSpam or 0
            if antiSpam > curTime then return end
            antiSpam = curTime + 0.5
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

            local traceEnt = ply:GetEyeTrace().Entity

            RFS.LinkTerminal = RFS.LinkTerminal or {}
            if traceEnt == RFS.LinkTerminal[1] then return end
            
            if IsValid(RFS.LinkTerminal[1]) then
                net.Start("RFS:MainNet")
                    net.WriteUInt(1, 5)
                    net.WriteEntity(RFS.LinkTerminal[1], 16)
                    net.WriteEntity(traceEnt, 16)
                net.SendToServer()
            end
        elseif button == MOUSE_RIGHT then
            RFS.LinkTerminal = {}
            RFS.DrawScreenLink = nil
        end
    end
end)
