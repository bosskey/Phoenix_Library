
local function BreakupLine()
	local tbl = {math.random(0,52)}
	local lastY = tbl[1]
	for i=1, math.random(6,18) do
		lastY = lastY + math.random(12,64)
		if lastY >= ScrH() then table.insert(tbl,ScrH()) break end
		table.insert(tbl,lastY)
	end
	return tbl
end

local Bars = {}
for i=1, 4 do
	Bars[i] = {x=math.random(0,ScrW()),velx=math.randsign(math.random(30,60))}
end

local lastPaint = nil
hook.Add("ConsoleOpened",NAME,function () lastPaint = nil end)
screen.RegisterEffect("filmgrain",function (w,h)
	lastPaint = lastPaint or CurTime()
	local fDelta = CurTime() - lastPaint
	lastPaint = CurTime()
	for k, v in ipairs(Bars) do
		local newx = v.velx*fDelta + v.x
		if newx > w then
			v.velx = -1*v.velx
			newx = w
		elseif newx < 0 then
			v.velx = -1*v.velx
			newx = 0
		end
		v.x = newx
		local tblY = BreakupLine()
		for i=2, #tblY, 2 do
			surface.SetDrawColor(255,255,255,math.random(50,100))
			surface.DrawLine(math.Round(v.x),tblY[i-1],math.Round(v.x),tblY[i])
		end
	end
end)