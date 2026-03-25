/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

function ENT:Draw()
    self:DrawModel()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

    if RFS.GetNWVariables("rfs_fry_starting", self) then
        local pos = self:GetPos() + self:GetUp() * 10 + Vector(VectorRand().x, VectorRand().y, VectorRand().z)*5
            
        if not self.particle then
            self.particle = ParticleEmitter(pos)
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
        
        if self.particle then
            local particle = self.particle:Add("particle/smokesprites_0016", pos) 
            particle:SetColor(255, 187, 0) 
            particle:SetVelocity(Vector(VectorRand().x, VectorRand().y, VectorRand().z) * 1)
            particle:SetGravity(RFS.Constants["vector100"])
            particle:SetDieTime(0.5)           
            particle:SetLifeTime(0)
            particle:SetStartAlpha(70)
            particle:SetEndAlpha(0)
            particle:SetStartSize(2)
            particle:SetEndSize(5)
        end
    end
end
