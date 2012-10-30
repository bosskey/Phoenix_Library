
util.TraceDir = function (vecPos, vecDir, tblFilter, bitMasks)
	local tblTraceData = {start=vecPos,endpos=vecPos + vecDir*16384}
	if type(tblFilter) == "table" or ValidEntity(tblFilter) then
		tblTraceData.filter = tblFilter
	end
	if bitMasks then
		tblTraceData.mask = bitMasks
	end
	return util.TraceLine(tblTraceData)
end
util.DirectionTrace = util.TraceDir

util.QuickTrace = function (vecOrigin, vecDir, tblFilter, bitMasks)
	local tblTraceData = {start=vecOrigin,endpos=vecOrigin + vecDir}
	if type(tblFilter) == "table" or ValidEntity(tblFilter) then
		tblTraceData.filter = tblFilter
	end
	if bitMasks then
		tblTraceData.mask = bitMasks
	end
	return util.TraceLine(tblTraceData)
end

local function AddPoint(tbl,vec)
	table.insert(tbl,{start=tbl[#tbl].endpos,endpos=vec})
end
local function AddTrace(tbl,vecStart,vecEnd)
	table.insert(tbl,{start=vecStart,endpos=vecEnd})
end
local function MakeTrace(vecStart,vecEnd)
	return {start=vecStart,endpos=vecEnd}
end

util.GetBoxSurfaceTraces = function (vecMin,vecMax)
	return {
		MakeTrace(vecMin,Vector(vecMin.x,vecMax.y,vecMax.z)),
		MakeTrace(Vector(vecMin.x,vecMin.y,vecMax.z),Vector(vecMin.x,vecMax.y,vecMin.z)),
		MakeTrace(vecMin,Vector(vecMax.x,vecMin.y,vecMax.z)),
		MakeTrace(Vector(vecMin.x,vecMin.y,vecMax.z),Vector(vecMax.x,vecMin.y,vecMin.z)),
		MakeTrace(Vector(vecMax.x,vecMin.y,vecMin.z),vecMax),
		MakeTrace(Vector(vecMax.x,vecMin.y,vecMax.z),Vector(vecMax.x,vecMax.y,vecMin.z)),
		MakeTrace(vecMax,Vector(vecMin.x,vecMax.y,vecMin.z)),
		MakeTrace(Vector(vecMin.x,vecMax.y,vecMax.z),Vector(vecMax.x,vecMax.y,vecMin.z)),
		MakeTrace(Vector(vecMin.x,vecMin.y,vecMax.z),vecMax),
		MakeTrace(Vector(vecMax.x,vecMin.y,vecMax.z),Vector(vecMin.x,vecMax.y,vecMax.z)),
		MakeTrace(vecMin,Vector(vecMax.x,vecMax.y,vecMin.z)),
		MakeTrace(Vector(vecMax.x,vecMin.y,vecMin.z),Vector(vecMin.x,vecMax.y,vecMin.z))
	}
end

util.GetBoxCorners = function (vecMin,vecMax)
	return {
		vecMin,
		Vector(vecMax.x,vecMin.y,vecMin.z),
		Vector(vecMax.x,vecMax.y,vecMin.z),
		Vector(vecMin.x,vecMax.y,vecMin.z),
		Vector(vecMin.x,vecMin.y,vecMax.z),
		Vector(vecMax.x,vecMin.y,vecMax.z),
		vecMax,
		Vector(vecMin.x,vecMax.y,vecMax.z)
	}
end

util.GetBoxEdgeTraces = function (vecMin,vecMax)
	local tbl = {}
	AddTrace(tbl,vecMax,Vector(vecMin.x,vecMax.y,vecMax.z))
	AddTrace(tbl,Vector(vecMax.x,vecMax.y,vecMin.z),Vector(vecMin.x,vecMax.y,vecMin.z))
	AddTrace(tbl,vecMin,Vector(vecMin.x,vecMin.y,vecMax.z))
	AddPoint(tbl,Vector(vecMin.x,vecMin.y,vecMax.z))
	AddPoint(tbl,Vector(vecMin.x,vecMax.y,vecMax.z))
	AddPoint(tbl,Vector(vecMin.x,vecMax.y,vecMin.z))
	AddPoint(tbl,vecMin)
	AddPoint(tbl,Vector(vecMax.x,vecMin.y,vecMin.z))
	AddPoint(tbl,Vector(vecMax.x,vecMin.y,vecMax.z))
	AddPoint(tbl,Vector(vecMin.x,vecMin.y,vecMax.z))
	AddTrace(tbl,Vector(vecMax.x,vecMin.y,vecMin.z),Vector(vecMax.x,vecMax.y,vecMin.z))
	AddPoint(tbl,vecMax)
	AddPoint(tbl,Vector(vecMax.x,vecMin.y,vecMax.z))
	return tbl
end

util.GetBoxInternalTraces = function (vecMin,vecMax)
	return {
		{start=vecMin,endpos=vecMax},
		MakeTrace(Vector(vecMax.x,vecMin.y,vecMin.z),Vector(vecMin.x,vecMax.y,vecMax.z)),
		MakeTrace(Vector(vecMin.x,vecMin.y,vecMax.z),Vector(vecMax.x,vecMax.y,vecMin.z)),
		MakeTrace(Vector(vecMax.x,vecMin.y,vecMax.z),Vector(vecMin.x,vecMax.y,vecMin.z))
	}
end

util.BoxInWorld = function (vecMin,vecMax)
	local tblTraces = table.Add(util.GetBoxEdgeTraces(vecMin,vecMax),util.GetBoxSurfaceTraces(vecMin,vecMax))
	for k, v in pairs(tblTraces) do
		if util.TraceLine(v).HitWorld then
			return false
		end
	end
	for k, v in pairs(util.GetBoxCorners(vecMin,vecMax)) do
		if not util.IsInWorld(v) then
			return false
		end
	end
	return true
end

-- Below code is possibly not completed and it's really complex to figure out every possibility for box overlaps, though it is very neat :D
-- I hope this works for world vectors as well as local vector boxes... I mean comon... I can't redo all this code below for the same shit over!
util.BoxInBox = function (vecMin1,vecMax1,vecMin2,vecMax2)
	return vecMin1:InBox(vecMin2,vecMax2) or vecMax1:InBox(vecMin2,vecMax2) or vecMin2:InBox(vecMin1,vecMax1) or vecMax2:InBox(vecMin1,vecMax1) or
	(vecMin1.y < vecMin2.y and vecMax1.y > vecMax2.y and ((math.InBounds(vecMin1.x,vecMin2.x,vecMax2.x) and math.InBounds(vecMin1.z,vecMin2.z,vecMax2.z)) or (math.InBounds(vecMax1.x,vecMin2.x,vecMax2.x) and math.InBounds(vecMax1.z,vecMin2.z,vecMax2.z)))) or 
	(vecMin1.x < vecMin2.x and vecMax1.x > vecMax2.x and ((math.InBounds(vecMin1.y,vecMin2.y,vecMax2.y) and math.InBounds(vecMin1.z,vecMin2.z,vecMax2.z)) or (math.InBounds(vecMax1.y,vecMin2.y,vecMax2.y) and math.InBounds(vecMax1.z,vecMin2.z,vecMax2.z)))) or 
	(vecMin1.z < vecMin2.z and vecMax1.z > vecMax2.z and ((math.InBounds(vecMin1.x,vecMin2.x,vecMax2.x) and math.InBounds(vecMin1.y,vecMin2.y,vecMax2.y)) or (math.InBounds(vecMax1.x,vecMin2.x,vecMax2.x) and math.InBounds(vecMax1.y,vecMin2.y,vecMax2.y))))
end

