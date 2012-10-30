draw.Vector = function (vecPos,col)
	if IsColor(col) then
		surface.SetDrawColor(col.r,col.g,col.b,col.a)
	end
	local pos = vecPos:ToScreen()
	local scale = 6
	local posx = (vecPos+Vector(scale,0,0)):ToScreen()
	local posy = (vecPos+Vector(0,scale,0)):ToScreen()
	local posz = (vecPos+Vector(0,0,scale)):ToScreen()
	surface.DrawLine(pos.x,pos.y,posx.x,posx.y)
	surface.DrawLine(pos.x,pos.y,posy.x,posy.y)
	surface.DrawLine(pos.x,pos.y,posz.x,posz.y)
end

local oldR, oldG, oldB, oldA, num_Width
draw.DrawCircle = function (numX,numY,numRadius,tblColor)
	oldR, oldG, oldB, oldA = surface.GetDrawColor()
	if tblColor then
		surface.SetDrawColor(tblColor.r,tblColor.g,tblColor.b,tblColor.a)
	end
	for i=-numRadius, numRadius do
		num_Width = numRadius*math.cos(math.asin(i/numRadius))
		surface.DrawLine(numX - num_Width,numY + i,numX + num_Width,numY + i)
	end
	if tblColor then
		surface.SetDrawColor(oldR,oldG,oldB,oldA)
	end
end

local oldR, oldG, oldB, oldA, angInt, a --maybe a?
draw.DrawCircleOutline = function (numX,numY,numRadius, tblColor)
	oldR, oldG, oldB, oldA = surface.GetDrawColor()
	if tblColor then
		surface.SetDrawColor(tblColor.r,tblColor.g,tblColor.b,tblColor.a)
	end
	angInt = 360/(math.pi*numRadius) -- angle integral variable
	for a=angInt*1, 90, angInt do --to 90 to avoid precision loss in the loop (supposedly)
		surface.DrawLine(numX + math.cos(math.rad(a))*numRadius,numY + math.sin(math.rad(a))*numRadius,numX + math.cos(math.rad(a+angInt))*numRadius,numY + math.sin(math.rad(a+angInt))*numRadius)
		surface.DrawLine(numX + math.cos(math.rad(a+90))*numRadius,numY + math.sin(math.rad(a+90))*numRadius,numX + math.cos(math.rad(a+angInt+90))*numRadius,numY + math.sin(math.rad(a+angInt+90))*numRadius)
		surface.DrawLine(numX + math.cos(math.rad(a+180))*numRadius,numY + math.sin(math.rad(a+180))*numRadius,numX + math.cos(math.rad(a+angInt+180))*numRadius,numY + math.sin(math.rad(a+angInt+180))*numRadius)
		surface.DrawLine(numX + math.cos(math.rad(a+270))*numRadius,numY + math.sin(math.rad(a+270))*numRadius,numX + math.cos(math.rad(a+angInt+270))*numRadius,numY + math.sin(math.rad(a+angInt+270))*numRadius)
	end
	if tblColor then
		surface.SetDrawColor(oldR,oldG,oldB,oldA)
	end
end

local oldR, oldG, oldB, oldA, num_Width, i
draw.DrawEllipse = function (numX,numY,numRadiusH,numRadiusV,tblColor)
	oldR, oldG, oldB, oldA = surface.GetDrawColor()
	if tblColor then
		surface.SetDrawColor(tblColor.r,tblColor.g,tblColor.b,tblColor.a)
	end
	for i=-numRadiusV, numRadiusV do
		num_Width = numRadiusH*math.cos(math.rad(math.asin(i/numRadiusV)))
		surface.DrawLine(numX - num_Width,numY + i,numX + num_Width,numY + i)
	end
	if tblColor then
		surface.SetDrawColor(oldR,oldG,oldB,oldA)
	end
end

local oldR, oldG, oldB, oldA
draw.DrawRectOutline = function (numX,numY,numW,numH, tblColor, numWeight)
	if numWeight and numWeight > 1 then draw.DrawRectOutline(numX-1,numY-1,numW+2,numH+2, tblColor, numWeight - 1) end
	oldR, oldG, oldB, oldA = surface.GetDrawColor()
	if tblColor then
		surface.SetDrawColor(tblColor.r,tblColor.g,tblColor.b,tblColor.a)
	end
	surface.DrawLine(numX,numY,numX+numW,numY) -- -
	surface.DrawLine(numX+numW,numY+1,numX+numW,numY+numH-1) --   |
	surface.DrawLine(numX,numY+numH,numX+numW,numY+numH) -- _
	surface.DrawLine(numX,numY+1,numX,numY+numH-1) --|
	if tblColor then
		surface.SetDrawColor(oldR,oldG,oldB,oldA)
	end
end

local oldR, oldG, oldB, oldA
draw.DrawPolyOutline = function (tblPoints, tblColor, numWeight)
	if not (#tblPoints > 1) then return end --lol fail, lets draw a dot!
	oldR, oldG, oldB, oldA = surface.GetDrawColor()
	if tblColor then
		surface.SetDrawColor(tblColor.r,tblColor.g,tblColor.b,tblColor.a)
	end
	for i=1, #tblPoints-1 do
		if IsColor(tblPoints[i].col) then surface.SetDrawColor(tblPoints[i].col.r,tblPoints[i].col.g,tblPoints[i].col.b,tblPoints[i].col.a) end
		surface.DrawLine(tblPoints[i].x,tblPoints[i].y,tblPoints[i+1].x,tblPoints[i+1].y)
	end
	if IsColor(tblPoints[#tblPoints].col) then surface.SetDrawColor(tblPoints[#tblPoints].col.r,tblPoints[#tblPoints].col.g,tblPoints[#tblPoints].col.b,tblPoints[#tblPoints].col.a) end
	surface.DrawLine(tblPoints[#tblPoints].x,tblPoints[#tblPoints].y,tblPoints[1].x,tblPoints[1].y)
	if tblColor then
		surface.SetDrawColor(oldR,oldG,oldB,oldA)
	end
end

draw.VERTICAL = 0
draw.HORIZONTAL = 1

local oldR, oldG, oldB, oldA
draw.DrawTriangle = function (numX,numY,numSideLen,numHeight, tblColor, iOrient)
	oldR, oldG, oldB, oldA = surface.GetDrawColor()
	if tblColor then
		surface.SetDrawColor(tblColor.r,tblColor.g,tblColor.b,tblColor.a)
	end
	numSideLen = numSideLen*.5
	if type(iOrient) == "number" and iOrient == 1 then
		for i=0, numHeight, math.NormalizeDiff(0,numHeight) do
			surface.DrawLine(numX+i,numY-numSideLen*(i/numHeight),numX+i,numY+numSideLen*(i/numHeight))
		end
	else
		for i=0, numHeight, math.NormalizeDiff(0,numHeight) do
			surface.DrawLine(numX-numSideLen*(i/numHeight),numY+i,numX+numSideLen*(i/numHeight),numY+i)
		end
	end
	if tblColor then
		surface.SetDrawColor(oldR,oldG,oldB,oldA)
	end
end

 --fUPP is number of units per pixel
draw.DrawRadarRect = function (numX,numY,numW,numH,fUPP,vecPos, tblColor)
	local oldR, oldG, oldB, oldA = surface.GetDrawColor()
	if tblColor then
		surface.SetDrawColor(tblColor.r,tblColor.g,tblColor.b,tblColor.a)
	end
	
	if tblColor then
		surface.SetDrawColor(oldR,oldG,oldB,oldA)
	end
end

--USAGE:  surface.DrawFadingLine(10,10,20,20,Color(0,255,0,255),Color(255,0,0,200))
--THIS DONT WORK...not yet anyway. we'll seeeee
draw.DrawFadingLine = function (numX1,numY1,numX2,numY2,colStart,colEnd, numInterp)
	local oldR, oldG, oldB, oldA = surface.GetDrawColor()
	local dist = math.Dist(numX1,numY1,numX2,numY2) --just for now...lets not bother with optimizing this yet.
	numInterp = math.min(math.max(numInterp or 2,2),.5*dist)
	local numInterpStep = numInterp - 1
	local fInterp = numInterp/dist
	for i=numInterp, dist, numInterp do
		local f2 = i/dist
		local f = f2 - fInterp
		surface.SetDrawColor(
			Lerp(f,colStart.r,colEnd.r),
			Lerp(f,colStart.g,colEnd.g),
			Lerp(f,colStart.b,colEnd.b),
			Lerp(f,colStart.a,colEnd.a)
		)
		surface.DrawLine(
			math.Round(Lerp(f,numX1,numX2)),
			math.Round(Lerp(f,numY1,numY2)),
			math.Round(Lerp(f2,numX1,numX2)),
			math.Round(Lerp(f2,numY1,numY2))
		)
	end
	surface.SetDrawColor(oldR,oldG,oldB,oldA)
end
