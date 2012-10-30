
function OBJ:Setup(objNW,tblSetup) --Runs before Initialize, BUT DON'T USE IT FOR ANYTHING BUT SETTING UP objNW data
	self.Origin = tblSetup.StartPos
	objNW:SetVectorA(tblSetup.StartPos)
	
	self.Entity:SetAngles(tblSetup.Angle)
	objNW:SetAngle(tblSetup.Angle)
	
	self.Filter = {tblSetup.Shooter}
	objNW:SetEntityA(tblSetup.Shooter)
end

function OBJ:Initialize()
	self.Entity:SetPos(self.Origin)
	self:CalcTrajectory()
end

function OBJ:Think()
	self.LastThink = self.LastThink or self.StartTime
	local vecNewPos = self:CalcMovePos(self.LastThink)
	local bDie, bGib, vecEndPos = self:DoMove(vecNewPos)
	self.Entity:SetPos(vecEndPos)
	self.LastThink = CurTime()
	if bDie then
		return false
	end
	return true
end
