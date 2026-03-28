/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

local PLAYER = FindMetaTable("Player")

-- [[ Mysql database connection system ]] --
local mysqlDB
RFS.MysqlConnected = false

if RFS.Mysql then
    local succ, err = pcall(function() require("mysqloo") end)
    if not succ then return print("[RFS] Error with MYSQLOO") end
    
    if not mysqloo then
        return print("[RFS] Cannot require mysqloo module :\n"..requireError)
    end

    mysqlDB = mysqloo.connect(RFS.MysqlInformations["host"], RFS.MysqlInformations["username"], RFS.MysqlInformations["password"], RFS.MysqlInformations["database"], {["port"] = RFS.MysqlInformations["port"]})
    function mysqlDB:onConnected()  
        print("[RFS] Succesfuly connected to the mysql database !")
        RFS.MysqlConnected = true
    end
    
    function mysqlDB:onConnectionFailed(connectionError)
        print("[RFS] Cannot etablish database connection :\n"..connectionError)
    end
    mysqlDB:connect()
end

--[[ SQL Query function ]] --
function RFS.Query(query, callback)
    if not isstring(query) then return end

    local result = {}
    local isInsertQuery = string.StartWith(query, "INSERT")
    if RFS.Mysql then
        query = mysqlDB:query(query)

        if callback == "wait" then
            query:start()
            query:wait()

            local err = query:error()
            if err == "" then        
                return isInsertQuery and { lastInsertId = query:lastInsert() } or query:getData()
            else
                print("[RFS] "..err)
            end
        else
            function query:onError(err, sql)
                print("[RFS] "..err)
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
function RFS.Escape(str)
    return RFS.MysqlConnected and ("'%s'"):format(mysqlDB:escape(tostring(str))) or SQLStr(str)    
end

--[[ Convert a string to a vector or an angle ]]
function RFS.ToVectorOrAngle(toConvert, typeToSet)
    if not isstring(toConvert) or (typeToSet != Vector and typeToSet != Angle) then return end

    local convertArgs = string.Explode(" ", toConvert)
    local x, y, z = (tonumber(convertArgs[1]) or 0), (tonumber(convertArgs[2]) or 0), (tonumber(convertArgs[3]) or 0)
    
    return typeToSet == Vector and Vector(x, y, z) or Angle(x, y, z)
end

-- [[ Function to add a compatibility with autoincrement ]]
function RFS.AutoIncrement()
    return (RFS.Mysql and "AUTO_INCREMENT" or "AUTOINCREMENT")
end 

--[[ Initialize all mysql/sql table ]]
function RFS.InitializeTables()
    local autoIncrement = RFS.AutoIncrement()

    RFS.Query(([[
        CREATE TABLE IF NOT EXISTS rfs_ents(
            id INTEGER NOT NULL PRIMARY KEY %s,
            map VARCHAR(100),
            class VARCHAR(100),
            pos VARCHAR(150),
            ang VARCHAR(150)
        );
			
        CREATE TABLE IF NOT EXISTS rfs_link_entities(
            id INTEGER NOT NULL PRIMARY KEY %s,
            entId INT,
            entLinkId INT,
            FOREIGN KEY(entId) REFERENCES rfs_ents(id) ON DELETE CASCADE,
            FOREIGN KEY(entLinkId) REFERENCES rfs_ents(id) ON DELETE CASCADE
        );
    ]]):format(autoIncrement, autoIncrement))
end

--[[ Link a screen to a terminal ]]
function RFS.LinkScreenToTerminal(ply, screen, terminal)
    if not IsValid(screen) or not IsValid(terminal) then return end
    if screen:GetClass() != "rfs_screen" or terminal:GetClass() != "rfs_terminal" then return end

    screen.RFS["linkedTerminals"][terminal:EntIndex()] = true
    terminal.RFS["linkedScreens"][screen:EntIndex()] = true

    RFS.SendLinkedTerminal(nil, screen)
    
    if IsValid(ply) then
        ply:RFSResetConnection()
        ply:RFSNotification(5, RFS.GetSentence("linkedScreen")) 
    end
end

--[[ UnLink a screen to a terminal ]]
function RFS.UnLinkScreenToTerminal(ply, screen, terminal)
    if not IsValid(screen) or not IsValid(terminal) then return end
    if screen:GetClass() != "rfs_screen" or terminal:GetClass() != "rfs_terminal" then return end
    
    screen.RFS["linkedTerminals"][terminal:EntIndex()] = nil
    terminal.RFS["linkedScreens"][screen:EntIndex()] = nil

    RFS.SendLinkedTerminal(nil, screen)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

    if IsValid(ply) then
        ply:RFSResetConnection()
        ply:RFSNotification(5, RFS.GetSentence("unlikedTerminal")) 
    end
end

--[[ Count all terminals linked to the screen ]]
function RFS.CountScreenLinked(terminal)
    return table.Count(terminal.RFS["linkedScreens"])
end

--[[ Set the owner of an entity ]]
function RFS.SetOwner(ent, ply)
    if not IsValid(ply) or not IsValid(ent) then return end
    
    if isfunction(ent.CPPISetOwner) then
        ent:CPPISetOwner(ply)
    end

    RFS.SetNWVariable("owner", ply, ent, true, nil, true)
end

--[[ Send to a player or to all the server the new connection ]]
function RFS.SendLinkedTerminal(ply, screen)
    RFS.CacheEntities = RFS.CacheEntities or {}
    RFS.CacheEntities["rfs_screen"] = RFS.CacheEntities["rfs_screen"] or {}

    local validScreen = IsValid(screen)

    net.Start("RFS:MainNet")
        net.WriteUInt(1, 5)
        net.WriteUInt((validScreen and 1 or table.Count(RFS.CacheEntities["rfs_screen"])), 16)
        
        for ent, _ in pairs((validScreen and {[screen] = true} or RFS.CacheEntities["rfs_screen"])) do
            ent.RFS = ent.RFS or {}
            ent.RFS["linkedTerminals"] = ent.RFS["linkedTerminals"] or {}
            
            net.WriteUInt(ent:EntIndex(), 16)
            net.WriteUInt(table.Count(ent.RFS["linkedTerminals"]), 6)
            for k,v in pairs(ent.RFS["linkedTerminals"]) do
                net.WriteUInt(k, 16)
            end
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Does the screen is already linked to the terminal ]]
function RFS.IsLinkedToTerminal(screen, terminal)
    if not IsValid(screen) or not IsValid(terminal) then return end
    
    if screen.RFS["linkedTerminals"][terminal:EntIndex()] then
        return true
    end
end

--[[ Send all orders of the terminal ]]
function RFS.SendOrdersTerminal(ply, terminal)
    RFS.CacheEntities = RFS.CacheEntities or {}
    RFS.CacheEntities["rfs_terminal"] = RFS.CacheEntities["rfs_terminal"] or {}

    local validTerminal = IsValid(terminal)

    net.Start("RFS:MainNet")
        net.WriteUInt(4, 5)
        net.WriteUInt((validTerminal and 1 or table.Count(RFS.CacheEntities["rfs_terminal"])), 32)
        
        for ent, _ in pairs((validTerminal and {[terminal] = true} or RFS.CacheEntities["rfs_terminal"])) do
            ent.RFS = ent.RFS or {}
            ent.RFS["orders"] = ent.RFS["orders"] or {}

            ent.RFS["orders"] = table.ClearKeys(ent.RFS["orders"])

            net.WriteUInt(ent:EntIndex(), 32)
            net.WriteUInt(#ent.RFS["orders"], 32)
            for k, v in ipairs(ent.RFS["orders"]) do
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
function RFS.RemoveOrder(terminal, orderId, ply, notSend)
    if not IsValid(terminal) then return end

    terminal.RFS = terminal.RFS or {}
    terminal.RFS["orders"] = terminal.RFS["orders"] or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

    if not istable(terminal.RFS["orders"][orderId]) then return end
    
    local steamId64 = terminal.RFS["orders"][orderId]["clientSteamID64"]

    RFS.OrdersCount = RFS.OrdersCount or {}
    RFS.OrdersCount[steamId64] = math.Clamp((RFS.OrdersCount[steamId64] or 0) - 1, 0, RFS.MaxOrder)
    
    terminal.RFS["orders"][orderId] = nil
    
    if not notSend then
        net.Start("RFS:MainNet")
            net.WriteUInt(9, 5)
            net.WriteUInt(terminal:EntIndex(), 16)
            net.WriteUInt(orderId, 16)
        if IsValid(ply) then net.Send(ply) else net.Broadcast() end
    end
end

--[[ Claim order and send to people ]]
function RFS.ClaimOrder(claimer, terminal, orderId, ply)
    if not IsValid(claimer) or not IsValid(terminal) then return end

    terminal.RFS = terminal.RFS or {}
    terminal.RFS["orders"] = terminal.RFS["orders"] or {}

    if not istable(terminal.RFS["orders"][orderId]) then return end
    
    terminal.RFS["orders"][orderId]["claimState"] = (terminal.RFS["orders"][orderId]["claimState"] or 1) + 1
    
    local claimState = terminal.RFS["orders"][orderId]["claimState"]
    if claimState == 2 then
        local price = terminal.RFS["orders"][orderId]["price"]
        
        if isnumber(price) then
            claimer:RFSAddMoney(price)
            claimer:RFSNotification(5, RFS.GetSentence("terminalReward"):format(RFS.formatMoney(price)))
        end
    end

    if claimState > 3 then
        RFS.RemoveOrder(terminal, orderId)
        return
    end

    net.Start("RFS:MainNet")
        net.WriteUInt(8, 5)
        net.WriteUInt(terminal.RFS["orders"][orderId]["claimState"], 5)
        net.WriteUInt(terminal:EntIndex(), 16)
        net.WriteUInt(orderId, 16)
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Create an order on the terminal ]]
function RFS.CreateOrderOnTerminal(ply, terminal, orders, send, quantity, menuPrice)
    if not IsValid(terminal) or not IsValid(ply) then return end
    
    local uniqueId = math.random(1, 999)

    local steamId = ply:SteamID64()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
    
    RFS.OrdersCount = RFS.OrdersCount or {}
    RFS.OrdersCount[steamId] = RFS.OrdersCount[steamId] or 0
    RFS.OrdersCount[steamId] = math.Clamp((RFS.OrdersCount[steamId] + 1), 0, RFS.MaxOrder)
    
    terminal.RFS["orders"][#terminal.RFS["orders"] + 1] = {
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
        RFS.SendOrdersTerminal(nil, terminal)
    end

    return uniqueId
end

--[[ Get setting with key of a terminal ]]
function RFS.GetTerminalSetting(terminal, key)
    terminal.RFS = terminal.RFS or {}
    terminal.RFS["settings"] = terminal.RFS["settings"] or {}

    return terminal.RFS["settings"][key]
end

--[[ Save all settings of the terminal ]]
function RFS.SaveTerminalSettings(terminal, settingsTable, moduleName, ply)
    if not IsValid(terminal) then return end

    terminal.RFS = terminal.RFS or {}
    terminal.RFS["settings"] = terminal.RFS["settings"] or {}
    
    if moduleName == "users" then
        terminal.RFS["settings"]["users"] = settingsTable

    elseif moduleName == "quantity" then

        --[[ Make sure quantity is not upper than the number maximum ]]
        local tableToSave = terminal.RFS["settings"]["quantity"] or {}
        for k, v in pairs(settingsTable) do
            v = math.Clamp(v, 0, (RFS.MaxQuantity[k] or 1))

            tableToSave[k] = v
        end

        terminal.RFS["settings"]["quantity"] = tableToSave
    elseif moduleName == "price" then
        --[[ Make sure price is not upper than the number maximum ]]
        local tableToSave = terminal.RFS["settings"]["price"] or {}
        for k, v in pairs(settingsTable) do
            v = math.Clamp(v, 0, (RFS.MaxPrice[k] or 1))
            
            tableToSave[k] = v
        end

        terminal.RFS["settings"]["price"] = tableToSave
    end

    RFS.SendTerminalSettings(nil, terminal, moduleName)
end

--[[ Send all/one setting(s) module(s) to a player or to everyone ]]
function RFS.SendTerminalSettings(ply, terminal, moduleName)    
    net.Start("RFS:TerminalSettings")
        net.WriteUInt(1, 5)
        net.WriteUInt((terminal and 1 or table.Count(RFS.CacheEntities["rfs_terminal"])), 16)
        for ent, _ in pairs((terminal and {[terminal] = true} or RFS.CacheEntities["rfs_terminal"])) do
            net.WriteUInt(ent:EntIndex(), 16)
            
            ent.RFS = ent.RFS or {}
            ent.RFS["settings"] = ent.RFS["settings"] or {}

            local tableToSend = {}
            if isstring(moduleName) then
                tableToSend = {
                    [moduleName] = ent.RFS["settings"][moduleName] or {}
                }
            else
                tableToSend = ent.RFS["settings"] or {}
            end

            net.WriteUInt(table.Count(tableToSend), 16)

            for moduleName, moduleTable in pairs(tableToSend) do
                net.WriteString(moduleName)
                net.WriteUInt(table.Count(moduleTable), 16)
                for k, v in pairs(moduleTable) do
                    local valueType = (IsColor(v) and "color" or type(v))

                    net.WriteString(valueType)
                    net.WriteString(k)
        
                    net["Write"..RFS.TypeNet[valueType]](v, ((RFS.TypeNet[valueType] == "Int") and 32))
                end
            end
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Check if the player can interact with the terminal (owner or admin/superadmin only) ]]
function RFS.CanInteractTerminal(terminal, ply)
    if not IsValid(terminal) or terminal:GetClass() != "rfs_terminal" then return end
    if not IsValid(ply) then return end

    if RFS.GetOwner(terminal) == ply then return true end
    if RFS.AdminRank[ply:GetUserGroup()] then return true end

    return false
end

--[[ Save screen settings ]]
function RFS.SaveScreenSettings(ply, settingsTable, screen)
    if not IsValid(screen) then return end

    screen.RFS = screen.RFS or {}
    
    screen.RFS["settings"] = settingsTable

    RFS.SendScreenSettings(nil, screen)
end

--[[ Send screen settings to one player or broadcast on all screen ]]
function RFS.SendScreenSettings(ply, screen)
    net.Start("RFS:ScreenSettings")
        net.WriteUInt(1, 5)
        net.WriteUInt((screen and 1 or table.Count(RFS.CacheEntities["rfs_screen"])), 16)
        for ent, _ in pairs((screen and {[screen] = true} or RFS.CacheEntities["rfs_screen"])) do
            net.WriteUInt(ent:EntIndex(), 16)
            
            ent.RFS = ent.RFS or {}
            ent.RFS["settings"] = ent.RFS["settings"] or {}
            
            net.WriteUInt(table.Count(ent.RFS["settings"]), 16)

            for k, v in pairs(ent.RFS["settings"]) do
                net.WriteString(k)
                net.WriteBool(v)
            end 
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Get setting with key of a terminal ]]
function RFS.GetScreenOwners(screen)
    screen.RFS = screen.RFS or {}
    screen.RFS["settings"] = screen.RFS["settings"] or {}

    return screen.RFS["settings"]
end

--[[ Check if the player can interact with the screen  ]]
function RFS.CanInteractScreen(screen, ply)
    if not IsValid(screen) or screen:GetClass() != "rfs_screen" then return end

    return true
end

--[[ This function permit to create variables on whatever you want networked with all players ]]
function RFS.SetNWVariable(key, value, ent, send, ply, sync)
    if not IsValid(ent) or not isstring(key) then return end

    RFS.NWVariables = RFS.NWVariables or {}

    ent.RFSNWVariables = ent.RFSNWVariables or {}
    ent.RFSNWVariables[key] = value
    
    if sync then
        RFS.NWVariables["networkEnt"] = RFS.NWVariables["networkEnt"] or {}
        RFS.NWVariables["networkEnt"][ent] = ent.RFSNWVariables

        ent:CallOnRemove("rfs_reset_variables:"..ent:EntIndex(), function(ent) RFS.NWVariables["networkEnt"][ent] = nil end) 
    end

    if send then
        RFS.SyncNWVariable(key, ent, ply)
    end
end

--[[ Sync variable to the clientside or to everyone ]]
function RFS.SyncNWVariable(key, ent, ply)
    if not IsValid(ent) or not isstring(key) then return end

    ent.RFSNWVariables = ent.RFSNWVariables or {}
    
    local value = ent.RFSNWVariables[key]
    if value == nil then return end

    local valueType = (IsColor(value) and "color" or type(value))

    net.Start("RFS:MainNet")
        net.WriteUInt(10, 5)
        net.WriteUInt(1, 12)
        net.WriteUInt(ent:EntIndex(), 16)
        net.WriteUInt(1, 4)
        net.WriteString(valueType)
        net.WriteString(key)
        net["Write"..RFS.TypeNet[valueType]](value, ((RFS.TypeNet[valueType] == "Int") and 32))
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

function RFS.SyncAllNWVariables(ent, ply)
    RFS.NWVariables = RFS.NWVariables or {}
    RFS.NWVariables["networkEnt"] = RFS.NWVariables["networkEnt"] or {}
    
    net.Start("RFS:MainNet")
        net.WriteUInt(10, 5)
        
        local keys = (IsValid(ent) and {ent} or table.GetKeys(RFS.NWVariables["networkEnt"]))
        net.WriteUInt(#keys, 12)
        for _, ent in ipairs(keys) do

            net.WriteUInt(ent:EntIndex(), 16)
            local variableKeys = table.GetKeys(RFS.NWVariables["networkEnt"][ent])
            net.WriteUInt(#variableKeys, 4)
            for _, varName in ipairs(variableKeys) do
    
                local value = RFS.NWVariables["networkEnt"][ent][varName]
                local valueType = type(value)

                net.WriteString(valueType)
                net.WriteString(varName)
                net["Write"..RFS.TypeNet[valueType]](value, ((RFS.TypeNet[valueType] == "Int") and 32))
            end
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

local entitiesToSave = {
    "rfs_distributor",
    "rfs_terminal",
    "rfs_screen",
}

--[[ Save one entity on the database ]]
function RFS.AddEntitySaved(pos, ang, class)    
    if not isvector(pos) or not isangle(ang) or not isstring(class) then return end

    local posToSave = pos[1].." "..pos[2].." "..pos[3]
    local angToSave = ang[1].." "..ang[2].." "..ang[3]

    RFS.Query(("INSERT INTO rfs_ents (map, class, pos, ang) VALUES (%s, %s, %s, %s)"):format(RFS.Escape(game.GetMap()), RFS.Escape(class), RFS.Escape(posToSave), RFS.Escape(angToSave)))
    RFS.ReloadEntities()
end

--[[ Remove an entity saved ]]
function RFS.RemoveEntitySaved(id)
    RFS.Query(("DELETE FROM rfs_ents WHERE id = %s"):format(id))
end

--[[ Reload all entities saved with the toolgun ]]
function RFS.ReloadEntities()
    --[[ Remove all entities spawned by the server ]]
    for _, class in ipairs(entitiesToSave) do
        for k, v in ipairs(ents.FindByClass(class)) do
            if not IsValid(v) or not v.spawnedByServer then continue end

            v:Remove()
        end
    end

    local entitiesByUniqueId = {}
    RFS.Query(("SELECT * FROM rfs_ents WHERE map = %s"):format(RFS.Escape(game.GetMap())), function(tbl)
        if not istable(tbl) then return end

        for k, v in ipairs(tbl) do
            local pos = RFS.ToVectorOrAngle(v.pos, Vector)
            local ang = RFS.ToVectorOrAngle(v.ang, Angle)

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
                
                RFS.SetNWVariable("rfs_spawned_by_server", true, ent, true, nil, true)
            end)
        end
    end)
    
    RFS.Query("SELECT * FROM rfs_link_entities", function(tbl)
        if not istable(tbl) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

        for k, v in ipairs(tbl) do
            local screen = entitiesByUniqueId[tonumber(v.entId)]
            local terminal = entitiesByUniqueId[tonumber(v.entLinkId)]

            if not IsValid(screen) or not IsValid(terminal) then continue end

            screen.RFS["linkedTerminals"][terminal:EntIndex()] = true
            terminal.RFS["linkedScreens"][screen:EntIndex()] = true

            RFS.SendLinkedTerminal(nil, screen)
        end
    end)
end

--[[ Save linked entities on a sql table ]]
function RFS.SaveLinkedEntities(screen, terminal)
    local screenLinkId = screen.uniqueId
    local terminalLinkId = terminal.uniqueId

    if not isnumber(screenLinkId) or not isnumber(terminalLinkId) then return end

    screen.RFS["linkedTerminals"][terminal:EntIndex()] = true
    terminal.RFS["linkedScreens"][screen:EntIndex()] = true

    RFS.SendLinkedTerminal(nil, screen)

    RFS.Query(("INSERT INTO rfs_link_entities (entId, entLinkId) VALUES (%s, %s)"):format(screenLinkId, terminalLinkId))
end

--[[ Modify the collsion of an entity ]]
function RFS.ModifyCollision(ent, min1, max1)
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

    self.RFS = self.RFS or {}
    
    self.RFS[text] = self.RFS[text] or 0
    if self.RFS[text] > curtime then return end
    self.RFS[text] = curtime + 0.5

    net.Start("RFS:Notification")
        net.WriteUInt(time, 3)
        net.WriteString(text)
    net.Send(self)
end

--[[ Stop connection rendering ]]
function PLAYER:RFSResetConnection()
    net.Start("RFS:MainNet")
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
    local wep = self:GetWeapon("rfs_hand")
	if IsValid(wep) then
		self:StripWeapon("rfs_hand")
	end

	if isstring(self.RFS["oldWeapon"]) then
		self:SelectWeapon(self.RFS["oldWeapon"])
		self.RFS["oldWeapon"] = nil
	end

	net.Start("RFS:Cooking")
		net.WriteUInt(1, 5)
	net.Send(self)
end

--[[ Check bag limit ]]
function PLAYER:RFSCheckBag()
    self.RFS = self.RFS or {}
    self.RFS["bags"] = self.RFS["bags"] or {}

    local count = #self.RFS["bags"]
    local tableRevert = table.Reverse(self.RFS["bags"])

    for i=1, count do
        if i > RFS.MaxBagByPlayer then
            if IsValid(tableRevert[i]) then
                tableRevert[i]:Remove()
                table.remove(self.RFS["bags"], (count+1)-i)
            end
        end
    end
end

--[[ Give the food or the health to the player ]]
function PLAYER:RFSSetFood(amount)
    if not RFS.GiveHealth then
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
    local amount = (isnumber(amount) and amount or (RFS.AmountFood[class] or 0))

    if not isnumber(amount) then return end
    local curentAmount = self:RFSGetFood()

    self:RFSSetFood(curentAmount + amount)
end
