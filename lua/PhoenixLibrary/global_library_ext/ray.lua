
local RAY = {MetaName="Ray"}
RAY.__index = RAY

function Ray(vecOrigin,vecDir)
	if type(vecOrigin) == 'Vector' and type(vecDir) == 'Vector' then
		local objNew = {Origin=vecOrigin,Normal=vecDir,MetaName="Ray"}
		setmetatable(objNew,RAY)
		return objNew
	end
end

AccessorFuncForce(RAY,"Origin","Origin",'Vector')
AccessorFuncForce(RAY,"Normal","Normal",'Vector')

function RAY:GetPoint(numDist)
	if type(numDist) == 'number' then
		return self.Origin + self.Normal*numDist
	end
end

function RAY:__tostring()
	return tostring(self.Origin).." & "..tostring(self.Normal)
end

function RAY:__add(obj)
	if IsVector(obj) then
		return Ray(self.Origin + obj,self.Normal)
	end
	error("cannot add a(n) "..type(obj).." to a ray",2)
end

function RAY:__sub(obj)
	if IsVector(obj) then
		return Ray(self.Origin - obj,self.Normal)
	end
	error("cannot subtract a(n) "..type(obj).." from a ray",2)
end

function RAY:__lt(obj)
	if type(obj) == "Ray" then
		return self.Normal:Length() < obj:GetNormal():Length()
	end
	return false
end

function RAY:__le(obj)
	if type(obj) == "Ray" then
		return self.Normal:Length() <= obj:GetNormal():Length()
	end
	return false
end

function RAY:__eq(obj)
	if type(obj) == "Ray" then
		return self.Origin == obj:GetOrigin() and self.Normal == obj:GetNormal()
	end
	return false
end