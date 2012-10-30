local meta = FindMetaTable("Angle")

meta.__lt = function (self,var)
	if type(var) == "Angle" then
		return self.p < var.p and self.y < var.y and self.r < var.r
	end
end

meta.__le = function (self,var)
	if type(var) == "Angle" then
		return self.p <= var.p and self.y <= var.y and self.r <= var.r
	end
end

function meta:Normalize()
	self = Angle(math.NormalizeAngle(self.p),math.NormalizeAngle(self.y),math.NormalizeAngle(self.r))
end

function meta:GetNormalized()
	return Angle(math.NormalizeAngle(self.p),math.NormalizeAngle(self.y),math.NormalizeAngle(self.r))
end
meta.GetNormal = meta.GetNormalized

//FIX WITH CUBE ROOT AND CUBING NOT /3
function meta:Magnitude()
	return (math.abs(math.NormalizeAngle(self.p))^3 + math.abs(math.NormalizeAngle(self.y))^3 + math.abs(math.NormalizeAngle(self.r))^3)^(1/3)
end

function meta:Difference(ang)
	return Angle(math.AngleDifference(ang.p,self.p),math.AngleDifference(ang.y,self.y),math.AngleDifference(ang.r,self.r))
end

function meta:Invert()
	self = (self:Forward()*-1):Angle()
end

function meta:GetInverted()
	return (self:Forward()*-1):Angle()
end
meta.GetInv = meta.GetInverted

function meta:__unpack()
	return self.p, self.y, self.r
end

function meta:InAngleBounds(ang)
	return math.abs(self.p) < ang.p and math.abs(self.y) < ang.y and math.abs(self.r) < ang.r
end

function meta:Clamp(min,max)
	self.p = math.Clamp(math.NormalizeAngle(self.p),min.p,max.p)
	self.y = math.Clamp(math.NormalizeAngle(self.y),min.y,max.y)
	self.r = math.Clamp(math.NormalizeAngle(self.r),min.r,max.r)
end

function meta:AddNormalVector(norm)
	local ang = (norm:Angle()):GetNormalized()
	return (self + ang):GetNormalized()
end

function meta:GetClamped(min,max)
	if not max then
		max = min
		min = -1*min
	end
	return Angle(math.Clamp(self.p,min.p,max.p),math.Clamp(self.y,min.y,max.y),math.Clamp(self.r,min.r,max.r))
end

function meta:Abs()
	self.p = math.abs(self.p)
	self.y = math.abs(self.y)
	self.r = math.abs(self.r)
end

function meta:GetAbs()
	return Angle(math.abs(self.p),math.abs(self.y),math.abs(self.r))
end
