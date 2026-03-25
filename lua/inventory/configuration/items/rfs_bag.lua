/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/realistic_food_system/paper_bag.mdl")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	tbl["data"] = tbl["data"] or {}

	ent.RFS = ent.RFS or {}
	ent.RFS["inventories"] = tbl["data"]["bagInventory"] or {}
end)

function ITEM:GetData(ent)
	ent.RFS = ent.RFS or {}

	return {
		bagInventory = (ent.RFS["inventories"] or {}),
	}
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

function ITEM:GetName(item)
	return RFS.GetSentence("bag")
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46

function ITEM:GetDisplayName(item)
    return self:GetName(item)
end

local ang = Angle(0, 45, 0)
function ITEM:GetCameraModifiers(tbl)
    return {
        FOV = 30,
        X = 0,
        Y = 0,
        Z = 50,
        Angles = ang,
        Pos = vector_origin
    }
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

ITEM:Register("rfs_bag")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46
