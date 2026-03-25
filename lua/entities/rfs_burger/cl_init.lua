/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

function ENT:Draw()
    RFS.BurgerCreated = RFS.BurgerCreated or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
    
    local burgerTable = RFS.BurgerCreated[self:EntIndex()]
    if not istable(burgerTable) then return end
    
    for k, v in ipairs(burgerTable) do
        if not IsValid(v) or not isvector(v.localPos) then continue end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3
    
        v:SetPos(self:LocalToWorld(v.localPos))
        v:SetAngles(self:LocalToWorldAngles(RFS.Constants["angle090"]))
    end
end
