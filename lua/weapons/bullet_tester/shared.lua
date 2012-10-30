AddCSLuaFile("shared.lua")SWEP.Author			= ""SWEP.Contact		= ""SWEP.Purpose		= ""SWEP.Instructions	= ""SWEP.PrintName = "Bullet Tester"SWEP.Spawnable			= falseSWEP.AdminSpawnable		= trueSWEP.ViewModelFlip = trueSWEP.ViewModel			= "models/weapons/v_smg_p90.mdl"SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"SWEP.Primary.ClipSize		= -1SWEP.Primary.DefaultClip	= -1SWEP.Primary.Delay = .1SWEP.Primary.Damage = 20SWEP.Primary.Automatic		= trueSWEP.Primary.Ammo			= "smg1"SWEP.Primary.Sound = Sound("weapons/pistol/pistol_fire2.wav")SWEP.Secondary.ClipSize		= -1SWEP.Secondary.DefaultClip	= -1SWEP.Secondary.Automatic	= falseSWEP.Secondary.Ammo			= "none"SWEP.HoldType = "smg"function SWEP:Initialize()	projectiles.RegisterClass("base_bullet","lolwut",{FrameSkip=0,MaxRicochet = 8,RicochetAngleThreshold=45,Tracer = "effects/tracer_middle"})	if SERVER then		self:SetWeaponHoldType(self.HoldType)	endendfunction SWEP:CanPrimaryAttack()	return trueendfunction SWEP:PrimaryAttack()	self.Weapon:SetNextPrimaryFire(CurTime() + 1) 	self.Weapon:EmitSound(self.Primary.Sound) 	self:ShootBullet()	self:ShootEffects()	if SERVER then		self.Weapon:SetNWFloat("LastShootTime",CurTime()) --uhhhh	endendfunction SWEP:ShootEffects()	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)	--self.Owner:MuzzleFlash()	self.Owner:SetAnimation(PLAYER_ATTACK1)endlocal bulletData = {}function SWEP:ShootBullet( damage, num_bullets, aimcone )	bulletData.StartPos = self.Owner:GetShootPos()	bulletData.Speed = 1000 -- fps	bulletData.Shooter = self.Owner	bulletData.Angle = self.Owner:GetAimVector():Angle()	projectiles.Shoot("base_bullet","lolwut",bulletData)end