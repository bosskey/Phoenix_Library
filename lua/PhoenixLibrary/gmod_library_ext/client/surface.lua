local CircleCache = {}
local BaseTable = {[1]={["x"]=math.cos(0),["y"]=math.sin(0)}}

local oldSetDrawColor = oldSetDrawColor or surface.SetDrawColor
local CurrentRed, CurrentGreen, CurrentBlue, CurrentAlpha
surface.SetDrawColor = function (r,g,b,a,...)
	CurrentRed = r
	CurrentGreen = g
	CurrentBlue = b
	CurrentAlpha = a
	return oldSetDrawColor(r,g,b,a,...)
end

surface.GetDrawColor = function ()
	return CurrentRed, CurrentGreen, CurrentBlue, CurrentAlpha
end

--[[ --OMG SO MUCH CACHE, TO BE EXPLORED LATER!!!, The running sequence would run through too many points!!!
local TotalPoints = {
	Hits = {},
	Miss = {}
}
local MAP = {
	SCANQUALITY = 64,
	CACHEPRUNEDIST = 1 --Prune hits in this range
}
local function DoMapGeneration()
	for i=0, 360, MAP.SCANQUALITY do
		
	end
end
--These two functions below are not to be used alot, infact, they should only be used once to start, stopping if user specifies it or something, not to be actively toggled!!!
surface.StartMapGeneration = function () hook.Add("Think","MapGeneration",DoMapGeneration) end
surface.StopMapGeneration = function () hook.Remove("Think","MapGeneration") end
]]

--Continue testing this, it should work with the example far below in comment...
surface.GenerateMap = function (vecPos,numRadius,numQuality,tblFilter)
	local tblMap = {Points = {},Pos=vecPos,Radius=numRadius}
	local traceData = {start=vecPos,mask=MASK_NPCWORLDSTATIC}
	if type(tblFilter) == "table" then
		traceData.filter = tblFilter
	end
	local space = 360/numQuality
	for ang=0, 360, space do
		--local rad = math.Deg2Rad(ang)
		traceData.endpos = vecPos + Angle(0,ang,0):Forward()*numRadius
		local tr = util.TraceLine(traceData)
		local tblPoint = {Pos=tr.HitPos,Ang=ang,Hit=tr.Hit,Norm=tr.HitNormal}
		table.insert(tblMap.Points,tblPoint)
	end
	return tblMap
end
local function GetXYFromDiff(vecDiff,numRadius,angMod)
	local sX, sY = vecDiff.x/numRadius, vecDiff.y/numRadius
	local rScale = math.sqrt(sX^2 + sY^2)
	local nRotate = math.Deg2Rad(math.Rad2Deg(math.atan2(sX,sY)) - angMod)
	return math.cos(nRotate)*rScale, math.sin(nRotate)*rScale
end
-- surface.DrawMap(surface.Generate2DMap(Vector(0,0,0),1024,180,{Entity(0)}),CL:EyeAngles(),ScrW()*.5,ScrH()*.5,100,Color(0,255,0,200)) --Example usage
surface.DrawMap = function (tblMap,angDir,numX,numY,numSize,col) --Add POLY-Drawn Wall simulation
	angDir = Angle(0,angDir.y,0)
	local vecDir = angDir:Forward()
	local angMod = math.Rad2Deg(math.atan2(vecDir.x,vecDir.y)) + 90
	surface.SetDrawColor(col.r,col.g,col.b,col.a)
	for i=2, table.getn(tblMap.Points) do
		local v1, v2 = tblMap.Points[i-1], tblMap.Points[i]
		if v1.Hit and v2.Hit then
			local x1, y1 = GetXYFromDiff(v1.Pos - tblMap.Pos,tblMap.Radius,angMod)
			x1, y1 = numX + x1*numSize, numY + y1*numSize
			local x2, y2 = GetXYFromDiff(v2.Pos - tblMap.Pos,tblMap.Radius,angMod)
			x2, y2 = numX + x2*numSize, numY + y2*numSize
			surface.DrawLine(x1,y1,x2,y2)
		end
	end
end
