/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

AddCSLuaFile()

SWEP.PrintName = "Burger"
SWEP.Category = "Realistic Fastfood"
SWEP.Author = "Kobralost & Jimmy"
SWEP.Purpose = ""

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/rfs_burger_hand.mdl"
SWEP.WorldModel = "models/weapons/rfs_world_burger_hand.mdl"
SWEP.ViewModelFOV = 47
SWEP.DrawAmmo = false

SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize() 
	self:SetHoldType("slam")
end

function SWEP:CanPrimaryAttack() end
function SWEP:CanSecondaryAttack() end

function SWEP:PrimaryAttack()
	if timer.Exists("rfs_eat_swep:"..self:EntIndex()) then return end
	
	local viewModel = self.Owner:GetViewModel()
	if not IsValid(viewModel) then return end

	local sequence = viewModel:LookupSequence("eating_burger")
	if not isnumber(sequence) then return end

	viewModel:SendViewModelMatchingSequence(sequence)

	if SERVER then
		timer.Simple(0.25, function()
			if not IsValid(self) then return end

			if not IsValid(self.soundBurger) && not RFS.DisableSoundWhenEating then
				self.soundBurger = CreateSound(self.Owner, RFS.Sounds["eatSound"])
				self.soundBurger:Play()		
			end
		end)
	end
	
	timer.Create("rfs_eat_swep:"..self:EntIndex(), 1.5, 1, function()
		if CLIENT then return end

		self.RFS = self.RFS or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

		local wep = self.Owner:GetWeapon("rfs_hand_burger")
		if IsValid(wep) then
			self.Owner:RFSEatSomething(self, (self.RFS["amountFood"] or 0))
			self.Owner:StripWeapon("rfs_hand_burger")
		end
	end)
end

function SWEP:SecondaryAttack()
	if SERVER then
		if timer.Exists("rfs_eat_swep:"..self:EntIndex()) then return end

		local curTime = CurTime()

		self.Owner.spamSwep = self.Owner.spamSwep or 0
		if self.Owner.spamSwep > curTime then return end
		self.Owner.spamSwep = curTime + 1

        local trace = util.TraceLine({
            start = self.Owner:EyePos(),
            endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 100,
            filter = function(ent) if ent:GetClass() != "player" then return true end end
        })

		self.RFS = self.RFS or {}
		local burger = RFS.Cooking.CreateBurger(nil, nil, trace.HitPos, Angle(0, 0, 0), true, nil, self.RFS["condiments"] or RFS.BaseBurger)

		burger.RFS = burger.RFS or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

		burger.RFS["condiments"] = self.RFS["condiments"] or RFS.BaseBurger
		burger.RFS["amountFood"] = self.RFS["amountFood"] or 100
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

		local phys = burger:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(true)
		end
		
		if self.Owner.RFS && isstring(self.Owner.RFS["oldWeapon"]) then
			self.Owner:SelectWeapon(self.Owner.RFS["oldWeapon"])
		end

		local class = self:GetClass()
		local wep = self.Owner:GetWeapon(class)

		if IsValid(wep) then
			self.Owner:StripWeapon(class)
		end
	end
end

function SWEP:DrawHUD()
	surface.SetDrawColor(RFS.Colors["black25200"])
	surface.SetMaterial(RFS.Materials["leftMouse"])
	surface.DrawTexturedRect(RFS.ScrW*0.95, RFS.ScrH*0.45, 40, 40)

	draw.DrawText(RFS.GetSentence("leftClick"), "RFS:Font:04", RFS.ScrW*0.95, RFS.ScrH*0.45, RFS.Colors["orange2"], TEXT_ALIGN_RIGHT)
	draw.DrawText(RFS.GetSentence("descLeftSwep"), "RFS:Font:05", RFS.ScrW*0.95, RFS.ScrH*0.483, RFS.Colors["white246200"], TEXT_ALIGN_RIGHT)

	surface.SetDrawColor(RFS.Colors["black25200"])
	surface.SetMaterial(RFS.Materials["rightMouse"])
	surface.DrawTexturedRect(RFS.ScrW*0.95, RFS.ScrH*0.55, 40, 40)

	draw.DrawText(RFS.GetSentence("rightClick"), "RFS:Font:04", RFS.ScrW*0.95, RFS.ScrH*0.55, RFS.Colors["orange2"], TEXT_ALIGN_RIGHT)
	draw.DrawText(RFS.GetSentence("descRightSwep"), "RFS:Font:05", RFS.ScrW*0.95, RFS.ScrH*0.583, RFS.Colors["white246200"], TEXT_ALIGN_RIGHT)
end
