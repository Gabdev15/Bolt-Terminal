/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46

AddCSLuaFile()

SWEP.PrintName = "Hand"
SWEP.Category = "Realistic Fastfood"
SWEP.Author = "Kobralost & Jimmy"
SWEP.Purpose = ""

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = false
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 47
SWEP.DrawAmmo = false

SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize() end
function SWEP:CanPrimaryAttack() end
function SWEP:CanSecondaryAttack() end

function SWEP:DrawWorldModel() end
function SWEP:PreDrawViewModel() return true end

function SWEP:Deploy()
	self:SetNoDraw(true)
	self:SetHoldType("normal")
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

function SWEP:Holster()
	if not SERVER then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

	local owner = self:GetOwner()
	owner:RFSRemoveHand()
end

function SWEP:SecondaryAttack()
	if not SERVER then return end

	local owner = self:GetOwner()
	owner:RFSRemoveHand()
	owner.RFS["boxSelected"] = nil
end

function SWEP:DrawHUD()
	surface.SetDrawColor(RFS.Colors["black25200"])
	surface.SetMaterial(RFS.Materials["leftMouse"])
	surface.DrawTexturedRect(RFS.ScrW*0.95, RFS.ScrH*0.45, 40, 40)

	draw.DrawText(RFS.GetSentence("leftClick"), "RFS:Font:04", RFS.ScrW*0.95, RFS.ScrH*0.45, RFS.Colors["orange2"], TEXT_ALIGN_RIGHT)
	draw.DrawText(RFS.GetSentence("descLeftClick"), "RFS:Font:05", RFS.ScrW*0.95, RFS.ScrH*0.483, RFS.Colors["white246200"], TEXT_ALIGN_RIGHT)

	surface.SetDrawColor(RFS.Colors["black25200"])
	surface.SetMaterial(RFS.Materials["rightMouse"])
	surface.DrawTexturedRect(RFS.ScrW*0.95, RFS.ScrH*0.55, 40, 40)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

	draw.DrawText(RFS.GetSentence("rightClick"), "RFS:Font:04", RFS.ScrW*0.95, RFS.ScrH*0.55, RFS.Colors["orange2"], TEXT_ALIGN_RIGHT)
	draw.DrawText(RFS.GetSentence("descRightClick"), "RFS:Font:05", RFS.ScrW*0.95, RFS.ScrH*0.583, RFS.Colors["white246200"], TEXT_ALIGN_RIGHT)
end
