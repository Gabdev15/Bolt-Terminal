/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

function ENT:Draw()
    self:DrawModel()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

    local pos = self:GetPos() + self:GetUp() * 5 + Vector(VectorRand().x, VectorRand().y, VectorRand().z)*5
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2
        
    if not self.particle then
        self.particle = ParticleEmitter(pos)
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2
    
    if self.particle && IsValid(self:GetParent()) then
        local particle = self.particle:Add("particle/smokesprites_0016", pos)

        if self.RFS["carbonised"] then
            particle:SetColor(0, 0, 0) 
            particle:SetStartAlpha(50)
        else
            particle:SetColor(255, 255, 255)
            particle:SetStartAlpha(5)
        end

        particle:SetGravity(RFS.Constants["vector75"])
        particle:SetDieTime(0.5)           
        particle:SetLifeTime(0)
        particle:SetEndAlpha(0)
        particle:SetStartSize(3)
        particle:SetEndSize(2)
    end
end

function ENT:Initialize()
    self.RFS = self.RFS or {}
    self.RFS["pourcent"] = 0
end
