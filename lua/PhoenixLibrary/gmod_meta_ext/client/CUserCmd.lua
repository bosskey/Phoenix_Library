local meta = FindMetaTable("CUserCmd")

function meta:GetForwardVelocity()
	local dir = self:GetViewAngles()
	dir.p = 0
	dir = dir:Forward()
	return dir*self:GetForwardMove()
end

function meta:GetSideVelocity()
	local dir = self:GetViewAngles()
	dir.p = 0
	dir = dir:Right()
	return dir*self:GetSideMove()
end