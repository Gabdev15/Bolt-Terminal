/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

ITEM.Name = "Bag"
ITEM.Description = "A bag of food."
ITEM.Model = "models/realistic_food_system/paper_bag.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:SaveData(ent)
	ent.RFS = ent.RFS or {}
	self:SetData("bagInventory", (ent.RFS["inventories"] or {}))
end

function ITEM:LoadData(ent)
	local dataInventory = self:GetData("bagInventory")

	ent.RFS = ent.RFS or {}
	ent.RFS["inventories"] = dataInventory or {}
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

function ITEM:CanMerge(item)
	return false
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

function ITEM:Drop(ply, con, slot, ent)

end

function ITEM:GetName()
	return RFS.GetSentence("bag")
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
