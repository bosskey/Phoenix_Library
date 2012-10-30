include('shared.lua')
function SWEP:Initialize()
	--[[local fx = EffectData()
	fx:SetEntity(self)
	util.Effect("weapon_viewmodel",fx,true,true)]]
	--[[self.Weapon2 = ClientsideModel(self.ViewModel or "models/weapons/v_pistol.mdl",RENDERGROUP_OPAQUE)
	self.Weapon2.AutomaticFrameAdvance = false
	self.Weapon2:SetNoDraw(true)]]
end
SWEP.LastThink = SysTime()
SWEP.SinglePlayerDeployed = false
function SWEP:ViewModelDrawn()
	--[[if self.Weapon:GetSequence() == 9 and self.Weapon:DefaultReload(ACT_VM_RELOAD) then
		return
	end
	local myAng, myPos = EyeAngles(), EyePos()]]
	--self.Weapon2:SetNoDraw(false)
	--[[local vm = self.Owner:GetViewModel(1)
	local angDiff = myAng:Difference(vm:GetAngles())
	local posDiff = vm:GetPos() - myPos]]
	--[[self.Weapon2:SetAngles(myAng - Angle(angDiff.p,-1*angDiff.y,0))
	self.Weapon2:SetPos(myPos - posDiff)
	self.Weapon2:DrawModel()
	self.Weapon2:SetNoDraw(true)]]
end

function SWEP:GetViewModelPosition(pos,ang)
	return pos, ang
end

function SWEP:CanSecondaryAttack() return false end

function SWEP:GetTracerOrigin() --doesn't call in singleplayer due to cl_predict being off
	if self.Alternate and LocalPlayer():GetViewModel():IsValid() and LocalPlayer():GetViewModel():GetAttachment(1) then
		return self.Weapon:GetPos() + (self.Weapon:GetRight()*-1):DotProduct(LocalPlayer():GetViewModel():GetAttachment(1).Pos - self.Weapon:GetPos())*self.Weapon:GetRight()*2 + (LocalPlayer():GetViewModel():GetAttachment(1).Pos - self.Weapon:GetPos())
	end
end
