local meta = FindMetaTable("Vector")

meta.__lt = function (self,var)
	if type(var) == "Vector" then
		return self.x < var.x and self.y < var.y and self.z < var.z
	end
end

meta.__le = function (self,var)
	if type(var) == "Vector" then
		return self.x <= var.x and self.y <= var.y and self.z <= var.z
	end
end

function meta:GetNoZ()
	return Vector(self.x,self.y,0)
end

function meta:NoZ()
	self.z = 0
end

function meta:GetFlipZ()
	return Vector(self.x,self.y,-1*self.z)
end

function meta:FlipZ()
	self.z = -1*self.z
end

function meta:Difference(norm)
	return norm - self
end

function meta:Clamp(min,max)
	if IsVector(min) then
		min = min:Angle()
	end
	if not max then
		max = min
		min = -min
	elseif IsVector(max) then
		max = max:Angle()
	end
	self = ((self:Angle()):GetClamped(min,max)):Forward()
end

function meta:GetClamped(min,max)
	if IsVector(min) then
		min = min:Angle()
	end
	if not max then
		max = min
		min = -1*min
	elseif IsVector(max) then
		max = max:Angle()
	end
	return (((self:Angle())):GetClamped(min,max)):Forward()
end

function meta:Difference(vec)
	return math.deg(math.acos(self:DotProduct(vec))/(self:Length()*vec:Length()))
end

function meta:AddAngle(ang)
	return ((self:Angle()):GetNormalized() + ang:GetNormalized()):GetNormalized():Forward()
end

--This is meant for clamping max angle difference between these two normals.
function meta:GetAddClamped(norm,min,max)
	if IsVector(min) then
		min = min:Angle()
	end
	if not max then
		max = min
		min = -1*min
	elseif IsVector(max) then
		max = max:Angle()
	end
	local diff = (self:Angle()):Difference(norm:Angle())
	return (self:Angle() + diff:GetClamped(min,max)):Forward()
end

-- vecOrigin:GetAxisIntersect(vecAxis,vecPos) --pos is the most dynamic part, it is the determinant, return position along direction that vecPos intersects perpendicularly and the angle from pos to vecPos
function meta:GetAxisIntersect(vecDir,vecPos)
	if vecDir:Length() > 1 then vecDir:Normalize() end
	local pos = vecDir:DotProduct(vecPos - self)*vecDir
	return pos, (((vecPos - pos):GetNormal()):Angle()):GetNormal()
end

function meta:__unpack()
	return self.x, self.y, self.z
end

function meta:SetX(num)
	self.x = num
end

function meta:SetY(num)
	self.y = num
end

function meta:SetZ(num)
	self.z = num
end

function meta:AddX(num)
	self.x = self.x + num
end

function meta:AddY(num)
	self.y = self.y + num
end

function meta:AddZ(num)
	self.z = self.z + num
end

function meta:SubX(num)
	self.x = self.x - num
end

function meta:SubY(num)
	self.y = self.y - num
end

function meta:SubZ(num)
	self.z = self.z - num
end

function meta:MulX(num)
	self.x = self.x*num
end

function meta:MulY(num)
	self.y = self.y*num
end

function meta:MulZ(num)
	self.z = self.z*num
end

function meta:DivX(num)
	self.x = self.x/num
end

function meta:DivY(num)
	self.y = self.y/num
end

function meta:DivZ(num)
	self.z = self.z/num
end

function meta:EqualX(num)
	return self.x == num
end

function meta:EqualY(num)
	return self.y == num
end

function meta:EqualZ(num)
	return self.z == num
end

function meta:InBox(vecMin,vecMax)
	return math.InBounds(vecPos.x,vecMin.x,vecMax.x) and math.InBounds(vecPos.y,vecMin.y,vecMax.y) and math.InBounds(vecPos.z,vecMin.z,vecMax.z)
end

function meta:InSphere(vecCenter,numRadius)
	return self:Distance(vecCenter) <= numRadius
end

