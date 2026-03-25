/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

--[[ Initialize Table and reload entities on startup ]]
hook.Add("InitPostEntity", "RFS:InitPostEntity", function()
    timer.Simple(5, function()
        RFS.InitializeTables()
        RFS.ReloadEntities()
    end)
end)

--[[ Cache entities and create function callback when removed ]]
hook.Add("OnEntityCreated", "RFS:OnEntityCreated:CacheTable", function(ent)
    local class = ent:GetClass()

    if class != "rfs_screen" && class != "rfs_terminal" then return end

    RFS.CacheEntities = RFS.CacheEntities or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46
    
    RFS.CacheEntities[class] = RFS.CacheEntities[class] or {}
    RFS.CacheEntities[class][ent] = true

    local entIndex = ent:EntIndex()
    ent:CallOnRemove("rfs_remove_cache:"..entIndex, function(ent) 
        RFS.CacheEntities[class][ent] = nil

        if class == "rfs_terminal" then
            for k, v in pairs(ent.RFS["orders"]) do
                local clientSteamID64 = v.clientSteamID64
                if not isstring(clientSteamID64) then continue end
                
                RFS.OrdersCount = RFS.OrdersCount or {}
                RFS.OrdersCount[clientSteamID64] = math.Clamp((RFS.OrdersCount[clientSteamID64] or 0) - 1, 0, RFS.MaxOrder)
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

            ent.RFS["linkedScreens"] = {}
        elseif class == "rfs_screen" then
            ent.RFS["linkedTerminals"] = {}
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

        net.Start("RFS:MainNet")
            net.WriteUInt(5, 5)
            net.WriteUInt(entIndex, 16)
        net.Broadcast()
    end)
end)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

--[[ Just save the old weapon class to restore it when I remove the swep to the player ]]
hook.Add("PlayerSwitchWeapon", "RFS:PlayerSwitchWeapon:FallBack", function(ply, oldWeapon, newWeapon)
    if not string.StartWith(newWeapon:GetClass(), "rfs_") then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

    ply.RFS = ply.RFS or {}
    ply.RFS["oldWeapon"] = oldWeapon:GetClass()
end)

--[[ Reload entities when the server cleanup ]]
hook.Add("PostCleanupMap", "RFS:PostCleanupMap", function()
    RFS.ReloadEntities()
end)

--[[ Add compatibility with DarkRP ]]
hook.Add("playerBoughtCustomEntity", "RFS:OnEntityBuyed", function(ply, entTable, ent)
    if not string.StartWith(ent:GetClass(), "rfs_") then return end
    RFS.SetOwner(ent, ply)
end)

--[[ Disable drop on DarkRP ]]
hook.Add("canDropWeapon", "RFS:canDropWeapon", function(ply, wep)
    if not IsValid(wep) then return end

    if wep:GetClass():find("rfs_") then return false end
end)
