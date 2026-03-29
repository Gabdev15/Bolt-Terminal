/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

--[[ Make sure sentence exist and also langage exist]]
function BT.GetSentence(key)
    local result = "Lang Problem"
    local lang = BT.Lang

    if istable(BT.Language) && BT.Language[lang] && BT.Language[lang][key] then
        result = BT.Language[lang][key]
    elseif istable(BT.Language) && BT.Language["en"] && BT.Language["en"][key] then
        result = BT.Language["en"][key]
    end

    return result
end

--[[ Convert a number to a format number ]]
function BT.formatMoney(money)
    if not isnumber(tonumber(money)) then return 0 end
    money = string.Comma(money)

    return isfunction(BT.Currencies[BT.Currency]) and BT.Currencies[BT.Currency](money) or money
end

--[[ Get owner ]]
function BT.GetOwner(ent)
    local owner = BT.GetNWVariables("owner", ent)

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

    return self.RFSSandboxMoney or 0
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
function BT.GetNWVariables(key, ent)
    return (IsValid(ent) and (ent.RFSNWVariables or {}) or (BT.NWVariables or {}))[key]
end

