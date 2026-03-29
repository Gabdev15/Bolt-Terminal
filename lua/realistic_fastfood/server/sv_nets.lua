/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

util.AddNetworkString("RFS:MainNet")
util.AddNetworkString("RFS:Notification")
util.AddNetworkString("RFS:TerminalSettings")
util.AddNetworkString("RFS:ScreenSettings")
util.AddNetworkString("RFS:Cooking")

net.Receive("RFS:MainNet", function(len, ply)
    ply.RFS = ply.RFS or {}

    local curTime = CurTime()

    ply.RFS["mainNetSpam"] = ply.RFS["mainNetSpam"] or 0
    if ply.RFS["mainNetSpam"] > curTime then return end
    ply.RFS["mainNetSpam"] = curTime + 0.5

    local uInt = net.ReadUInt(5)

    --[[ Link a screen to a terminal ]]
    if uInt == 1 then
        local screen = net.ReadEntity()
        local terminal = net.ReadEntity()

        if not RFS.CanInteractScreen(screen, ply) then return end
        if not RFS.CanInteractTerminal(terminal, ply) then return end

        if not IsValid(screen) or not IsValid(terminal) then return end

        if RFS.IsLinkedToTerminal(screen, terminal) then
            RFS.UnLinkScreenToTerminal(ply, screen, terminal)
        else
            RFS.LinkScreenToTerminal(ply, screen, terminal)
        end
        
    --[[ Send all linked screen of the terminal ]]
    elseif uInt == 2 then
        local screen = ply:GetEyeTrace().Entity
        if not IsValid(screen) then return end

        RFS.SendLinkedTerminal(ply, screen)

    --[[ Just check connections and start animation ]]
    elseif uInt == 3 then
        local terminal = ply:GetEyeTrace().Entity
        if not IsValid(terminal) then return end

        if not ply:RFSCheckNearEntity(terminal, "rfs_terminal", 100) then
            ply:RFSNotification(5, RFS.GetSentence("tooFar"))
            return
        end

        RFS.OrdersCount = RFS.OrdersCount or {}
        if (RFS.OrdersCount[ply:SteamID64()] or 0) >= RFS.MaxOrder then 
            ply:RFSNotification(5, RFS.GetSentence("maxOrder"))
            return
        end

        net.Start("RFS:MainNet")
            net.WriteUInt(2, 5)
        net.Send(ply)

    --[[ Create the order ]]
    elseif uInt == 4 then
        local terminal = ply:GetEyeTrace().Entity
        if not IsValid(terminal) then return end

        local terminalsPrice = RFS.GetTerminalSetting(terminal, "price") or {}

        if not ply:RFSCheckNearEntity(terminal, "rfs_terminal", 100) then
            ply:RFSNotification(5, RFS.GetSentence("tooFar"))
            return
        end
        
        RFS.OrdersCount = RFS.OrdersCount or {}
        if (RFS.OrdersCount[ply:SteamID64()] or 0) >= RFS.MaxOrder then 
            ply:RFSNotification(5, RFS.GetSentence("maxOrder"))
            return
        end

        local countOrder = net.ReadUInt(6)
        countOrder = math.Clamp(countOrder, 1, RFS.MaxOrder)
        
        for i=1, countOrder do
            local orders = net.ReadString()
            local quantity = net.ReadUInt(5)

            quantity = math.Clamp(quantity, 1, RFS.MaxMenu)
            
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
                local priusPrice = terminalsPrice["prius"] or RFS.MaxPrice["prius"] or 700
                menuPrice = math.floor(carDuration * priusPrice * 1.05)
            else
                menuPrice = (RFS.BasePriceWithoutIngredients or 200)
                for k, v in pairs(orderTableQuantity) do
                    local explode = string.Explode(":", v)
                    local name, articleQuantity = explode[1], explode[2]
                    local price = terminalsPrice[name] or (RFS.MaxPrice[name] or 10)
                    articleQuantity = tonumber(articleQuantity)
                    articleQuantity = math.Clamp(articleQuantity, 0, (RFS.MaxQuantity[name] or 1))
                    menuPrice = menuPrice + (price * articleQuantity)
                end
                menuPrice = menuPrice * quantity
            end
            
            if ply:RFSGetMoney() >= menuPrice then
                ply:RFSAddMoney(-menuPrice)

                --[[ Create all menu on the terminal ]]
                local orderUniqueId = RFS.CreateOrderOnTerminal(ply, terminal, orders, nil, quantity, menuPrice)
                
                RFS.SendOrdersTerminal(nil, terminal)
                ply:RFSNotification(5, RFS.GetSentence("commandAccepted"))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
                
                net.Start("RFS:MainNet")
                    net.WriteUInt(6, 5)
                    net.WriteEntity(terminal)
                    net.WriteUInt(orderUniqueId, 32)
                net.Send(ply)
            else
                ply:RFSNotification(5, RFS.GetSentence("notEnoughMoney"))
            end
        end
    --[[ Claim order on the screen ]]
    elseif uInt == 5 then
        local terminalIndex = net.ReadUInt(16)
        local terminal = Entity(terminalIndex)
        if not IsValid(terminal) then return end
        
        local screen = ply:GetEyeTrace().Entity
        if not IsValid(screen) then return end

        if not RFS.CanInteractScreen(screen, ply) then return end
        
        if not ply:RFSCheckNearEntity(screen, "rfs_screen", 200) then
            ply:RFSNotification(5, RFS.GetSentence("tooFar"))
            return 
        end

        local orderId = net.ReadUInt(16)
        
        RFS.ClaimOrder(ply, terminal, orderId)

    --[[ Save settings of the terminal ]]
    elseif uInt == 6 then
        local terminal = net.ReadEntity()
        if not IsValid(terminal) then return end

        if not RFS.CanInteractTerminal(terminal, ply) then
            ply:RFSNotification(5, RFS.GetSentence("noAccess"))
            return
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

        if not ply:RFSCheckNearEntity(terminal, "rfs_terminal", 200) then
            ply:RFSNotification(5, RFS.GetSentence("tooFar"))
            return 
        end

        local count = net.ReadUInt(16)
        local settingsTable = {}
        for i=1, count do
            local valueType = net.ReadString()
            local key = net.ReadString()
            local value = net["Read"..RFS.TypeNet[valueType]](((RFS.TypeNet[valueType] == "Int") and 32))
            
            settingsTable[key] = value
        end
        
        local moduleName = net.ReadString()
        RFS.SaveTerminalSettings(terminal, settingsTable, moduleName, ply)

        ply:RFSNotification(5, RFS.GetSentence("savedSettingsTerminal"))

        net.Start("RFS:TerminalSettings")
            net.WriteUInt(2, 5)
        net.Send(ply)

    --[[ Order on the distributor ]]
    elseif uInt == 7 then
        if RFS.CountCookerDistributor() > 0 then
            ply:RFSNotification(5, RFS.GetSentence("noCooker"))
            return
        end 

        local distributor = ply:GetEyeTrace().Entity
        if not IsValid(distributor) then return end

        if not ply:RFSCheckNearEntity(distributor, "rfs_distributor", 100) then
            ply:RFSNotification(5, RFS.GetSentence("tooFar"))
            return 
        end

        local countOrder = net.ReadUInt(16)
        
        local price, orderList = 0, {}
        for i=1, countOrder do
            local uniqueName = net.ReadString()
            if not RFS.Distributor[uniqueName] then return end 

            local quantity = net.ReadUInt(16)
            if not isnumber(quantity) then continue end

            local unityPrice = RFS.Distributor[uniqueName]["price"] or 0
            if not isnumber(unityPrice) then continue end
    
            price = price + (unityPrice*quantity)

            for i=1, quantity do
                orderList[#orderList + 1] = {
                    ["class"] = RFS.Distributor[uniqueName]["class"],
                    ["ingredientsTable"] = RFS.Distributor[uniqueName]["ingredientsTable"],
                    ["distributor"] = true,
                    ["amountFood"] = (RFS.Distributor[uniqueName]["amountFood"] or 0),
                }
            end
        end

        if #orderList > RFS.MaxInventories then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

        if ply:RFSGetMoney() > price then
            local pos, ang = distributor:LocalToWorld(RFS.Constants["vector101022"]), distributor:LocalToWorldAngles(RFS.Constants["angle0902"])
            
            local canCreateBag = true
            for k, v in ipairs(ents.FindInSphere(pos, 10)) do
                if v:GetClass() == "rfs_bag" then ply:RFSNotification(5, RFS.GetSentence("noSpaceDistributor")) return end
            end
            
            ply:RFSAddMoney(-price)

            RFS.Cooking.CreateBag(orderList, pos, ang, ply)
            distributor:ResetSequence("open")

            distributor.RFS =  distributor.RFS or {}
            distributor.RFS["open"] = true

            net.Start("RFS:MainNet")
                net.WriteUInt(6, 5)
                net.WriteEntity(distributor)
            net.Send(ply)
        else
            ply:RFSNotification(5, RFS.GetSentence("notEnoughMoney"))
        end
    --[[ Save screen settings ]]
    elseif uInt == 8 then
        local screen = net.ReadEntity()
        if not IsValid(screen) then return end

        if not RFS.CanInteractScreen(screen, ply) then return end

        if not ply:RFSCheckNearEntity(screen, "rfs_screen", 200) then
            ply:RFSNotification(5, RFS.GetSentence("tooFar"))
            return 
        end

        local count = net.ReadUInt(16)
        local settingsTable = {}
        for i=1, count do
            local valueType = net.ReadString()
            local key = net.ReadString()
            local value = net["Read"..RFS.TypeNet[valueType]](((RFS.TypeNet[valueType] == "Int") and 32))
            
            settingsTable[key] = value
        end

        RFS.SaveScreenSettings(ply, settingsTable, screen)

        ply:RFSNotification(5, RFS.GetSentence("savedSettingsTerminal"))

        net.Start("RFS:ScreenSettings")
            net.WriteUInt(2, 5)
        net.Send(ply)

    --[[ Change status of the dishes ]]
    elseif uInt == 9 then
        local dishes = net.ReadEntity()
        if not IsValid(dishes) then return end

        local owner = RFS.GetOwner(dishes)
        if owner != ply then return end

        if not ply:RFSCheckNearEntity(dishes, "rfs_dishes", 100) then
            ply:RFSNotification(5, RFS.GetSentence("tooFar"))
            return 
        end

        RFS.Cooking.DishesChangeStatus(dishes)
    --[[ Link screen to the terminal with the toolgun ]]
    elseif uInt == 10 then
        local baseEnt = net.ReadEntity()
        local entLinked = net.ReadEntity()
        if not IsValid(baseEnt) or not IsValid(entLinked) then return end

        RFS.SaveLinkedEntities(baseEnt, entLinked)

        ply:RFSNotification(5, RFS.GetSentence("linkedScreen"))

    --[[ Init all variables and synchronise addon ]]
    elseif uInt == 11 then
        ply.RFS = ply.RFS or {}

        RFS.SendLinkedTerminal(ply)
        RFS.SendOrdersTerminal(ply)
        RFS.SendTerminalSettings(ply)
        RFS.SendScreenSettings(ply)
        RFS.SyncAllNWVariables(nil, ply)
        
    end
end)
