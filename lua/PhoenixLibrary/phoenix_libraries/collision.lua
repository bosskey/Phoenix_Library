
--Cobwebs have built up on this library, ignore it for the time being.
module("collision",package.seeall)
local Collision = {}
local function CheckCollision(objEnt,vecPos,angDir,vecMin,vecMax)
	local Positions = {
		angDir:Up()*vecMax.z,
		angDir:Right()*vecMax.x,
		angDir:Forward()*vecMax.y,
	}
	Positions[4] = Positions[1]*-1
	Positions[5] = Positions[2]*-1
	Positions[6] = Positions[3]*-1
	local traceData, tblHits = {start=vecPos,filter=objEnt}, {}
	for _, pos in pairs(Positions) do
		traceData.endpos = vecPos + pos
		local tr = util.TraceLine(traceData)
		if tr.Hit then
			table.insert(tblHits,tr)
		end
	end
	if #tblHits > 0 then
		
	end
end

function CalculateBox(vecMin,vecMax,vecPos,vecVel)
	
end

function CalculateSphere(vecPos,numRadius,vecVel,numFriction,numBounce)
	if vecVel.x == 0 and vecVel.y == 0 and vecVel.z == 0 then return vecPos, vecVel end
	numFriction = numFriction or 0
	numBounce = numBounce or 1
	local fDelta = FrameTime()
	local vecNewPos, vecNewVel = vecPos + vecVel*fDelta, vecVel
	local tr = util.TraceLine({start=vecNewPos,endpos=vecNewPos + (vecVel:GetNormal())*numRadius})
	if tr.Hit then
		local newVelDir = (2*tr.HitNormal*(tr.HitNormal:DotProduct(tr.Normal*-1)) + tr.Normal)
		local vecFriction = ((tr.HitPos - newVelDir) - (tr.HitPos - vecVel:GetNormal()))
		return vecPos + (tr.Normal*numRadius)*tr.Fraction, newVelDir*numBounce*vecVel:Length()*(2 - vecFriction:Length())*(1 - numFriction)
	end
	return vecNewPos, vecNewVel
end

function CalculateEntity(objEnt)
	local vecPos, angDir, vecVel, vecMin, vecMax = objEnt:GetPos(), objEnt:GetAngles(), objEnt:GetVelocity(), objEnt:OBBMins(), objEnt:OBBMaxs()
	if vecVel.x == 0 and vecVel.y == 0 and vecVel.z == 0 then return vecPos, vecVel end
	local fDelta = FrameTime()
	local vecNewPos = vecPos + vecVel*fDelta
	
end
