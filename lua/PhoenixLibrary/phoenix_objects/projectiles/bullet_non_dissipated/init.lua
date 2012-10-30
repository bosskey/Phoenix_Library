
function OBJ:Setup(tblSetup) --Runs before Initialize, BUT DON'T USE IT FOR ANYTHING BUT SETTING UP objNW data
	self.Origin = tblSetup.StartPos
	umsg.Vector(tblSetup.StartPos)
	tblSetup.Angle.p = tblSetup.Angle.p
	tblSetup.Angle.y = tblSetup.Angle.y
	tblSetup.Angle.r = 0
	self.Entity:SetAngles(tblSetup.Angle)
	umsg.Angle(tblSetup.Angle)
	
	self.Speed = math.Round(tblSetup.Speed)
	umsg.Long(self.Speed) --we send the vel at fps so the variable is small
	
	self.StartTime = CurTime()
	umsg.Float(self.StartTime)
	
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

function OBJ:Think()
return false
end
