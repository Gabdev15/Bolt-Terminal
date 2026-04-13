/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

--[[ Initialize Table and reload entities on startup ]]
hook.Add("InitPostEntity", "BT:InitPostEntity", function()
    timer.Simple(5, function()
        BT.InitializeTables()
        BT.ReloadEntities()
    end)
end)

--[[ Cache entities and create function callback when removed ]]
hook.Add("OnEntityCreated", "BT:OnEntityCreated:CacheTable", function(ent)
    local class = ent:GetClass()

    if class != "bt_screen" && class != "bolt_terminal" then return end

    BT.CacheEntities = BT.CacheEntities or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46
    
    BT.CacheEntities[class] = BT.CacheEntities[class] or {}
    BT.CacheEntities[class][ent] = true

    local entIndex = ent:EntIndex()
    ent:CallOnRemove("bt_remove_cache:"..entIndex, function(ent) 
        BT.CacheEntities[class][ent] = nil

        if class == "bolt_terminal" then
            for k, v in pairs(ent.BT["orders"]) do
                local clientSteamID64 = v.clientSteamID64
                if not isstring(clientSteamID64) then continue end
                
                BT.OrdersCount = BT.OrdersCount or {}
                BT.OrdersCount[clientSteamID64] = math.max((BT.OrdersCount[clientSteamID64] or 0) - 1, 0)
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

            ent.BT["linkedScreens"] = {}
        elseif class == "bt_screen" then
            ent.BT["linkedTerminals"] = {}
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

        net.Start("BT:MainNet")
            net.WriteUInt(5, 5)
            net.WriteUInt(entIndex, 16)
        net.Broadcast()
    end)
end)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

--[[ Just save the old weapon class to restore it when I remove the swep to the player ]]
hook.Add("PlayerSwitchWeapon", "BT:PlayerSwitchWeapon:FallBack", function(ply, oldWeapon, newWeapon)
    if not string.StartWith(newWeapon:GetClass(), "bt_") then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

    ply.BT = ply.BT or {}
    ply.BT["oldWeapon"] = oldWeapon:GetClass()
end)

--[[ Reload entities when the server cleanup ]]
hook.Add("PostCleanupMap", "BT:PostCleanupMap", function()
    BT.ReloadEntities()
end)

--[[ Add compatibility with DarkRP ]]
hook.Add("playerBoughtCustomEntity", "BT:OnEntityBuyed", function(ply, entTable, ent)
    if not string.StartWith(ent:GetClass(), "bt_") then return end
    BT.SetOwner(ent, ply)
end)

--[[ Disable drop on DarkRP ]]
hook.Add("canDropWeapon", "BT:canDropWeapon", function(ply, wep)
    if not IsValid(wep) then return end

    if wep:GetClass():find("bt_") then return false end
end)
