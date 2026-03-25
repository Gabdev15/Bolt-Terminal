/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

--[[ All action of buttons ]]
local buttons = {
    ["condiments"] = {
        ["func"] = function(ent, args)
            local key = args[1]
            local cookingTable = RFS.CookingElement[key]
            if not cookingTable then return end
    
            local clientSideTable = cookingTable["clientSideModel"]
            if not clientSideTable then return end
    
            if isfunction(clientSideTable["canInteract"]) then
                if not clientSideTable["canInteract"](ent) then
                    return
                end
            end
    
            net.Start("RFS:Cooking")
                net.WriteUInt(2, 5)
                net.WriteEntity(ent)
                net.WriteString(key)
            net.SendToServer()
        end,
    },
}

--[[ Init all variable of the terminal ]]
function ENT:Initialize()
    self.RFSInfo = self.RFSInfo or {
        ["use3D2D"] = true,
    }
end

local condiments = {
    "cuttedTomato",
    "salad",
    "cuttedOnion",
    "cheese",
    "steak",
}

function ENT:Draw()
    self:DrawModel()

    if not IsValid(RFS.LocalPlayer) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

    local distance = RFS.LocalPlayer:GetPos():DistToSqr(self:GetPos())
    if distance > 250000 then
        return 
    end

    if halo.RenderedEntity() == self then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

    local pos = self:GetPos() + self:GetUp() * 10.5 + self:GetForward()*24.5 + self:GetRight()*7
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Forward(), -8.5)
	ang:RotateAroundAxis(ang:Right(), 0)
	ang:RotateAroundAxis(ang:Up(), 180)
    
    RFS.Start3D2D(pos, ang, 0.05)
        for k, v in ipairs(condiments) do
            local bodygroup = self:GetBodygroup(k)
            local bodygroupCount = (self:GetBodygroupCount(k) - 1)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

            k = (k - 1)
            local posButtonX, posButtonY = 170*k + 30*k, 320
            
            local checkMouse = RFS.CheckMouse(self, 0, pos, ang, posButtonX, 0, 172, 300, 0.05, buttons["condiments"]["func"], {v})
            if checkMouse && not IsValid(RFSClientside) then
                draw.RoundedBox(0, posButtonX, 0, 172, 300, (bodygroup > 0 and RFS.Colors["green3"] or RFS.Colors["red5"]))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257
                
                draw.RoundedBox(4, posButtonX, 320, 180, 70, RFS.Colors["grey3"])

                draw.DrawText(RFS.GetSentence("stock"), "RFS:Font:3D2D:09", posButtonX + 180/2, 330, RFS.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.DrawText(bodygroup.."/"..bodygroupCount, "RFS:Font:3D2D:10", posButtonX + 180/2, 355, RFS.Colors["white100"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

        end
   RFS.End3D2D()
end
