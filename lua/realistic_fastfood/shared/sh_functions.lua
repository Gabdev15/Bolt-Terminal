/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

--[[ Make sure sentence exist and also langage exist]]
function RFS.GetSentence(key)
    local result = "Lang Problem"
    local lang = RFS.Lang

    if istable(RFS.Language) && RFS.Language[lang] && RFS.Language[lang][key] then
        result = RFS.Language[lang][key]
    elseif istable(RFS.Language) && RFS.Language["en"] && RFS.Language["en"][key] then
        result = RFS.Language["en"][key]
    end

    return result
end

--[[ Convert a number to a format number ]]
function RFS.formatMoney(money)
    if not isnumber(tonumber(money)) then return 0 end
    money = string.Comma(money)

    return isfunction(RFS.Currencies[RFS.Currency]) and RFS.Currencies[RFS.Currency](money) or money
end

--[[ Get owner ]]
function RFS.GetOwner(ent)
    local owner = RFS.GetNWVariables("owner", ent)

    if IsValid(owner) then
        return owner
    else
        if isfunction(ent.CPPIGetOwner) then
            return ent:CPPIGetOwner()
        else
            return ent:GetOwner()
        end
    end
end

local PLAYER = FindMetaTable("Player")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

--[[ This function permite to add compatibility with other gamemode ]]
function PLAYER:RFSGetMoney()
    if DarkRP then
        return tonumber(self:getDarkRPVar("money") or "0")
    elseif ix then
        return tonumber(self:GetCharacter() != nil and self:GetCharacter():GetMoney() or "0")
    elseif nut then
        return tonumber(self:getChar() != nil and self:getChar():getMoney() or "0")
    end

    return 0
end

--[[ Check if an entity class is near the player ]]
function PLAYER:RFSCheckNearClassEntity(class, dist)
    for k,v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
        if not IsValid(v) or v:GetClass() != class then continue end

        return true
    end
end

--[[ Check if an entity is near the player ]]
function PLAYER:RFSCheckNearEntity(ent, class, dist)
    for k,v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
        if not IsValid(v) then continue end
        if v != ent or v:GetClass() != class then continue end

        return true
    end
end

--[[ Get networked variables ]]
function RFS.GetNWVariables(key, ent)
    return (IsValid(ent) and (ent.RFSNWVariables or {}) or (RFS.NWVariables or {}))[key]
end

--[[ Count all cookers ]]
function RFS.CountCooker()
    local count = 0
    for k, v in ipairs(player.GetAll()) do
        if not RFS.FastFoodJob[team.GetName(v:Team())] then continue end

        local service = RFS.GetNWVariables("rfs_service", v)
        if not service && RFS.ServiceSystem then continue end

        count = count + 1
    end

    return count
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

--[[ Count all jobs for distributor ]]
function RFS.CountCookerDistributor()
    local count = 0
    for k, v in ipairs(player.GetAll()) do
        if not RFS.FastFoodJobDistributor or not RFS.FastFoodJobDistributor[team.GetName(v:Team())] then continue end

        local service = RFS.GetNWVariables("rfs_service", v)
        if not service && RFS.ServiceSystem then continue end

        count = count + 1
    end

    return count
end

local PLAYER = FindMetaTable("Player") 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

function PLAYER:RFSGetFood()
    local amount = 0
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

    if not RFS.GiveHealth then
        if DarkRP then
            amount = (self:getDarkRPVar("Energy") or 0)         
        end
    else
        amount = self:Health()
    end

    return amount
end

hook.Add("PlayerSwitchWeapon", "RFS:PlayerSwitchWeapon:Swep", function(ply, oldWep, newWep)
    local wepIndex = oldWep:EntIndex()
    if timer.Exists("rfs_eat_swep:"..wepIndex) then return true end
end)
