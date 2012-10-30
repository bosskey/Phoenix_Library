local meta = FindMetaTable("Entity")

function meta:OnGroundWorld()
	return (self:OnGround() and self:GetGroundEntity():IsWorld())
end
meta.IsOnGroundWorld = meta.OnGroundWorld

function meta:IsEntityDrawing()
	return CurTime() - (self.LastDraw or 0) <= FrameTime()
end

function meta:GetDirections()
	local tbl = { self:GetForward(), self:GetRight(), self:GetUp() }
	tbl[4] = tbl[1]*-1
	tbl[5] = tbl[2]*-1
	tbl[6] = tbl[3]*-1
	return tbl
end

function meta:AddVelocity(vel)
	self:SetVelocity(self:GetVelocity() + vel)
end

function meta:InBox(vecMin,vecMax)
	return util.BoxInBox(self:LocalToWorld(self:OBBMins()),self:LocalToWorld(self:OBBMaxs()),vecMin,vecMax)
end

function meta:IsClass(...)
	local strClass = self:GetClass()
	for index, str in pairs({...}) do
		if strClass == str then
			return true, index
		end
	end
	return false, -1
end

function meta:GetCenter()
	return self:GetPos() + self:OBBCenter()
end

function meta:OBBSize()
	return self:OBBMins():Distance(self:OBBMaxs())
end

function meta:GetLength(vecNorm, vecLocalOffset)
	vecNorm = vecNorm*16000
	vecLocalOffset = vecLocalOffset or self:OBBCenter()
	local vecPos = self:GetPos() + vecLocalOffset
	return self:NearestPoint(vecPos - vecNorm):Distance(self:NearestPoint(vecPos + vecNorm))
end

function meta:IsScripted()
	return type(self.Type) == "string"
end

local CL_Visibles = CL_Visibles or {}
usermessage.Hook("__ent_visibility",function (um)

end)
function meta:IsEntityVisible()
	return CL_Visibles[self] or false
end

--[[
function meta:ResolveNewPosition(vecPos)
	local vecRealPos = self:GetPos()
	local vecU, vecF, vecR = self:GetUp(), self:GetForward(), self:GetRight()
	local vecMinU = self:NearestPoint(vecRealPos - vecU*16000)
	local vecMaxU = self:NearestPoint(vecRealPos + vecU*16000)
	local vecMinF = self:NearestPoint(vecRealPos - vecF*16000)
	local vecMaxF = self:NearestPoint(vecRealPos + vecF*16000)
	local vecMinR = self:NearestPoint(vecRealPos - vecR*16000)
	local vecMaxR = self:NearestPoint(vecRealPos + vecR*16000)
	local traceData = {start=vecRealPos,filter=self}
	for i = 
	
	return vecResolvedPos
end
]]