
function OBJ:Setup(tblSetup)
	self.Origin = tblSetup.StartPos
	umsg.Vector(tblSetup.StartPos)
	
	self.Entity:SetAngles(tblSetup.Angle)
	umsg.Angle(tblSetup.Angle)
	
	self.Speed = tblSetup.Speed
	umsg.Float(tblSetup.Speed)
	
	self.StartTime = CurTime()
	umsg.Float(self.StartTime)
	
	self.Filter = {}
	umsg.Entity(tblSetup.Shooter)
	self.Shooter = tblSetup.Shooter
end

function OBJ:Initialize()
	self.Entity:SetPos(self.Origin)
	self:SetVelocity(self.Entity:GetAngles():Forward()*self.Speed)
	self.traceData = {filter=self.Filter,mask=MASK_SHOT}
end

function OBJ:Think()
	
end