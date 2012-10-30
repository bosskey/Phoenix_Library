
function OBJ:Setup(tblSetup) --Runs before Initialize, BUT DON'T USE IT FOR ANYTHING BUT SETTING UP objNW data
	self.Origin = tblSetup.StartPos
	umsg.Vector(tblSetup.StartPos)
	tblSetup.Angle.p = math.Round(tblSetup.Angle.p)
	tblSetup.Angle.y = math.Round(tblSetup.Angle.y)
	tblSetup.Angle.r = 0
	self.Entity:SetAngles(tblSetup.Angle)
	umsg.Angle(tblSetup.Angle)
	
	self.Speed = math.Round(tblSetup.Speed)
	umsg.Long(self.Speed) --we send the vel at fps so the variable is small
	
	self.StartTime = math.Round(CurTime())
	umsg.Long(self.StartTime)
	
	self.Filter = {}
	umsg.Entity(tblSetup.Shooter)
	self.Shooter = tblSetup.Shooter
end

function OBJ:Initialize()
	self.Entity:SetPos(self.Origin)
	self:SetVelocity(self.Entity:GetAngles():Forward()*self.Speed*16)
	self.traceData = {filter = self.Filter,mask=MASK_SHOT}
	self.RicochetCount = 0
end
umsg.PoolString("NWBulletPos")
OBJ.FRAMECOUNT = 0
function OBJ:Think()
	if self.Config.FrameSkip > 0 then
		if self.Config.FrameSkip > self.FRAMECOUNT then
			self.FRAMECOUNT = self.FRAMECOUNT + 1
			return true
		end
		self.FRAMECOUNT = 0
	end
	self.LastThink = self.LastThink or self.StartTime
	local vecNewPos, fDelta = self:CalcMovePos(self.LastThink)
	local bDie, vecEndPos, numAction, tr = self:DoMove(vecNewPos,fDelta)
	self.Entity:SetPos(vecEndPos)
	umsg.Start("NWBulletPos",0)
		umsg.Short(self.Index)
		umsg.Vector(vecEndPos)
	umsg.End()
	self.LastThink = CurTime()
	if numAction == BULLET_HITNOTHING then --most likely, thus first to check and break out of elseif block
		
	elseif numAction == BULLET_HITPROP then
		local objPhys = tr.Entity:GetPhysicsObject()
		if objPhys then
			objPhys:ApplyForceOffset(tr.HitPos,self:GetVelocity()*objPhys:GetMass()/50)
		else
			tr.Entity:SetVelocity(tr.Entity:GetVelocity() + self:GetVelocity()*(tr.Entity:OBBMins():Distance(tr.Entity:OBBMaxs())))
		end
	elseif numAction == BULLET_HITLIVING then
		tr.Entity:TakeDamage(12,self.Shooter,self.Shooter)
	elseif numAction == BULLET_HITSKY then
		return false
	elseif numAction == BULLET_HITWORLD then
		
	elseif numAction == BULLET_PENETRATEWORLD then
		
	elseif numAction == BULLET_DIGIN then
	
	elseif numAction == BULLET_PENETRATEWORLD_EXIT then
	
	elseif numAction == BULLET_PENETRATEWORLD_ACTIVE then
		
	end
	return !bDie
end
