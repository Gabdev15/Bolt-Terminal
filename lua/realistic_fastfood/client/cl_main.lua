/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/


--[[ check if the mouse is on the element and check if the player use ]]
local antiSpam
function RFS.CheckMouse(ent, stepId, pos, ang, posX, posY, sizeX, sizeY, ratio, func, args)
    if not RFS.CursorPos or not RFS.CursorPos.x or not RFS.CursorPos.y then return end
    
    if not IsValid(ent) or not ent.RFSInfo or not ent.RFSInfo["use3D2D"] then return end
    
    posX, posY = posX*ratio, posY*ratio
    sizeX, sizeY = sizeX*ratio, sizeY*ratio

    local checkMouse = (RFS.CursorPos.x > posX) && (RFS.CursorPos.x < (posX + sizeX)) && (RFS.CursorPos.y > posY) && (RFS.CursorPos.y < (posY + sizeY))
    if RFS.LocalPlayer:GetPos():DistToSqr(ent:GetPos()) > 20000 then return end

    if RFS.LocalPlayer:KeyDown(IN_USE) && checkMouse then
        if (stepId != (ent.RFSInfo and ent.RFSInfo["stepId"] or 0) && stepId != 0) then return end
        local curTime = CurTime()
        
        antiSpam = antiSpam or 0
        if antiSpam > curTime then return end
        antiSpam = curTime + 0.5
        
        if isfunction(func) then
            func(ent, args)
        end
    end

    return checkMouse
end 

--[[ Start 3D2D and make some cursor calcul ]]
function RFS.Start3D2D(pos, ang, ratio)
    local x, y = input.GetCursorPos()

    local aimVector = util.AimVector(RFS.LocalPlayer:EyeAngles(), 110, x, y, RFS.ScrW, RFS.ScrH)    
    local collidePos = util.IntersectRayWithPlane(RFS.LocalPlayer:EyePos(), aimVector, pos, ang:Up())
    if not isvector(collidePos) then collidePos = RFS.Constants["vector0"] end
    
    local cursorPos = WorldToLocal(collidePos, RFS.Constants["angle0"], pos, ang)
    cursorPos.y = - cursorPos.y
    
    RFS.CursorPos.x = cursorPos.x
    RFS.CursorPos.y = cursorPos.y

    cam.Start3D2D(pos, ang, ratio)
end

--[[ End 3D2D and reset cursor calcul ]]
function RFS.End3D2D()
    RFS.CursorPos = {}
    cam.End3D2D()
end

--[[ Draw beam material to link terminal and screen ]]
function RFS.DrawBeam(arg1, arg2, color)
    if not isvector(arg1) && not IsValid(arg1) then return end
    if not isvector(arg2) && not IsValid(arg2) then return end

    local sysTime = SysTime()

    local pos1 = isvector(arg1) and arg1 or arg1:LocalToWorld(arg1:OBBCenter())
    local pos2 = isvector(arg2) and arg2 or arg2:LocalToWorld(arg2:OBBCenter())

    local clamp = math.Round(pos1:Distance(pos2)/20)

    render.SetMaterial(RFS.Materials["beam"])
    render.DrawBeam(pos1, pos2, 2, sysTime + clamp, sysTime, color)
end

--[[ Format ingredients for the order ]]
function RFS.FormatIngredients(formatTable)
    formatTable = formatTable or {}

    local values = {
        salad = tonumber(formatTable.salad) or 0,
        tomato = tonumber(formatTable.tomato) or 0,
        onion = tonumber(formatTable.onion) or 0,
        cheese = tonumber(formatTable.cheese) or 0,
        steak = tonumber(formatTable.steak) or 0
    }

    local ingredientStrings = {}

    if values.salad > 0 then
        ingredientStrings[#ingredientStrings + 1] = RFS.GetSentence("amountSalad"):format(values.salad)
    end

    if values.tomato > 0 then
        ingredientStrings[#ingredientStrings + 1] = RFS.GetSentence("amountTomato"):format(values.tomato)
    end

    if values.onion > 0 then
        ingredientStrings[#ingredientStrings + 1] = RFS.GetSentence("amountOnion"):format(values.onion)
    end

    if values.cheese > 0 then
        ingredientStrings[#ingredientStrings + 1] = RFS.GetSentence("amountCheese"):format(values.cheese)
    end
    
    if values.steak > 0 then
        ingredientStrings[#ingredientStrings + 1] = RFS.GetSentence("amountSteak"):format(values.steak)
    end

    local result = table.concat(ingredientStrings, ", ")

    if #ingredientStrings > 0 then
        result = "(" .. result .. ")"
    end

    if result == "" then
        result = "("..RFS.GetSentence("noIngredients")..")"
    end

    return result
end

function RFS.ReturnLine(text, caracters)
    local result = ""
    local count = 0
    local lastSpace = 0

    for i = 1, #text do
        local char = text:sub(i, i)
        result = result .. char
        count = count + 1

        if char == " " then
            lastSpace = #result
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

        if count >= caracters then
            if lastSpace > 0 then
                result = result:sub(1, lastSpace - 1) .. "\n" .. result:sub(lastSpace + 1)
                count = #result - lastSpace
                lastSpace = 0
            end
        end
    end

    return result
end

--[[ Format title for the order ]]
function RFS.FormatTitleMenu(formatTable)
    formatTable = formatTable or {}

    local values = {
        fries = tonumber(formatTable.fries) or 0,
        soda = tonumber(formatTable.soda) or 0
    }

    local titleStrings = {}

    if values.fries > 0 then
        titleStrings[#titleStrings + 1] = RFS.GetSentence("amountFries"):format(values.fries)
    end

    if values.soda > 0 and RFS.SodaList[values.soda] then
        local sodaTable = RFS.SodaList[values.soda]
        titleStrings[#titleStrings + 1] = sodaTable["uniqueName"] or RFS.GetSentence("sodaUnknown")
    end

    local result = table.concat(titleStrings, ", ")

    local titleMenu = RFS.GetSentence("burger")

    if #titleStrings > 0 then
        titleMenu = titleMenu .. ", " .. result
    end

    return titleMenu or ""
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

RFS.HUDPaintInit = RFS.HUDPaintInit or false

--[[ Init some default value ]]
hook.Add("HUDPaint", "RFS:HUDPaint:Init", function()
    if RFS.HUDPaintInit then return end
    
    RFS.LocalPlayer = RFS.LocalPlayer or LocalPlayer()
    RFS.TerminalSelected = RFS.TerminalSelected or nil
    RFS.CursorPos = RFS.CursorPos or {}
    RFS.ScrW, RFS.ScrH = ScrW(), ScrH()

    RFS.LoadFonts()

    net.Start("RFS:MainNet")
        net.WriteUInt(11, 5)
    net.SendToServer()

    RFS.HUDPaintInit = true
    RFS.OpenServiceMenu()

    hook.Remove("HUDPaint", "RFS:HUDPaint:Init")
end)

--[[ Reload font and variables when the user change his screen size ]]
hook.Add("OnScreenSizeChanged", "RFS:OnScreenSizeChanged", function()
    RFS.ScrW, RFS.ScrH = ScrW(), ScrH()

    RFS.LoadFonts()
end)

--[[ Draw beam for connection ]]
hook.Add("PostDrawTranslucentRenderables", "RFS:PostDrawTranslucentRenderables:DrawBeam", function()
    if RFS.LinkTerminal && IsValid(RFS.LinkTerminal[1]) then
        local traceEnt = RFS.LocalPlayer:GetEyeTrace().Entity

        local trace = util.TraceLine({
            start = RFS.LocalPlayer:EyePos(),
            endpos = (IsValid(traceEnt) && traceEnt:GetClass() == "rfs_terminal") and traceEnt:LocalToWorld(traceEnt:OBBCenter()) or RFS.LocalPlayer:EyePos() + RFS.LocalPlayer:EyeAngles():Forward() * 100,
            filter = function(ent) if ent:GetClass() != "player" then return true end end
        })

        RFS.DrawBeam(RFS.LinkTerminal[2] or trace.HitPos, RFS.LinkTerminal[1], RFS.Colors["orange"])
    end

    if isnumber(RFS.DrawScreenLink) then
        RFS.LinkedTerminal = RFS.LinkedTerminal or {}
        RFS.LinkedTerminal[RFS.DrawScreenLink] = RFS.LinkedTerminal[RFS.DrawScreenLink] or {}

        for k, v in pairs(RFS.LinkedTerminal[RFS.DrawScreenLink]) do
            if not v then continue end

            local screen, terminal = Entity(RFS.DrawScreenLink), Entity(k)
            RFS.DrawBeam(terminal, screen, RFS.Colors["orange"])
        end
    end
end)

--[[ Fix problem with PVS and clientside model thanks to this issue https://github.com/Facepunch/garrysmod-issues/issues/861 ]]
local parentLookup = {}
local function cacheParents()
	parentLookup = {}

	local tbl = ents.GetAll()
	for i=1, #tbl do
		local v = tbl[i]

		if v:EntIndex() == -1 then
			local parent = v:GetInternalVariable("m_hNetworkMoveParent")
			local children = parentLookup[parent]

			if not children then 
                children = {}
                parentLookup[parent] = children
            end

			children[#children + 1] = v
		end
	end
end

local function fixChildren(parent, transmit)
	local tbl = parentLookup[parent]
	if tbl then
		for i=1, #tbl do
			local child = tbl[i]
			if transmit then
				child:SetNoDraw(false)
				child:SetParent(parent)
                
                fixChildren(child, transmit)
			else
				child:SetNoDraw(true)
				fixChildren(child, transmit)
			end
		end
	end
end

local lastTime = 0
hook.Add("NotifyShouldTransmit", "RFS:NotifyShouldTransmit:FixChildrens", function(ent, transmit)
    if not ent:GetClass():find("rfs") then return end
    
	local time = RealTime()

	if lastTime < time then
		cacheParents()
		lastTime = time
	end
	
	fixChildren(ent, transmit)
end)

local antiSpam
hook.Add("HUDPaint", "RFS:HUDPaint:SyncNW", function()
    local curTime = CurTime()

    antiSpam = antiSpam or 0
    if antiSpam > curTime then return end
    antiSpam = curTime + 1

    if istable(RFS.NWToSynchronize) then
        for k, v in pairs(RFS.NWToSynchronize) do
            local ent = Entity(k)
            if not IsValid(ent) then continue end
    
            ent.RFSNWVariables = ent.RFSNWVariables or v
        end
    end

    if not IsValid(serviceMenu) && RFS.ServiceSystem then
        RFS.OpenServiceMenu()
    end
end)

function RFS.OpenServiceMenu()
    if IsValid(serviceMenu) then serviceMenu:Remove() end

    local posXBox, posYBox = RFS.ScrW*0.815, RFS.ScrH*0.01
    local sizeX, sizeY = RFS.ScrW*0.18, RFS.ScrH*0.1

    serviceMenu = vgui.Create("DFrame")
    serviceMenu:SetSize(sizeX, sizeY)
    serviceMenu:SetPos(posXBox, posYBox)
    serviceMenu:SetDraggable(false)
    serviceMenu:ShowCloseButton(false)
    serviceMenu.Paint = function(self, w, h)
        if not RFS.ServiceSystem then
            serviceMenu:Remove()
            return 
        end

        local onService = RFS.GetNWVariables("rfs_service", LocalPlayer())

        draw.RoundedBox(6, 0, 0, w, h, RFS.Colors["white"])
        draw.DrawText((onService and RFS.GetSentence("serviceOn") or RFS.GetSentence("serviceOff")), "RFS:Font:03", w/2, RFS.ScrH*0.015, RFS.Colors["black0255"], TEXT_ALIGN_CENTER)
    end

    local serviceButton = vgui.Create("DButton", serviceMenu)
    serviceButton:SetSize(RFS.ScrW*0.16, RFS.ScrH*0.04)
    serviceButton:SetPos(RFS.ScrW*0.01, RFS.ScrH*0.048)
    serviceButton:SetText("Activer le service")
    serviceButton:SetFont("RFS:Font:02")
    serviceButton:SetTextColor(RFS.Colors["white"])
    serviceButton.Paint = function(self, w, h)
        local onService = RFS.GetNWVariables("rfs_service", LocalPlayer())

        draw.RoundedBox(6, 0, 0, w, h, RFS.Colors[onService and "red" or "orange"])
        serviceButton:SetText(onService and RFS.GetSentence("disableService") or RFS.GetSentence("enableService"))
    end
    serviceButton.DoClick = function()
        net.Start("RFS:Cooking")
            net.WriteUInt(5, 5)
        net.SendToServer()
    end
end

net.Receive("RFS:MainNet", function()
    local uInt = net.ReadUInt(5)

    --[[ Receive all connections with the screen ]]
    if uInt == 1 then
        local count = net.ReadUInt(16)
        
        for i=1, count do
            local screenIndex = net.ReadUInt(16)
            
            RFS.LinkedTerminal = RFS.LinkedTerminal or {}
            RFS.LinkedTerminal[screenIndex] = {}

            local terminalCount = net.ReadUInt(6)
            
            for i=1, terminalCount do
                local terminalIndex = net.ReadUInt(16)
                RFS.LinkedTerminal[screenIndex][terminalIndex] = true
            end
        end
    --[[ Just start the first animation ]]
    elseif uInt == 2 then
        local terminal = RFS.LocalPlayer:GetEyeTrace().Entity
        if not IsValid(terminal) then return end

        terminal.RFSInfo["stepId"] = 2
        
        if not IsValid(RFS.TerminalSelected) then
            RFS.TerminalSelected = terminal
        end

    --[[ Reset linking view ]]
    elseif uInt == 3 then

        RFS.LinkTerminal = {}
        
        timer.Create("rfs_reset_screen", 3, 1, function()
            if IsValid(RFS.LinkTerminal[1]) then return end

            RFS.DrawScreenLink = nil
        end)

    --[[ Sync all orders of the terminal ]]
    elseif uInt == 4 then
        local count = net.ReadUInt(32)
        RFS.TerminalOrders = RFS.TerminalOrders or {}
        
        for i=1, count do
            local terminalIndex = net.ReadUInt(32)
            RFS.TerminalOrders[terminalIndex] = {}
            
            local orderCount = net.ReadUInt(32)
            for i=1, orderCount do
                local order = net.ReadString()
                local clientName = net.ReadString()
                local claimState = net.ReadUInt(5)
                local startTime = net.ReadUInt(32)
                local uniqueId = net.ReadUInt(32)
                local quantity = net.ReadUInt(32)

                RFS.TerminalOrders[terminalIndex][#RFS.TerminalOrders[terminalIndex] + 1] = {
                    ["order"] = order,
                    ["clientName"] = clientName,
                    ["claimState"] = claimState,
                    ["startTime"] = startTime,
                    ["uniqueId"] = uniqueId,
                    ["quantity"] = quantity,
                }
            end
        end
    --[[ Reset all variables of the entIndex to fix a little issue ]]
    elseif uInt == 5 then
        local entIndex = net.ReadUInt(16)

        RFS.LinkedTerminal = RFS.LinkedTerminal or {}
        RFS.TerminalOrders = RFS.TerminalOrders or {}
        RFS.TerminalSettings = RFS.TerminalSettings or {}

        RFS.LinkedTerminal[entIndex] = {}
        RFS.TerminalOrders[entIndex] = {}
        RFS.TerminalSettings[entIndex] = {}

    --[[ Reset clientside value of the terminal ]]
    elseif uInt == 6 then
        local terminal = net.ReadEntity()
        if not IsValid(terminal) then return end
        
        local uniqueId = net.ReadUInt(32)

        terminal.RFSInfo = terminal.RFSInfo or {}

        terminal.RFSInfo["stepId"] = 6
        terminal.RFSInfo["orderScrollId"] = 0
        terminal.RFSInfo["orderUniqueId"] = uniqueId
        terminal.RFSInfo["orderList"] = {}
        terminal.RFSInfo["currentCommand"] = {}
        
    --[[ Open ingredients menu ]]
    elseif uInt == 7 then
        local case = net.ReadEntity()

        RFS.Cooking.IngredientsCase(case)

    --[[ Claim system of orders ]]
    elseif uInt == 8 then
        local claimState = net.ReadUInt(5)
        local terminalIndex = net.ReadUInt(16)
        
        RFS.TerminalOrders = RFS.TerminalOrders or {}
        RFS.TerminalOrders[terminalIndex] = RFS.TerminalOrders[terminalIndex] or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

        local orderId = net.ReadUInt(16)

        RFS.TerminalOrders[terminalIndex][orderId] = RFS.TerminalOrders[terminalIndex][orderId] or {}
        RFS.TerminalOrders[terminalIndex][orderId]["claimState"] = claimState
        
    --[[ Remove order ]]
    elseif uInt == 9 then
        local terminalIndex = net.ReadUInt(16)
        
        RFS.TerminalOrders = RFS.TerminalOrders or {}
        RFS.TerminalOrders[terminalIndex] = RFS.TerminalOrders[terminalIndex] or {}

        local orderId = net.ReadUInt(16)
        RFS.TerminalOrders[terminalIndex][orderId] = nil

    --[[ Sync Variables ]]
    elseif uInt == 10 then
        RFS.NWToSynchronize = RFS.NWToSynchronize or {}
            
        local entAmountToSynchronize = net.ReadUInt(12)
        for i=1, entAmountToSynchronize do
            
            local entIndex = net.ReadUInt(16)
            local ent = Entity(entIndex)

            local needToSync = {}
            local varAmountToSynchronize = net.ReadUInt(4)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46
            
            for i=1, varAmountToSynchronize do
                local valueType = net.ReadString()
                
                if IsValid(ent) then
                    ent.RFSNWVariables = ent.RFSNWVariables or {}

                    local valueName, value = net.ReadString(), net["Read"..RFS.TypeNet[valueType]](((RFS.TypeNet[valueType] == "Int") and 32))
                    ent.RFSNWVariables[valueName] = value
                else
                    needToSync[net.ReadString()] = net["Read"..RFS.TypeNet[valueType]](((RFS.TypeNet[valueType] == "Int") and 32))
                end
            end

            if not IsValid(ent) then
                RFS.NWToSynchronize[entIndex] = RFS.NWToSynchronize[entIndex] or {}
                
                for k,v in pairs(needToSync) do
                    RFS.NWToSynchronize[entIndex][k] = v
                end
            end
        end
    end
end)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

--[[ Define proxy of the fluid ]]
matproxy.Add({
    name = "Fluid", 
    init = function(self, mat, values)
        self.ResultTo = values.resultvar
    end,
    bind = function(self, mat, ent)
        mat:SetVector(self.ResultTo, ent.fluidcolor or RFS.Constants["vector111"])
    end 
})
