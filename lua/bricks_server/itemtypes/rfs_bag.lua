/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

local ITEM = BRICKS_SERVER.Func.CreateItemType("rfs_bag")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

ITEM.GetItemData = function(ent)
	if not IsValid(ent) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

	ent.RFS = ent.RFS or {}
	local itemData = {"rfs_bag", "models/realistic_food_system/paper_bag.mdl", (ent.RFS["inventories"] or {})}

	return itemData, 1
end

ITEM.OnSpawn = function(ply, pos, itemData, itemAmount)
	local ent = ents.Create("rfs_bag")
	if not IsValid(ent) then return end
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()

	ent.RFS = ent.RFS or {}
	ent.RFS["inventories"] = itemData[3] or {}
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

ITEM.GetInfo = function(itemData)
	return RFS.GetSentence("bag")
end

local ang = Angle(0, -45, 0)

ITEM.ModelDisplay = function(Panel, itemtable)
	if not Panel.Entity or not IsValid(Panel.Entity) then return end
	local mn, mx = Panel.Entity:GetRenderBounds()
	local size = 0

	size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
	size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
	size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

	Panel:SetFOV(20)
	Panel:SetCamPos(Vector(size, size * 3, size * 2))
	Panel:SetLookAt((mn + mx) * 0.5)
	Panel.Entity:SetAngles(ang)
end

ITEM.CanCombine = function(itemData1, itemData2) return false end
ITEM:Register()

if BRICKS_SERVER and BRICKS_SERVER.CONFIG and BRICKS_SERVER.CONFIG.INVENTORY and BRICKS_SERVER.CONFIG.INVENTORY.Whitelist then
	BRICKS_SERVER.CONFIG.INVENTORY.Whitelist["rfs_bag"] = {false, true}
end
