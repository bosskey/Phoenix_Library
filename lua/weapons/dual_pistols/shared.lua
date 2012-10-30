SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""
SWEP.PrintName = "Dual Pistols"
SWEP.Base = "weapon_base_animext"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.ViewModelFlip = false
SWEP.ViewModelFlip1 = true

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 128
SWEP.Primary.Cone = .01
SWEP.Primary.Delay = .1
SWEP.Primary.Damage = 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Tracer = 1
SWEP.Primary.Sound = Sound("weapons/pistol/pistol_fire2.wav")

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HoldType = "physgun"

function SWEP:CanPrimaryAttack() return true end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
 	self.Weapon:EmitSound(self.Primary.Sound)
 	self:ShootBullet( self.Primary.Damage, 1, self.Primary.Cone )
 	self:SetNextPrimaryFire(CurTime()+self.Primary.Delay)
	self:TakePrimaryAmmo(1)
	if CLIENT then
		self.Alternate = !self.Alternate
	end
end

function SWEP:ShootEffects()
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	if CLIENT then
		self.Owner:GetViewModel(1):SetAnimation(ACT_VM_PRIMARYATTACK)
		local fx = EffectData()
		fx:SetOrigin(self.Weapon:GetPos() + (self.Weapon:GetRight()*-1):DotProduct(LocalPlayer():GetViewModel():GetAttachment(1).Pos - self.Weapon:GetPos())*self.Weapon:GetRight()*2 + (LocalPlayer():GetViewModel():GetAttachment(1).Pos - self.Weapon:GetPos()))
		fx:SetAngle(self.Owner:GetViewModel(1):GetAngles())
		fx:SetEntity(self.Owner:GetViewModel(1))
		fx:SetSurfaceProp(self.Owner:GetViewModel(1))
		util.Effect("MuzzleEffect",fx,true,true)
	end
	self.Owner:MuzzleFlash()
 	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

local bullet={}
local aimconespread = Vector(0,0,0)
function SWEP:ShootBullet( damage, num_bullets, aimcone )
	bullet.Num=num_bullets
	bullet.Src=self.Owner:GetShootPos()
	bullet.Dir=self.Owner:GetAimVector()
	aimconespread.x = aimcone
	aimconespread.y = aimcone
	bullet.Spread=aimconespread
	bullet.Tracer=1
	bullet.Force=5
	bullet.Damage=damage
	bullet.AmmoType="Pistol"
	self.Owner:FireBullets(bullet)
	self:ShootEffects()
end

function SWEP:Deploy()
		self.Owner:GetViewModel(1):SetNoDraw(false)
		self.Owner:GetViewModel(1):RemoveEffects(EF_NODRAW)
		self.Owner:GetViewModel(1):SetWeaponModel(self.ViewModel,self)
		print('deploy')
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if CLIENT then
		
		--self.Owner:GetViewModel(1).AutomaticFrameAdvance = false

	end

return true end

function SWEP:Holster()
	if CLIENT then
		if SinglePlayer() then
			self.SinglePlayerDeployed = false
			print('sp deploy false')
		end
		self.Owner:GetViewModel(1):SetNoDraw(true)
		print('holstered')
	end
return true end

function SWEP:Think()
	if self.Owner:GetViewModel(0):GetSequence()!=self.Owner:GetViewModel(1):GetSequence() then
		self.Owner:GetViewModel(1):SetSequence(self.Owner:GetViewModel(0):GetSequence())
	end
	if CLIENT then
		if SinglePlayer() then
			if not self.SinglePlayerDeployed then
				print('manual deploy')
				self:Deploy()
				self.SinglePlayerDeployed = true
			end
		end
		self.Weapon:NextThink(CurTime())
	end
	return true
end