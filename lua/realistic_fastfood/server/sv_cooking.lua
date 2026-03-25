/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

RFS.Cooking = RFS.Cooking or {}

--[[ Soda cooking ]]

function RFS.Cooking.CreateSodaCup(ent, ply)
    if not IsValid(ent) then return end

    ent.RFS = ent.RFS or {}
    if IsValid(ent.RFS["parentSoda"]) then return end

    local sodaCup = ents.Create("rfs_sodacup")
    sodaCup:SetPos(ent:LocalToWorld(RFS.Constants["vector22"]))
    sodaCup:SetAngles(ent:LocalToWorldAngles(RFS.Constants["angle0"]))
    sodaCup:Spawn()
    sodaCup:SetParent(ent)
    RFS.SetOwner(sodaCup, ply)

    ent.RFS["parentSoda"] = sodaCup
end

function RFS.Cooking.StartSodaCup(ent, sodaUniqueId, ply)
    if not IsValid(ent) or not isnumber(sodaUniqueId) then return end

    local entIndex = ent:EntIndex()
    if timer.Exists("rfs_sodacup:"..entIndex) then return end

    ent.RFS = ent.RFS or {}
    
    local sodaCup = ent.RFS["parentSoda"]
    if not IsValid(sodaCup) then return end

    local sodaTable = RFS.SodaList[sodaUniqueId]
    if not sodaTable then return end

    local color = sodaTable["color"] or RFS.Colors["white"]

    ent:ResetSequence("fall")
    ent:SetSequence("fall")
    ent:SetBodygroup(0, 1)

    ent.soundCup = CreateSound(ent, RFS.Sounds["fountainFill"])
    ent.soundCup:Play()

    RFS.SetNWVariable("rfs_soda_color", color, sodaCup, true, nil, true)

    sodaCup:ResetSequence("fill")
    sodaCup:SetSequence("fill")
    sodaCup:SetColor(color)
    RFS.SetOwner(sodaCup, ply)

    ent:CallOnRemove("rfs_reset_variables:"..entIndex, function(fountain) 
        if fountain.soundCup then
            fountain.soundCup:Stop()
        end
    end) 

    timer.Create("rfs_sodacup:"..entIndex, 3, 1, function()
        if not IsValid(ent) then return end

        sodaCup:SetBodygroup(1, 5)
        ent:SetSequence("stop")
        ent:ResetSequence("stop")
        
        timer.Create("rfs_sodacup:"..entIndex, 1, 1, function()
            if IsValid(ent) then
                ent.RFS["parentSoda"] = nil
            end
            if IsValid(sodaCup) then
                sodaCup:SetParent(nil)
            end
        end)
    end)
end

--[[ Fries cooking ]]

function RFS.Cooking.StartFries(ent)
    if not IsValid(ent) then return end

    local entIndex = ent:EntIndex()
    if timer.Exists("rfs_fries:"..entIndex) then return end

    ent.RFS = ent.RFS or {}
    if ent.RFS["friesCount"] != nil then return end 
    
    ent:SetBodygroup(1, 1)
    ent:SetBodygroup(2, 1)
    ent:SetSkin(0)
    
    ent:ResetSequence("start")
    ent:SetSequence("start")

    ent.soundFryer = CreateSound(ent, RFS.Sounds["fryerLoop"])
    ent.soundFryer:Play()

    RFS.SetNWVariable("rfs_fry_starting", true, ent, true, nil, true)

    ent:CallOnRemove("rfs_reset_variables:"..entIndex, function(fryer) 
        if fryer.soundFryer then
            fryer.soundFryer:Stop()
        end
    end) 

    timer.Create("rfs_fries:"..entIndex, 5, 1, function()
        if not IsValid(ent) then return end
        
        ent:SetBodygroup(2, 0)
        ent:SetSkin(1)
    
        ent:ResetSequence("finish")
        ent:SetSequence("finish")
        ent:StopLoopingSound(1)

        if ent.soundFryer then
            ent.soundFryer:Stop()
        end

        RFS.SetNWVariable("rfs_fry_starting", false, ent, true, nil, true)

        ent.RFS["friesCount"] = 3
    end)

    return true
end

function RFS.Cooking.RemoveFries(time, ent, friesBag)
    local entIndex = ent:EntIndex()
    
    timer.Create("rfs_fries:"..entIndex, time, 1, function()
        if not IsValid(ent) then return end
        ent.RFS["friesCount"] = ent.RFS["friesCount"] - 1
        
        local countBody = (ent:GetBodygroupCount(1)-1)

        local newBody = (countBody - ent.RFS["friesCount"])
        ent:SetBodygroup(1, newBody)
        
        if ent.RFS["friesCount"] <= 0 then
            ent.RFS["friesCount"] = nil

            ent:SetBodygroup(1, 0)
            ent:SetSkin(0)
        end

        if IsValid(friesBag) then
            timer.Create("rfs_fries:"..entIndex, 1, 1, function()
                if IsValid(ent) then
                    ent.RFS["parentFriesBag"] = nil
                end
                if IsValid(friesBag) then
                    friesBag:SetParent(nil)
                    friesBag:SetBodygroup(1, 1)
                end 
            end)
        end
    end)
end

function RFS.Cooking.FillFriesBag(ent, fryer, ply)
    if not IsValid(ent) then return end
    if timer.Exists("rfs_fries:"..ent:EntIndex()) then return end

    ent.RFS = ent.RFS or {}
    if IsValid(ent.RFS["parentFriesBag"]) or not isnumber(ent.RFS["friesCount"]) then return end

    local friesBag = ents.Create("rfs_friesbag")
    friesBag:SetPos(ent:LocalToWorld(RFS.Constants["vector020"]))
    friesBag:SetAngles(ent:LocalToWorldAngles(RFS.Constants["angle0"]))
    friesBag:Spawn()
    friesBag:SetParent(ent)

    friesBag:SetSequence("fill")
    friesBag:ResetSequence("fill")
    RFS.SetOwner(friesBag, ply)

    ent.RFS["parentFriesBag"] = friesBag
    RFS.Cooking.RemoveFries(1, ent, friesBag)
end

--[[ Grill cooking ]]

function RFS.Cooking.GetSteakPlace(ent)
    if not IsValid(ent) then return end

    ent.RFS = ent.RFS or {}
    ent.RFS["steaks"] = ent.RFS["steaks"] or {}

    for i=1, 8 do
        local steakTable = ent.RFS["steaks"][i] or {}
        if not isnumber(steakTable["entIndex"]) then return i end

        local ent = Entity(steakTable["entIndex"])
        if IsValid(ent) then continue end

        return i
    end
end

function RFS.Cooking.AddSteak(ent)
    if not IsValid(ent) then return end

    ent.RFS = ent.RFS or {}
    ent.RFS["steaks"] = ent.RFS["steaks"] or {}
    
    local placeId = RFS.Cooking.GetSteakPlace(ent)
    
    local steakTable = RFS.SteakPosition[placeId]
    if not steakTable then return end
    
    local steak = ents.Create("rfs_steak")
    steak:SetPos(ent:LocalToWorld(steakTable["pos"]))
    steak:SetAngles(ent:LocalToWorldAngles(steakTable["ang"]))
    steak:Spawn()
    steak:SetParent(ent)
    local entIndex = steak:EntIndex()

    steak.soundGrill = CreateSound(steak, RFS.Sounds["steakGrillLoop"])
    steak.soundGrill:Play()
    
    ent.RFS["steaks"][placeId] = {
        ["entIndex"] = entIndex,
        ["cookedTime"] = CurTime() + RFS.SteakTime,
        ["flipped"] = false,
    }

    steak.RFS = steak.RFS or {}
    steak.RFS["placeId"] = placeId
    steak.RFS["parentGrill"] = ent

    steak:CallOnRemove("rfs_reset_variables:"..entIndex, function(steak) 
        local placeId = steak.RFS["placeId"]
        
        ent.RFS["steaks"][placeId] = nil
        RFS.SetNWVariable("steaks", ent.RFS["steaks"], ent, true, nil, true)

        if steak.soundGrill then
            steak.soundGrill:Stop()
        end
    end)

    RFS.SetNWVariable("steaks", ent.RFS["steaks"], ent, true, nil, true)
end

function RFS.TurnSteak(ent, grill, placeId)
    if not IsValid(ent) or not IsValid(grill) or not isnumber(placeId) then return end

    local entIndex = ent:EntIndex()
    if timer.Exists("rfs_steak:"..entIndex) then return end
    if ent.RFS["flipped"] then return end
    
    grill.RFS["steaks"][placeId]["cookedTime"] = (CurTime() + RFS.SteakTime)
    grill.RFS["steaks"][placeId]["flipped"] = true

    RFS.SetNWVariable("steaks", grill.RFS["steaks"], grill, true, nil, true)

    ent:ResetSequence("turn")
    ent:SetSequence("turn")
    
    ent.RFS["flipped"] = true

    timer.Create("rfs_steak:"..entIndex, RFS.SteakTime, 1, function()
        if not IsValid(ent) then return end

        local steakReady = CreateSound(ent, RFS.Sounds["steakReady"])
        steakReady:Play()

        ent:SetColor(RFS.Colors["grilledSteak"])

        timer.Create("rfs_steak:"..entIndex, RFS.CarboniseTime, 1, function()
            if not IsValid(ent) then return end

            ent:SetColor(RFS.Colors["black2"])

            local carbonise = CreateSound(ent, RFS.Sounds["carboniseSound"])
            carbonise:Play()

            ent.RFS["carbonised"] = true
        end)
    end)
end

--[[ Condiments cooking ]]
function RFS.Cooking.ChangeQuantity(ent, condimentUniqueName, bodyId, number)
    ent.RFS = ent.RFS or {}
    ent.RFS["condiments"] = ent.RFS["condiments"] or {}
    ent.RFS["condiments"][condimentUniqueName] = ent.RFS["condiments"][condimentUniqueName] or 0

    local bodyCount = ent:GetBodygroupCount(bodyId) - 1
    if number < 0 && ent.RFS["condiments"][condimentUniqueName] <= 0 then
        return false
    end

    local newBodyCount = ent.RFS["condiments"][condimentUniqueName] + number
    local newBody = math.Clamp(newBodyCount, 0, bodyCount)
    
    ent:SetBodygroup(bodyId, newBody)
    ent.RFS["condiments"][condimentUniqueName] = newBody

    return true
end

--[[ Get space take by the burger ]]
function RFS.GetSpaceBurger(ent)
    if not IsValid(ent) then return end

    local placeToSet = RFS.Constants["vector0"]

    for k, v in ipairs(ent.RFS["condiments"]) do
        local space = RFS.SpaceCondiment[v]
        if not isvector(space) then continue end

        placeToSet = placeToSet + space
    end

    return placeToSet
end

--[[ Send all burgers informations to a player ]]
function RFS.Cooking.SendAllBurgers(ply)
    for k, v in ipairs(ents.FindByClass("rfs_burger")) do
        RFS.Cooking.CreateBurger(nil, v, nil, nil, true, ply)
    end
end

--[[ Create burger ]]
function RFS.Cooking.CreateBurger(plank, ent, pos, ang, sendInfo, ply, burgerCondiments)
    --[[ Create the burger if not exist on a plank or on a position]]
    local burger
    if not IsValid(ent) then
        burger = ents.Create("rfs_burger")
        
        if IsValid(plank) then
            burger:SetPos(plank:LocalToWorld(RFS.Constants["vector0"]))
            burger:SetAngles(plank:GetAngles())
            burger:SetParent(plank)
            plank.burger = burger
        else
            burger:SetPos(pos)
            burger:SetAngles(ang)
        end

        burger:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        burger:Spawn()
        burger:Activate()
    else
        burger = ent
    end

    RFS.SetOwner(burger, ply)

    if not IsValid(burger) or not sendInfo then return end

    --[[ Send all condiments on the burger ]]
    local createInstantly = istable(burgerCondiments)

    burger.RFS = burger.RFS or {}
    burger.RFS["condiments"] = (createInstantly and burgerCondiments or (burger.RFS["condiments"] or {}))

    if createInstantly then
        local space = RFS.GetSpaceBurger(burger)

        local min1 = RFS.Constants["vector553"]
        local max1 = Vector(-5, 5, space.z)

        RFS.ModifyCollision(burger, min1, max1)
    end

    timer.Simple(0.1, function()
        if not IsValid(burger) then return end

        net.Start("RFS:Cooking")
            net.WriteUInt(3, 5)
            net.WriteUInt(#burger.RFS["condiments"], 16)
            for i=1, #burger.RFS["condiments"] do
                net.WriteEntity(burger)
                net.WriteString(burger.RFS["condiments"][i])
            end
        if IsValid(ply) then net.Send(ply) else net.Broadcast() end
    end)

    return burger
end

--[[ Add only one condiment into the burger ]]
function RFS.Cooking.AddBurgerCondiment(plank, model, color)
    if not IsValid(plank.burger) then 
        RFS.Cooking.CreateBurger(plank)   
    end
    
    timer.Simple(0.1, function()
        local burger = plank.burger
        if not IsValid(burger) then return end

        burger.RFS = burger.RFS or {}
        burger.RFS["condiments"] = burger.RFS["condiments"] or {}

        if #burger.RFS["condiments"] > RFS.MaxBurgerSize && model != "models/realistic_food_system/burger_top_bun.mdl"  then return end

        if burger.RFS["condiments"][1] != "models/realistic_food_system/burger_bottom_bun.mdl" && model != "models/realistic_food_system/burger_bottom_bun.mdl" then return end
        burger.RFS["condiments"][#burger.RFS["condiments"] + 1] = model

        if RFS.FoodPerModelBurger && isnumber(RFS.FoodPerModelBurger[model]) then
            burger.RFS["amountFood"] = (burger.RFS["amountFood"] or 0) + RFS.FoodPerModelBurger[model]
        end
        
        if not IsValid(burger) then return end
        
        color = color or RFS.Colors["white"]

        net.Start("RFS:Cooking")
            net.WriteUInt(3, 5)
            net.WriteUInt(1, 16)
            net.WriteEntity(burger)
            net.WriteString(model)
        net.Broadcast()
    end)

    if RFS.ComposeBurger[model] && isfunction(RFS.ComposeBurger[model]["func"]) then
        RFS.ComposeBurger[model]["func"](plank)
    end
end

function RFS.Cooking.FinishBurger(plank)
    if not IsValid(plank) then return end
    
    local burger = plank.burger

    if IsValid(burger) then
        local space = RFS.GetSpaceBurger(burger)

        local min1 = RFS.Constants["vector553"]
        local max1 = Vector(-5, 5, space.z)

        RFS.ModifyCollision(burger, min1, max1)

        burger:SetParent(nil)        
        plank.burger = nil
    end
end

--[[ Bag functions ]]

function RFS.Cooking.CreateBag(bagTable, pos, ang, ply)
    local bag = ents.Create("rfs_bag")
    bag:SetPos(pos)
    bag:SetAngles(ang)
    bag:Spawn()

    RFS.SetOwner(bag, ply)

    bag.RFS = bag.RFS or {}
    bag.RFS["inventories"] = bag.RFS["inventories"] or {}

    bagTable = bagTable or {}
    for k, v in pairs(bagTable) do
        if #bag.RFS["inventories"] >= RFS.MaxInventories then return end

        bag.RFS["inventories"][#bag.RFS["inventories"] + 1] = v
    end
    
    ply.RFS = ply.RFS or {}
    ply.RFS["bags"] = ply.RFS["bags"] or {}

    ply.RFS["bags"][#ply.RFS["bags"] + 1] = bag

    ply:RFSCheckBag()
end

function RFS.Cooking.AddIntoBag(bag, ent)
    if not IsValid(bag) or not IsValid(ent) then return end
    if bag:GetClass() != "rfs_bag" then return end
    
    ent.RFS = ent.RFS or {}
    if ent.RFS["addedOnBag"] then return end
    
    local entClass = ent:GetClass()
    
    bag.RFS = bag.RFS or {}
    bag.RFS["inventories"] = bag.RFS["inventories"] or {}

    if #bag.RFS["inventories"] >= RFS.MaxInventories then return end

    local tbl = RFS.Inventories[entClass]
    if istable(tbl) then
        local func = tbl["get"]
        if not isfunction(func) then return end

        local returnTable = func(ent)
        if not returnTable then return end

        bag.RFS["inventories"][#bag.RFS["inventories"] + 1] = returnTable
    else
        return
    end

    ent.RFS["addedOnBag"] = true
    ent:Remove()
end

function RFS.Cooking.GetIntoBag(bag, number, ply)
    if not IsValid(bag) or not isnumber(number) then return end

    bag.RFS = bag.RFS or {}
    bag.RFS["inventories"] = bag.RFS["inventories"] or {}
    
    local itemTable = bag.RFS["inventories"][number]
    if not istable(itemTable) then return end

    local class = itemTable["class"]
    if not isstring(class) then return end
        
    local actionTable = RFS.Inventories[class]
    if not istable(actionTable) then return end

    local createFunc = actionTable["create"]
    if not isfunction(createFunc) then return end

    local ent = createFunc(bag, itemTable["ingredientsTable"], bag.RFS["distributor"], itemTable)
    RFS.SetOwner(ent, ply)

    ent.RFS["distributor"] = (ent.RFS["distributor"] or itemTable["distributor"])

    table.remove(bag.RFS["inventories"], number)

    if #bag.RFS["inventories"] == 0 then
        bag:Remove()
    end

    RFS.Cooking.SendBag(bag, ply)
end

function RFS.Cooking.SendBag(bag, ply)
    if not IsValid(bag) or not IsValid(ply) then return end

    bag.RFS = bag.RFS or {}
    bag.RFS["inventories"] = bag.RFS["inventories"] or {}

    net.Start("RFS:Cooking")
        net.WriteUInt(4, 5)
        net.WriteEntity(bag)
        net.WriteUInt(table.Count(bag.RFS["inventories"]), 16)
        for class, inventoryTable in pairs(bag.RFS["inventories"]) do
            net.WriteString(inventoryTable["class"])

            inventoryTable["ingredientsTable"] = inventoryTable["ingredientsTable"] or {}

            net.WriteUInt(#inventoryTable["ingredientsTable"], 16)
            for k, v in ipairs(inventoryTable["ingredientsTable"]) do
                local valueType = (IsColor(v) and "color" or type(v))

                net.WriteString(valueType)
                net["Write"..RFS.TypeNet[valueType]](v, ((RFS.TypeNet[valueType] == "Int") and 32))
            end
        end
    net.Send(ply)
end

--[[ Tray function ]]

function RFS.Cooking.GetAvaiblePlace(tray)
    tray.RFS = tray.RFS or {}
    tray.RFS["postionTaken"] = tray.RFS["postionTaken"] or {}

    local vectorToReturn
    for k, v in ipairs(RFS.TrayPosition) do
        if tray.RFS["postionTaken"][k] then continue end

        return v, k
    end
end

function RFS.Cooking.AddTray(tray, ent)
    if not IsValid(tray) or tray:GetClass() != "rfs_tray" then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

    tray.RFS = tray.RFS or {}
    tray.RFS["postionTaken"] = tray.RFS["postionTaken"] or {}

    local entClass = ent:GetClass()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

    local func = RFS.TrayAllowedEnt[entClass]
    if not isfunction(func) then return end
    
    if not func(ent) then return end

    local placeTable, placeId = RFS.Cooking.GetAvaiblePlace(tray)
    if not placeTable then return end

    if not isvector(placeTable["pos"]) or not isangle(placeTable["ang"]) then return end
    
    ent.RFS = ent.RFS or {}
    ent.RFS["trayPlaceId"] = placeId

    local addVector = RFS.Constants["vector0"]

    if isvector(RFS.TrayCustomPosition[entClass]) then
        addVector = addVector + RFS.TrayCustomPosition[entClass]
    end

    ent:SetPos(tray:LocalToWorld(placeTable["pos"] + addVector))
    ent:SetAngles(tray:LocalToWorldAngles(placeTable["ang"]))
    ent:SetParent(tray)

    ent:CallOnRemove("rfs_reset_tray:"..ent:EntIndex(), function(ent)
        local tray = ent:GetParent()
        if not IsValid(tray) or tray:GetClass() != "rfs_tray" then return end
        
        tray.RFS = tray.RFS or {}
        tray.RFS["postionTaken"] = tray.RFS["postionTaken"] or {}
        
        tray.RFS["postionTaken"][ent.RFS["trayPlaceId"]] = nil
        ent.RFS["trayPlaceId"] = nil
    end) 
    
    tray.RFS["postionTaken"][placeId] = true
end

function RFS.Cooking.RemoveOnTray(ent)
    local tray = ent:GetParent()
    if tray:GetClass() != "rfs_tray" or not isnumber(ent.RFS["trayPlaceId"]) then return end

    ent.RFS = ent.RFS or {}

    ent:SetParent(nil)
    
    tray.RFS = tray.RFS or {}
    tray.RFS["postionTaken"] = tray.RFS["postionTaken"] or {}
    tray.RFS["postionTaken"][ent.RFS["trayPlaceId"]] = true

    ent.RFS["cooldownToEnter"] = CurTime() + 3
    ent.RFS["trayPlaceId"] = nil
end

--[[ Dishes functions ]]

function RFS.Cooking.DishesChangeStatus(dishes, activate)
    if not IsValid(dishes) then return end

    local oldValue = RFS.GetNWVariables("rfs_dishes_status", dishes)
    local newValue = (isbool(activate) and activate or !oldValue)

    RFS.SetNWVariable("rfs_dishes_status", newValue, dishes, true, nil, true)

    if newValue then
        RFS.Cooking.DishesStartMission(dishes)
    else
        RFS.Cooking.DishesResetMission(dishes)
    end
end

function RFS.Cooking.DishesStartMission(dishes)
    if not IsValid(dishes) then return end
    
    local entIndex = dishes:EntIndex()
    if timer.Exists("rfs_dishes_missions:"..entIndex) then return end

    local min, max = (RFS.MaxMinNewMissionTime[1] or 10), (RFS.MaxMinNewMissionTime[2] or 60)
    
    timer.Create("rfs_dishes_missions:"..entIndex, math.random(min, max), 1, function()
        if not IsValid(dishes) then return end
        
        local missionId = math.random(1, #RFS.Missions)

        if not RFS.Missions[missionId] then 
            RFS.Cooking.DishesStartMission(dishes)
            return 
        end

        local min, max = (RFS.Missions[missionId]["maxTime"][1] or 20), (RFS.Missions[missionId]["maxTime"][2] or 60)
        local maxTime = math.random(min, max)

        local timeEnd = CurTime() + maxTime

        dishes.RFS = dishes.RFS or {}
        dishes.RFS["mission"] = {
            ["missionId"] = missionId,
            ["timeEnd"] = timeEnd,
            ["maxTime"] = maxTime,
            ["class"] = RFS.Missions[missionId]["class"],
        }

        --[[ Set NWVariable but don't send it to players ]]
        RFS.SetNWVariable("rfs_dishes_timeEnd", dishes.RFS["mission"]["timeEnd"], dishes, false, nil, true)
        RFS.SetNWVariable("rfs_dishes_missionID", dishes.RFS["mission"]["missionId"], dishes, false, nil, true)
        RFS.SetNWVariable("rfs_dishes_maxTime", dishes.RFS["mission"]["maxTime"], dishes, false, nil, true)

        --[[ Send when variables has been set ]]
        RFS.SyncAllNWVariables(dishes, nil)

        timer.Create("rfs_dishes_mission_finished:"..entIndex, maxTime, 1, function()
            if not IsValid(dishes) then return end

            RFS.Cooking.DishesResetMission(dishes)
        end)
    end)
end

function RFS.Cooking.DishesResetMission(dishes)
    if not IsValid(dishes) then return end
    local entIndex = dishes:EntIndex()

    if timer.Exists("rfs_dishes_missions:"..entIndex) then
        timer.Remove("rfs_dishes_missions:"..entIndex)
    end

    dishes.RFS = dishes.RFS or {}
    dishes.RFS["mission"] = nil
    
    --[[ Set NWVariable but don't send it to players ]]
    RFS.SetNWVariable("rfs_dishes_timeEnd", 0, dishes, false, nil, true)
    RFS.SetNWVariable("rfs_dishes_missionID", 0, dishes, false, nil, true)
    RFS.SetNWVariable("rfs_dishes_maxTime", 0, dishes, false, nil, true)

    --[[ Send when variables has been set ]]
    RFS.SyncAllNWVariables(dishes, nil)

    local activate = RFS.GetNWVariables("rfs_dishes_status", dishes)

    if activate then
        RFS.Cooking.DishesStartMission(dishes)
    end
end

function RFS.Cooking.CheckIngredient(ingredientsTable, tableToCheck)
    local pourcent = 0
    for k, v in pairs(ingredientsTable) do
        if tableToCheck[k] != v then continue end

        pourcent = pourcent + (1/#ingredientsTable)
    end
    return pourcent
end

function RFS.Cooking.DishesCheckMission(dishes, ent)
    if not IsValid(dishes) or not IsValid(ent) then return end

    local dishesMission = dishes.RFS["mission"]
    if not dishesMission then return end

    local classMission = dishesMission["class"]
    if not isstring(classMission) then return end

    local missionId = dishesMission["missionId"]
    if not RFS.Missions[missionId] then return end

    local class = ent:GetClass()
    if class == classMission then
        ent:SetPos(dishes:LocalToWorld(RFS.Constants["vector0"]))
        ent:SetAngles(dishes:LocalToWorldAngles(RFS.Constants["angle0"]))

        ent:SetParent(dishes)

        timer.Simple(1, function()
            if not IsValid(ent) or not IsValid(dishes) then return end
            local ingredientsTable = RFS.Missions[missionId]["ingredientsTable"] or {}
    
            local tableToCheck = {}
            if class == "rfs_burger" then
                ent.RFS = ent.RFS or {}
                ent.RFS["condiments"] = ent.RFS["condiments"] or {}
    
                tableToCheck = ent.RFS["condiments"]
            else
                tableToCheck[#tableToCheck + 1] = ent:GetModel()
            end
            
            --[[ Check if the order is correct and calcul a pourcentage ]]
            local successPourcent = RFS.Cooking.CheckIngredient(ingredientsTable, tableToCheck)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
            
            --[[ Get the time ]]
            local curTime = CurTime()
            
            local timeEnd = RFS.GetNWVariables("rfs_dishes_timeEnd", dishes)
            local maxTime = RFS.GetNWVariables("rfs_dishes_maxTime", dishes)
            
            local timeEndCalculate = math.Clamp(math.Round((timeEnd or curTime) - curTime), 0, maxTime)
            local faceId = math.Clamp(math.ceil(3 - timeEndCalculate/(maxTime/(#RFS.Status + 1))), 1, #RFS.Status)
            
            local ratioTime = 1
            if faceId > 1 then
                ratioTime = timeEndCalculate/maxTime
            end
            successPourcent = math.Clamp((successPourcent*ratioTime), 0, 1)

            --[[ Calculate the price ]]
            local missionPrice = RFS.Missions[missionId]["price"] or 0
            missionPrice = math.Clamp(math.Round(missionPrice*successPourcent), 0, missionPrice)
    
            local owner = RFS.GetOwner(dishes)
    
            if IsValid(owner) then
                owner:RFSAddMoney(missionPrice)
                owner:RFSNotification(5, RFS.GetSentence("finishDishesOrder"):format(math.Round(successPourcent*100), RFS.formatMoney(missionPrice)))
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3
            
            dishes.soundCup = CreateSound(dishes, RFS.Sounds["bellSound"])
            dishes.soundCup:Play()

            dishes:ResetSequence("dring")
            ent:Remove()

            RFS.Cooking.DishesResetMission(dishes)
        end)
    end
end
