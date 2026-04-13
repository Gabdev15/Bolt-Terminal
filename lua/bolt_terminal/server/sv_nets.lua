/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

util.AddNetworkString("BT:MainNet")
util.AddNetworkString("BT:Notification")
util.AddNetworkString("BT:TerminalSettings")
util.AddNetworkString("BT:ScreenSettings")
util.AddNetworkString("BT:Cooking")

net.Receive("BT:MainNet", function(len, ply)
    ply.BT = ply.BT or {}

    local curTime = CurTime()

    ply.BT["mainNetSpam"] = ply.BT["mainNetSpam"] or 0
    if ply.BT["mainNetSpam"] > curTime then return end
    ply.BT["mainNetSpam"] = curTime + 0.5

    local uInt = net.ReadUInt(5)

    --[[ Link a screen to a terminal ]]
    if uInt == 1 then
        local screen = net.ReadEntity()
        local terminal = net.ReadEntity()

        if not BT.CanInteractScreen(screen, ply) then return end
        if not BT.CanInteractTerminal(terminal, ply) then return end

        if not IsValid(screen) or not IsValid(terminal) then return end

        if BT.IsLinkedToTerminal(screen, terminal) then
            BT.UnLinkScreenToTerminal(ply, screen, terminal)
        else
            BT.LinkScreenToTerminal(ply, screen, terminal)
        end
        
    --[[ Send all linked screen of the terminal ]]
    elseif uInt == 2 then
        local screen = ply:GetEyeTrace().Entity
        if not IsValid(screen) then return end

        BT.SendLinkedTerminal(ply, screen)

    --[[ Just check connections and start animation ]]
    elseif uInt == 3 then
        local terminal = ply:GetEyeTrace().Entity
        if not IsValid(terminal) then return end

        if not ply:RFSCheckNearEntity(terminal, "bolt_terminal", 100) then
            ply:RFSNotification(5, BT.GetSentence("tooFar"))
            return
        end

        BT.OrdersCount = BT.OrdersCount or {}

        net.Start("BT:MainNet")
            net.WriteUInt(2, 5)
        net.Send(ply)

    --[[ Create the order ]]
    elseif uInt == 4 then
        local terminal = ply:GetEyeTrace().Entity
        if not IsValid(terminal) then return end

        local terminalsPrice = BT.GetTerminalSetting(terminal, "price") or {}

        if not ply:RFSCheckNearEntity(terminal, "bolt_terminal", 100) then
            ply:RFSNotification(5, BT.GetSentence("tooFar"))
            return
        end
        
        BT.OrdersCount = BT.OrdersCount or {}

        local countOrder = net.ReadUInt(6)
        countOrder = math.max(1, countOrder)
        
        for i=1, countOrder do
            local orders = net.ReadString()
            local quantity = net.ReadUInt(5)

            quantity = math.Clamp(quantity, 1, BT.MaxMenu)
            
            local orderTableQuantity = string.Explode(";", orders)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
            
            local menuPrice = 0
            local isCarOrder = false
            local carDuration = 1
            for k, v in pairs(orderTableQuantity) do
                local explode = string.Explode(":", v)
                local name = explode[1]
                if name == "voiture" then isCarOrder = true end
                if name == "duration" then carDuration = math.max(1, tonumber(explode[2]) or 1) end
            end

            if isCarOrder then
                local priusPrice = terminalsPrice["prius"] or BT.MaxPrice["prius"] or 700
                menuPrice = math.floor(carDuration * priusPrice * 1.05)
            else
                menuPrice = (BT.BasePriceWithoutIngredients or 200)
                for k, v in pairs(orderTableQuantity) do
                    local explode = string.Explode(":", v)
                    local name, articleQuantity = explode[1], explode[2]
                    local price = terminalsPrice[name] or (BT.MaxPrice[name] or 10)
                    articleQuantity = tonumber(articleQuantity)
                    articleQuantity = math.Clamp(articleQuantity, 0, (BT.MaxQuantity[name] or 1))
                    menuPrice = menuPrice + (price * articleQuantity)
                end
                menuPrice = menuPrice * quantity
            end
            
            if ply:RFSGetMoney() >= menuPrice then
                ply:RFSAddMoney(-menuPrice)

                --[[ Create all menu on the terminal ]]
                local orderUniqueId = BT.CreateOrderOnTerminal(ply, terminal, orders, nil, quantity, menuPrice)

                local vehicleName = isCarOrder and "Toyota Prius" or "N/A"
                BT.SendDiscordPayment(ply, vehicleName, menuPrice)

                BT.SendOrdersTerminal(nil, terminal)
                ply:RFSNotification(5, BT.GetSentence("commandAccepted"))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
                
                net.Start("BT:MainNet")
                    net.WriteUInt(6, 5)
                    net.WriteEntity(terminal)
                    net.WriteUInt(orderUniqueId, 32)
                net.Send(ply)
            else
                ply:RFSNotification(5, BT.GetSentence("notEnoughMoney"))
            end
        end
    --[[ Claim order on the screen ]]
    elseif uInt == 5 then
        local terminalIndex = net.ReadUInt(16)
        local terminal = Entity(terminalIndex)
        if not IsValid(terminal) then return end
        
        local screen = ply:GetEyeTrace().Entity
        if not IsValid(screen) then return end

        if not BT.CanInteractScreen(screen, ply) then return end
        
        if not ply:RFSCheckNearEntity(screen, "bt_screen", 200) then
            ply:RFSNotification(5, BT.GetSentence("tooFar"))
            return 
        end

        local orderId = net.ReadUInt(16)
        
        BT.ClaimOrder(ply, terminal, orderId)

    --[[ Save settings of the terminal ]]
    elseif uInt == 6 then
        local terminal = net.ReadEntity()
        if not IsValid(terminal) then return end

        if not BT.CanInteractTerminal(terminal, ply) then
            ply:RFSNotification(5, BT.GetSentence("noAccess"))
            return
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

        if not ply:RFSCheckNearEntity(terminal, "bolt_terminal", 200) then
            ply:RFSNotification(5, BT.GetSentence("tooFar"))
            return 
        end

        local count = net.ReadUInt(16)
        local settingsTable = {}
        for i=1, count do
            local valueType = net.ReadString()
            local key = net.ReadString()
            local value = net["Read"..BT.TypeNet[valueType]](((BT.TypeNet[valueType] == "Int") and 32))
            
            settingsTable[key] = value
        end
        
        local moduleName = net.ReadString()
        BT.SaveTerminalSettings(terminal, settingsTable, moduleName, ply)

        ply:RFSNotification(5, BT.GetSentence("savedSettingsTerminal"))

        net.Start("BT:TerminalSettings")
            net.WriteUInt(2, 5)
        net.Send(ply)

    --[[ Save screen settings ]]
    elseif uInt == 8 then
        local screen = net.ReadEntity()
        if not IsValid(screen) then return end

        if not BT.CanInteractScreen(screen, ply) then return end

        if not ply:RFSCheckNearEntity(screen, "bt_screen", 200) then
            ply:RFSNotification(5, BT.GetSentence("tooFar"))
            return 
        end

        local count = net.ReadUInt(16)
        local settingsTable = {}
        for i=1, count do
            local valueType = net.ReadString()
            local key = net.ReadString()
            local value = net["Read"..BT.TypeNet[valueType]](((BT.TypeNet[valueType] == "Int") and 32))
            
            settingsTable[key] = value
        end

        BT.SaveScreenSettings(ply, settingsTable, screen)

        ply:RFSNotification(5, BT.GetSentence("savedSettingsTerminal"))

        net.Start("BT:ScreenSettings")
            net.WriteUInt(2, 5)
        net.Send(ply)

    --[[ Link screen to the terminal with the toolgun ]]
    elseif uInt == 10 then
        local baseEnt = net.ReadEntity()
        local entLinked = net.ReadEntity()
        if not IsValid(baseEnt) or not IsValid(entLinked) then return end

        BT.SaveLinkedEntities(baseEnt, entLinked)

        ply:RFSNotification(5, BT.GetSentence("linkedScreen"))

    --[[ Init all variables and synchronise addon ]]
    elseif uInt == 11 then
        ply.BT = ply.BT or {}

        BT.SendLinkedTerminal(ply)
        BT.SendOrdersTerminal(ply)
        BT.SendTerminalSettings(ply)
        BT.SendScreenSettings(ply)
        BT.SyncAllNWVariables(nil, ply)
        
    end
end)
