local meta = FindMetaTable("Player")

function meta:CrouchingWorld()
	return (self:Crouching() and self:OnGroundWorld())
end
meta.IsCrouchingWorld = meta.CrouchingWorld

function meta:GetTouchingWall(len)
	len = len or 22
	local aim = objPl:GetAimVector():NoZ():Angle()
	local directions = {
		aim:Forward(),
		aim:Right()
	}
	directions[3] = directions[1]*-1
	directions[4] = directions[2]*-1
	local traceData = {start=self:GetPos(),filter=self}
	local min = {dir = nil,tr=nil}
	for _, dir in pairs(directions) do
		traceData.endpos = traceData.start + dir*len
		local tr = util.TraceLine(traceData).Hit
		if tr.Hit and not min.dir or tr.Fraction < min.tr.Fraction then
			min.dir = dir
			min.tr = tr
		end
	end
	
	return min.dir, min.tr
end

function meta:GetGroundDistance()
	local pos = self:GetPos()
	local tr = util.QuickTrace(pos,Vector(0,0,-1),objPl)
	return tr.StartPos:Distance(tr.HitPos)
end

function meta:GetGroundInfo()
	if self:OnGround() then
		local min, max, pos = self:OBBMins(), self:OBBMaxs(), self:GetPos()
		local dirs = {
			{start=Vector(min.x,min.y,0),endpos=Vector(max.x,max.y,0)},
			{start=Vector(min.x,.5*(max.y - min.y),0),endpos=Vector(max.x,.5*(max.y - min.y),0)},
			{start=Vector(min.x,max.y,0),endpos=Vector(min.x,max.y,0)},
			{start=Vector(.5*(max.x - min.x),min.y,0),endpos=Vector(.5*(max.x - min.x),max.y,0)}
		}
		for i=1, 4 do
			dirs[i+4] = {start=dirs[i].endpos,endpos=dirs[i].start}
		end
		local numOnGround, numFrac, tblNorms, tblEdgeHits, numAlt = 0, nil, {}, {}, 0
		local traceData = {filter=self}
		pos = pos + Vector(0,0,-1)
		local tblEdgeHits = {}
		for k, v in pairs(dirs) do
			traceData.start = v.start + pos
			traceData.endpos = v.endpos + pos
			local tr = util.TraceLine(traceData)
			if tr.Hit then
				if tr.Fraction > 0 then
					local frac = tr.HitPos:Distance(traceData.endpos)/32
					if not numFrac or frac > numFrac then
						numFrac = frac
					end
					local dist = traceData.start:Distance(util.TraceLine({start=traceData.start,endpos=traceData.start + Vector(0,0,16800),filter=self}).HitPos)
					if dist > numAlt then
						numAlt = dist
					end
					table.insert(tblNorms,tr.HitNormal)
					table.insert(tblEdgeHits,tr.HitPos)
				else
					numOnGround = numOnGround + 1
				end
			end
		end
		numFrac = numFrac or 1
		return true, tblNorms, numFrac, tblEdgeHits, numAlt
	end
	return false
end

function meta:GetViewMode()
	return self:GetNWInt("ViewMode",0) --use sharedint later
end
