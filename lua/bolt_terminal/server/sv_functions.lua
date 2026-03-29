/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

local PLAYER = FindMetaTable("Player")

-- [[ Mysql database connection system ]] --
local mysqlDB
BT.MysqlConnected = false

if BT.Mysql then
    local succ, err = pcall(function() require("mysqloo") end)
    if not succ then return print("[BT] Error with MYSQLOO") end
    
    if not mysqloo then
        return print("[BT] Cannot require mysqloo module :\n"..requireError)
    end

    mysqlDB = mysqloo.connect(BT.MysqlInformations["host"], BT.MysqlInformations["username"], BT.MysqlInformations["password"], BT.MysqlInformations["database"], {["port"] = BT.MysqlInformations["port"]})
    function mysqlDB:onConnected()  
        print("[BT] Succesfuly connected to the mysql database !")
        BT.MysqlConnected = true
    end
    
    function mysqlDB:onConnectionFailed(connectionError)
        print("[BT] Cannot etablish database connection :\n"..connectionError)
    end
    mysqlDB:connect()
end

--[[ SQL Query function ]] --
function BT.Query(query, callback)
    if not isstring(query) then return end

    local result = {}
    local isInsertQuery = string.StartWith(query, "INSERT")
    if BT.Mysql then
        query = mysqlDB:query(query)

        if callback == "wait" then
            query:start()
            query:wait()

            local err = query:error()
            if err == "" then        
                return isInsertQuery and { lastInsertId = query:lastInsert() } or query:getData()
            else
                print("[BT] "..err)
            end
        else
            function query:onError(err, sql)
                print("[BT] "..err)
            end

            function query:onSuccess(tbl, data)
                if isfunction(callback) then
                    callback(isInsertQuery and { lastInsertId = query:lastInsert() } or tbl)
                end
            end
            query:start()
        end
    else
        result = sql.Query(query)
        result = isInsertQuery and { lastInsertId = sql.Query("SELECT last_insert_rowid()")[1]["last_insert_rowid()"] } or result
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

        if callback == "wait" then
            return result
            
        elseif isfunction(callback) then
            callback(result)

            return
        end
    end

    return (result or {})
end

-- [[ Escape the string ]] --  
function BT.Escape(str)
    return BT.MysqlConnected and ("'%s'"):format(mysqlDB:escape(tostring(str))) or SQLStr(str)    
end

--[[ Convert a string to a vector or an angle ]]
function BT.ToVectorOrAngle(toConvert, typeToSet)
    if not isstring(toConvert) or (typeToSet != Vector and typeToSet != Angle) then return end

    local convertArgs = string.Explode(" ", toConvert)
    local x, y, z = (tonumber(convertArgs[1]) or 0), (tonumber(convertArgs[2]) or 0), (tonumber(convertArgs[3]) or 0)
    
    return typeToSet == Vector and Vector(x, y, z) or Angle(x, y, z)
end

-- [[ Function to add a compatibility with autoincrement ]]
function BT.AutoIncrement()
    return (BT.Mysql and "AUTO_INCREMENT" or "AUTOINCREMENT")
end 

--[[ Initialize all mysql/sql table ]]
function BT.InitializeTables()
    local autoIncrement = BT.AutoIncrement()

    BT.Query(([[
        CREATE TABLE IF NOT EXISTS bt_ents(
            id INTEGER NOT NULL PRIMARY KEY %s,
            map VARCHAR(100),
            class VARCHAR(100),
            pos VARCHAR(150),
            ang VARCHAR(150)
        );
			
        CREATE TABLE IF NOT EXISTS bt_link_entities(
            id INTEGER NOT NULL PRIMARY KEY %s,
            entId INT,
            entLinkId INT,
            FOREIGN KEY(entId) REFERENCES bt_ents(id) ON DELETE CASCADE,
            FOREIGN KEY(entLinkId) REFERENCES bt_ents(id) ON DELETE CASCADE
        );
    ]]):format(autoIncrement, autoIncrement))
end

--[[ Link a screen to a terminal ]]
function BT.LinkScreenToTerminal(ply, screen, terminal)
    if not IsValid(screen) or not IsValid(terminal) then return end
    if screen:GetClass() != "bt_screen" or terminal:GetClass() != "bolt_terminal" then return end

    screen.BT["linkedTerminals"][terminal:EntIndex()] = true
    terminal.BT["linkedScreens"][screen:EntIndex()] = true

    BT.SendLinkedTerminal(nil, screen)
    
    if IsValid(ply) then
        ply:RFSResetConnection()
        ply:RFSNotification(5, BT.GetSentence("linkedScreen")) 
    end
end

--[[ UnLink a screen to a terminal ]]
function BT.UnLinkScreenToTerminal(ply, screen, terminal)
    if not IsValid(screen) or not IsValid(terminal) then return end
    if screen:GetClass() != "bt_screen" or terminal:GetClass() != "bolt_terminal" then return end
    
    screen.BT["linkedTerminals"][terminal:EntIndex()] = nil
    terminal.BT["linkedScreens"][screen:EntIndex()] = nil

    BT.SendLinkedTerminal(nil, screen)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

    if IsValid(ply) then
        ply:RFSResetConnection()
        ply:RFSNotification(5, BT.GetSentence("unlikedTerminal")) 
    end
end

--[[ Count all terminals linked to the screen ]]
function BT.CountScreenLinked(terminal)
    return table.Count(terminal.BT["linkedScreens"])
end

--[[ Set the owner of an entity ]]
function BT.SetOwner(ent, ply)
    if not IsValid(ply) or not IsValid(ent) then return end
    
    if isfunction(ent.CPPISetOwner) then
        ent:CPPISetOwner(ply)
    end

    BT.SetNWVariable("owner", ply, ent, true, nil, true)
end

--[[ Send to a player or to all the server the new connection ]]
function BT.SendLinkedTerminal(ply, screen)
    BT.CacheEntities = BT.CacheEntities or {}
    BT.CacheEntities["bt_screen"] = BT.CacheEntities["bt_screen"] or {}

    local validScreen = IsValid(screen)

    net.Start("BT:MainNet")
        net.WriteUInt(1, 5)
        net.WriteUInt((validScreen and 1 or table.Count(BT.CacheEntities["bt_screen"])), 16)
        
        for ent, _ in pairs((validScreen and {[screen] = true} or BT.CacheEntities["bt_screen"])) do
            ent.BT = ent.BT or {}
            ent.BT["linkedTerminals"] = ent.BT["linkedTerminals"] or {}
            
            net.WriteUInt(ent:EntIndex(), 16)
            net.WriteUInt(table.Count(ent.BT["linkedTerminals"]), 6)
            for k,v in pairs(ent.BT["linkedTerminals"]) do
                net.WriteUInt(k, 16)
            end
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Does the screen is already linked to the terminal ]]
function BT.IsLinkedToTerminal(screen, terminal)
    if not IsValid(screen) or not IsValid(terminal) then return end
    
    if screen.BT["linkedTerminals"][terminal:EntIndex()] then
        return true
    end
end

--[[ Send all orders of the terminal ]]
function BT.SendOrdersTerminal(ply, terminal)
    BT.CacheEntities = BT.CacheEntities or {}
    BT.CacheEntities["bolt_terminal"] = BT.CacheEntities["bolt_terminal"] or {}

    local validTerminal = IsValid(terminal)

    net.Start("BT:MainNet")
        net.WriteUInt(4, 5)
        net.WriteUInt((validTerminal and 1 or table.Count(BT.CacheEntities["bolt_terminal"])), 32)
        
        for ent, _ in pairs((validTerminal and {[terminal] = true} or BT.CacheEntities["bolt_terminal"])) do
            ent.BT = ent.BT or {}
            ent.BT["orders"] = ent.BT["orders"] or {}

            ent.BT["orders"] = table.ClearKeys(ent.BT["orders"])

            net.WriteUInt(ent:EntIndex(), 32)
            net.WriteUInt(#ent.BT["orders"], 32)
            for k, v in ipairs(ent.BT["orders"]) do
                net.WriteString(v.order)
                net.WriteString(v.clientName)
                net.WriteUInt((v.claimState or 1), 5)
                net.WriteUInt(v.startTime, 32)
                net.WriteUInt(v.uniqueId, 32)
                net.WriteUInt(v.quantity, 32)
            end
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Remove order and send to people ]]
function BT.RemoveOrder(terminal, orderId, ply, notSend)
    if not IsValid(terminal) then return end

    terminal.BT = terminal.BT or {}
    terminal.BT["orders"] = terminal.BT["orders"] or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

    if not istable(terminal.BT["orders"][orderId]) then return end
    
    local steamId64 = terminal.BT["orders"][orderId]["clientSteamID64"]

    BT.OrdersCount = BT.OrdersCount or {}
    BT.OrdersCount[steamId64] = math.Clamp((BT.OrdersCount[steamId64] or 0) - 1, 0, BT.MaxOrder)
    
    terminal.BT["orders"][orderId] = nil
    
    if not notSend then
        net.Start("BT:MainNet")
            net.WriteUInt(9, 5)
            net.WriteUInt(terminal:EntIndex(), 16)
            net.WriteUInt(orderId, 16)
        if IsValid(ply) then net.Send(ply) else net.Broadcast() end
    end
end

--[[ Claim order and send to people ]]
function BT.ClaimOrder(claimer, terminal, orderId, ply)
    if not IsValid(claimer) or not IsValid(terminal) then return end

    terminal.BT = terminal.BT or {}
    terminal.BT["orders"] = terminal.BT["orders"] or {}

    if not istable(terminal.BT["orders"][orderId]) then return end
    
    terminal.BT["orders"][orderId]["claimState"] = (terminal.BT["orders"][orderId]["claimState"] or 1) + 1
    
    local claimState = terminal.BT["orders"][orderId]["claimState"]
    if claimState == 2 then
        local price = terminal.BT["orders"][orderId]["price"]
        
        if isnumber(price) then
            claimer:RFSAddMoney(price)
            claimer:RFSNotification(5, BT.GetSentence("terminalReward"):format(BT.formatMoney(price)))
        end
    end

    if claimState > 3 then
        BT.RemoveOrder(terminal, orderId)
        return
    end

    net.Start("BT:MainNet")
        net.WriteUInt(8, 5)
        net.WriteUInt(terminal.BT["orders"][orderId]["claimState"], 5)
        net.WriteUInt(terminal:EntIndex(), 16)
        net.WriteUInt(orderId, 16)
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Create an order on the terminal ]]
function BT.CreateOrderOnTerminal(ply, terminal, orders, send, quantity, menuPrice)
    if not IsValid(terminal) or not IsValid(ply) then return end
    
    local uniqueId = math.random(1, 999)

    local steamId = ply:SteamID64()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
    
    BT.OrdersCount = BT.OrdersCount or {}
    BT.OrdersCount[steamId] = BT.OrdersCount[steamId] or 0
    BT.OrdersCount[steamId] = math.Clamp((BT.OrdersCount[steamId] + 1), 0, BT.MaxOrder)
    
    terminal.BT["orders"][#terminal.BT["orders"] + 1] = {
        ["order"] = orders,
        ["clientName"] = ply:Name(),
        ["clientSteamID64"] = ply:SteamID64(),
        ["claimed"] = false,
        ["uniqueId"] = uniqueId,
        ["startTime"] = CurTime(),
        ["quantity"] = quantity,
        ["price"] = menuPrice,
    }

    if send then
        BT.SendOrdersTerminal(nil, terminal)
    end

    return uniqueId
end

--[[ Get setting with key of a terminal ]]
function BT.GetTerminalSetting(terminal, key)
    terminal.BT = terminal.BT or {}
    terminal.BT["settings"] = terminal.BT["settings"] or {}

    return terminal.BT["settings"][key]
end

--[[ Save all settings of the terminal ]]
function BT.SaveTerminalSettings(terminal, settingsTable, moduleName, ply)
    if not IsValid(terminal) then return end

    terminal.BT = terminal.BT or {}
    terminal.BT["settings"] = terminal.BT["settings"] or {}
    
    if moduleName == "users" then
        terminal.BT["settings"]["users"] = settingsTable

    elseif moduleName == "quantity" then

        --[[ Make sure quantity is not upper than the number maximum ]]
        local tableToSave = terminal.BT["settings"]["quantity"] or {}
        for k, v in pairs(settingsTable) do
            v = math.Clamp(v, 0, (BT.MaxQuantity[k] or 1))

            tableToSave[k] = v
        end

        terminal.BT["settings"]["quantity"] = tableToSave
    elseif moduleName == "price" then
        --[[ Make sure price is not upper than the number maximum ]]
        local tableToSave = terminal.BT["settings"]["price"] or {}
        for k, v in pairs(settingsTable) do
            v = math.Clamp(v, 0, (BT.MaxPrice[k] or 1))
            
            tableToSave[k] = v
        end

        terminal.BT["settings"]["price"] = tableToSave
    end

    BT.SendTerminalSettings(nil, terminal, moduleName)
end

--[[ Send all/one setting(s) module(s) to a player or to everyone ]]
function BT.SendTerminalSettings(ply, terminal, moduleName)    
    net.Start("BT:TerminalSettings")
        net.WriteUInt(1, 5)
        net.WriteUInt((terminal and 1 or table.Count(BT.CacheEntities["bolt_terminal"])), 16)
        for ent, _ in pairs((terminal and {[terminal] = true} or BT.CacheEntities["bolt_terminal"])) do
            net.WriteUInt(ent:EntIndex(), 16)
            
            ent.BT = ent.BT or {}
            ent.BT["settings"] = ent.BT["settings"] or {}

            local tableToSend = {}
            if isstring(moduleName) then
                tableToSend = {
                    [moduleName] = ent.BT["settings"][moduleName] or {}
                }
            else
                tableToSend = ent.BT["settings"] or {}
            end

            net.WriteUInt(table.Count(tableToSend), 16)

            for moduleName, moduleTable in pairs(tableToSend) do
                net.WriteString(moduleName)
                net.WriteUInt(table.Count(moduleTable), 16)
                for k, v in pairs(moduleTable) do
                    local valueType = (IsColor(v) and "color" or type(v))

                    net.WriteString(valueType)
                    net.WriteString(k)
        
                    net["Write"..BT.TypeNet[valueType]](v, ((BT.TypeNet[valueType] == "Int") and 32))
                end
            end
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Check if the player can interact with the terminal (owner or admin/superadmin only) ]]
function BT.CanInteractTerminal(terminal, ply)
    if not IsValid(terminal) or terminal:GetClass() != "bolt_terminal" then return end
    if not IsValid(ply) then return end

    if BT.GetOwner(terminal) == ply then return true end
    if BT.AdminRank[ply:GetUserGroup()] then return true end

    return false
end

--[[ Save screen settings ]]
function BT.SaveScreenSettings(ply, settingsTable, screen)
    if not IsValid(screen) then return end

    screen.BT = screen.BT or {}
    
    screen.BT["settings"] = settingsTable

    BT.SendScreenSettings(nil, screen)
end

--[[ Send screen settings to one player or broadcast on all screen ]]
function BT.SendScreenSettings(ply, screen)
    net.Start("BT:ScreenSettings")
        net.WriteUInt(1, 5)
        net.WriteUInt((screen and 1 or table.Count(BT.CacheEntities["bt_screen"])), 16)
        for ent, _ in pairs((screen and {[screen] = true} or BT.CacheEntities["bt_screen"])) do
            net.WriteUInt(ent:EntIndex(), 16)
            
            ent.BT = ent.BT or {}
            ent.BT["settings"] = ent.BT["settings"] or {}
            
            net.WriteUInt(table.Count(ent.BT["settings"]), 16)

            for k, v in pairs(ent.BT["settings"]) do
                net.WriteString(k)
                net.WriteBool(v)
            end 
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Get setting with key of a terminal ]]
function BT.GetScreenOwners(screen)
    screen.BT = screen.BT or {}
    screen.BT["settings"] = screen.BT["settings"] or {}

    return screen.BT["settings"]
end

--[[ Check if the player can interact with the screen  ]]
function BT.CanInteractScreen(screen, ply)
    if not IsValid(screen) or screen:GetClass() != "bt_screen" then return end

    return true
end

--[[ This function permit to create variables on whatever you want networked with all players ]]
function BT.SetNWVariable(key, value, ent, send, ply, sync)
    if not IsValid(ent) or not isstring(key) then return end

    BT.NWVariables = BT.NWVariables or {}

    ent.RFSNWVariables = ent.RFSNWVariables or {}
    ent.RFSNWVariables[key] = value
    
    if sync then
        BT.NWVariables["networkEnt"] = BT.NWVariables["networkEnt"] or {}
        BT.NWVariables["networkEnt"][ent] = ent.RFSNWVariables

        ent:CallOnRemove("bt_reset_variables:"..ent:EntIndex(), function(ent) BT.NWVariables["networkEnt"][ent] = nil end) 
    end

    if send then
        BT.SyncNWVariable(key, ent, ply)
    end
end

--[[ Sync variable to the clientside or to everyone ]]
function BT.SyncNWVariable(key, ent, ply)
    if not IsValid(ent) or not isstring(key) then return end

    ent.RFSNWVariables = ent.RFSNWVariables or {}
    
    local value = ent.RFSNWVariables[key]
    if value == nil then return end

    local valueType = (IsColor(value) and "color" or type(value))

    net.Start("BT:MainNet")
        net.WriteUInt(10, 5)
        net.WriteUInt(1, 12)
        net.WriteUInt(ent:EntIndex(), 16)
        net.WriteUInt(1, 4)
        net.WriteString(valueType)
        net.WriteString(key)
        net["Write"..BT.TypeNet[valueType]](value, ((BT.TypeNet[valueType] == "Int") and 32))
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

function BT.SyncAllNWVariables(ent, ply)
    BT.NWVariables = BT.NWVariables or {}
    BT.NWVariables["networkEnt"] = BT.NWVariables["networkEnt"] or {}
    
    net.Start("BT:MainNet")
        net.WriteUInt(10, 5)
        
        local keys = (IsValid(ent) and {ent} or table.GetKeys(BT.NWVariables["networkEnt"]))
        net.WriteUInt(#keys, 12)
        for _, ent in ipairs(keys) do

            net.WriteUInt(ent:EntIndex(), 16)
            local variableKeys = table.GetKeys(BT.NWVariables["networkEnt"][ent])
            net.WriteUInt(#variableKeys, 4)
            for _, varName in ipairs(variableKeys) do
    
                local value = BT.NWVariables["networkEnt"][ent][varName]
                local valueType = type(value)

                net.WriteString(valueType)
                net.WriteString(varName)
                net["Write"..BT.TypeNet[valueType]](value, ((BT.TypeNet[valueType] == "Int") and 32))
            end
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

local entitiesToSave = {
    "bt_distributor",
    "bolt_terminal",
    "bt_screen",
}

--[[ Save one entity on the database ]]
function BT.AddEntitySaved(pos, ang, class)    
    if not isvector(pos) or not isangle(ang) or not isstring(class) then return end

    local posToSave = pos[1].." "..pos[2].." "..pos[3]
    local angToSave = ang[1].." "..ang[2].." "..ang[3]

    BT.Query(("INSERT INTO bt_ents (map, class, pos, ang) VALUES (%s, %s, %s, %s)"):format(BT.Escape(game.GetMap()), BT.Escape(class), BT.Escape(posToSave), BT.Escape(angToSave)))
    BT.ReloadEntities()
end

--[[ Remove an entity saved ]]
function BT.RemoveEntitySaved(id)
    BT.Query(("DELETE FROM bt_ents WHERE id = %s"):format(id))
end

--[[ Reload all entities saved with the toolgun ]]
function BT.ReloadEntities()
    --[[ Remove all entities spawned by the server ]]
    for _, class in ipairs(entitiesToSave) do
        for k, v in ipairs(ents.FindByClass(class)) do
            if not IsValid(v) or not v.spawnedByServer then continue end

            v:Remove()
        end
    end

    local entitiesByUniqueId = {}
    BT.Query(("SELECT * FROM bt_ents WHERE map = %s"):format(BT.Escape(game.GetMap())), function(tbl)
        if not istable(tbl) then return end

        for k, v in ipairs(tbl) do
            local pos = BT.ToVectorOrAngle(v.pos, Vector)
            local ang = BT.ToVectorOrAngle(v.ang, Angle)

            local ent = ents.Create(v.class)
            ent:SetPos(pos)
            ent:SetAngles(ang)
            ent:Spawn()
            ent.uniqueId = tonumber(v.id)
            ent.spawnedByServer = true

            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then
                phys:EnableMotion(false)
            end

            entitiesByUniqueId[ent.uniqueId] = ent

            timer.Simple(1, function()
                if not IsValid(ent) then return end
                
                BT.SetNWVariable("bt_spawned_by_server", true, ent, true, nil, true)
            end)
        end
    end)
    
    BT.Query("SELECT * FROM bt_link_entities", function(tbl)
        if not istable(tbl) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

        for k, v in ipairs(tbl) do
            local screen = entitiesByUniqueId[tonumber(v.entId)]
            local terminal = entitiesByUniqueId[tonumber(v.entLinkId)]

            if not IsValid(screen) or not IsValid(terminal) then continue end

            screen.BT["linkedTerminals"][terminal:EntIndex()] = true
            terminal.BT["linkedScreens"][screen:EntIndex()] = true

            BT.SendLinkedTerminal(nil, screen)
        end
    end)
end

--[[ Save linked entities on a sql table ]]
function BT.SaveLinkedEntities(screen, terminal)
    local screenLinkId = screen.uniqueId
    local terminalLinkId = terminal.uniqueId

    if not isnumber(screenLinkId) or not isnumber(terminalLinkId) then return end

    screen.BT["linkedTerminals"][terminal:EntIndex()] = true
    terminal.BT["linkedScreens"][screen:EntIndex()] = true

    BT.SendLinkedTerminal(nil, screen)

    BT.Query(("INSERT INTO bt_link_entities (entId, entLinkId) VALUES (%s, %s)"):format(screenLinkId, terminalLinkId))
end

--[[ Modify the collsion of an entity ]]
function BT.ModifyCollision(ent, min1, max1)
    if not IsValid(ent) or not isvector(min1) or not isvector(max1) then return end

    local convex = {
        {
            Vector(min1.x, min1.y, min1.z),
            Vector(min1.x, min1.y, max1.z),
            Vector(min1.x, max1.y, min1.z),
            Vector(min1.x, max1.y, max1.z),
            Vector(max1.x, min1.y, min1.z),
            Vector(max1.x, min1.y, max1.z),
            Vector(max1.x, max1.y, min1.z),
            Vector(max1.x, max1.y, max1.z),
        },
    }

    ent:PhysicsInitMultiConvex(convex)

    ent:SetSolid(SOLID_VPHYSICS)
    ent:SetMoveType(MOVETYPE_VPHYSICS)
    ent:EnableCustomCollisions(true)
    ent:PhysWake()
end

--[[ Send a notification to the player ]]
function PLAYER:RFSNotification(time, text)
    local curtime = CurTime()

    self.BT = self.BT or {}
    
    self.BT[text] = self.BT[text] or 0
    if self.BT[text] > curtime then return end
    self.BT[text] = curtime + 0.5

    net.Start("BT:Notification")
        net.WriteUInt(time, 3)
        net.WriteString(text)
    net.Send(self)
end

--[[ Stop connection rendering ]]
function PLAYER:RFSResetConnection()
    net.Start("BT:MainNet")
        net.WriteUInt(3, 5)
    net.Send(self)
end

--[[ This function permite to add compatibility with other gamemode ]]
function PLAYER:RFSAddMoney(price)
    if DarkRP then
        self:addMoney(price)
    elseif ix then
        if self:GetCharacter() != nil then
            local money = self:RFSGetMoney()
            self:GetCharacter():SetMoney(money + price)
        end
    elseif nut then
        if self:getChar() != nil then
            local money = self:RFSGetMoney()
            self:getChar():setMoney(money + price)
        end
    else
        self.RFSSandboxMoney = (self.RFSSandboxMoney or 0) + price
    end
end

--[[ Remove hand, and select old weapon ]]
function PLAYER:RFSRemoveHand()
    local wep = self:GetWeapon("bt_hand")
	if IsValid(wep) then
		self:StripWeapon("bt_hand")
	end

	if isstring(self.BT["oldWeapon"]) then
		self:SelectWeapon(self.BT["oldWeapon"])
		self.BT["oldWeapon"] = nil
	end

	net.Start("BT:Cooking")
		net.WriteUInt(1, 5)
	net.Send(self)
end

--[[ Check bag limit ]]
function PLAYER:RFSCheckBag()
    self.BT = self.BT or {}
    self.BT["bags"] = self.BT["bags"] or {}

    local count = #self.BT["bags"]
    local tableRevert = table.Reverse(self.BT["bags"])

    for i=1, count do
        if i > BT.MaxBagByPlayer then
            if IsValid(tableRevert[i]) then
                tableRevert[i]:Remove()
                table.remove(self.BT["bags"], (count+1)-i)
            end
        end
    end
end

--[[ Give the food or the health to the player ]]
function PLAYER:RFSSetFood(amount)
    if not BT.GiveHealth then
        if DarkRP then
            self:setDarkRPVar("Energy", math.Clamp(amount, 0, 100))           
        end
    else
        local health = self:Health()
        self:SetHealth(math.Clamp(amount, 0, self:GetMaxHealth()))
    end
end

function PLAYER:RFSEatSomething(ent, amount)
    if not IsValid(ent) then return end

    local class = ent:GetClass()
    local amount = (isnumber(amount) and amount or (BT.AmountFood[class] or 0))

    if not isnumber(amount) then return end
    local curentAmount = self:RFSGetFood()

    self:RFSSetFood(curentAmount + amount)
end
