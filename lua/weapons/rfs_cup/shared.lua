/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/


AddCSLuaFile()

SWEP.PrintName = "Cup"
SWEP.Category = "Realistic Fastfood"
SWEP.Author = "Kobralost & Jimmy"
SWEP.Purpose = ""

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/rfs_view_cup.mdl"
SWEP.WorldModel = "models/weapons/rfs_world_cup.mdl"
SWEP.ViewModelFOV = 47
SWEP.DrawAmmo = false
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f

SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

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
	local entIndex = self:EntIndex()
	if timer.Exists("rfs_eat_swep:"..entIndex) then return end

	local viewModel = self.Owner:GetViewModel()
	if not IsValid(viewModel) then return end

	local sequence = viewModel:LookupSequence("drink")
	if not isnumber(sequence) then return end

	if CLIENT then
		local fluidColor = RFS.GetNWVariables("rfs_soda_color", self.Owner) or RFS.Colors["white"]

		local vectorColor = Vector(fluidColor.r, fluidColor.g, fluidColor.b, fluidColor.a)
		vectorColor:Normalize()

		viewModel.fluidcolor = vectorColor
	else
		timer.Simple(0.25, function()
			if not IsValid(self) then return end

			if not IsValid(self.soundCup) && not RFS.DisableSoundWhenEating then
				self.soundCup = CreateSound(self.Owner, RFS.Sounds["drinkSound"])
				self.soundCup:Play()		
			end
		end)
	end

	timer.Create("rfs_eat_swep:"..entIndex, self:SequenceDuration(sequence), 1, function()
		if CLIENT then return end

		local wep = self.Owner:GetWeapon("rfs_cup")
		if IsValid(wep) then
			self.Owner:RFSEatSomething(self)
			self.Owner:StripWeapon("rfs_cup")
		end
	end)

	viewModel:SendViewModelMatchingSequence(sequence)
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

		local sodaCup = ents.Create("rfs_sodacup")
		sodaCup:SetPos(trace.HitPos)
		sodaCup:Spawn()
		sodaCup:Activate()
		sodaCup:SetBodygroup(1, 4)
		
		local phys = sodaCup:GetPhysicsObject()

		local fluidColor = RFS.GetNWVariables("rfs_soda_color", self.Owner) or RFS.Colors["white"]
		RFS.SetNWVariable("rfs_soda_color", fluidColor, sodaCup, true, nil, true)

		sodaCup:SetColor(fluidColor)

		if IsValid(phys) then
			phys:EnableMotion(true)
		end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

		if self.Owner.RFS && isstring(self.Owner.RFS["oldWeapon"]) then
			self.Owner:SelectWeapon(self.Owner.RFS["oldWeapon"])
		end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

	draw.DrawText(RFS.GetSentence("leftClick"), "RFS:Font:04", RFS.ScrW*0.95, RFS.ScrH*0.45, RFS.Colors["orange2"], TEXT_ALIGN_RIGHT)
	draw.DrawText(RFS.GetSentence("descLeftSwep"), "RFS:Font:05", RFS.ScrW*0.95, RFS.ScrH*0.483, RFS.Colors["white246200"], TEXT_ALIGN_RIGHT)

	surface.SetDrawColor(RFS.Colors["black25200"])
	surface.SetMaterial(RFS.Materials["rightMouse"])
	surface.DrawTexturedRect(RFS.ScrW*0.95, RFS.ScrH*0.55, 40, 40)

	draw.DrawText(RFS.GetSentence("rightClick"), "RFS:Font:04", RFS.ScrW*0.95, RFS.ScrH*0.55, RFS.Colors["orange2"], TEXT_ALIGN_RIGHT)
	draw.DrawText(RFS.GetSentence("descRightSwep"), "RFS:Font:05", RFS.ScrW*0.95, RFS.ScrH*0.583, RFS.Colors["white246200"], TEXT_ALIGN_RIGHT)
end
