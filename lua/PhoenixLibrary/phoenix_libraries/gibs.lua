module("gibs",package.seeall)
local GIB_CLEAR_TIME = 1.75
local Gibs = {}
local ClearingGibs = {}

hook.Add("Think",NAME,function ()
	for _, v in pairs(Gibs) do
		if #v.gibs > 0 and v.gibs[1].time < CurTime() then
			table.remove(ClearingGibs,table.remove(v,1))
		end
	end
	local ToRemove = {}
	for k, gib2 in pairs(ClearingGibs) do
		local fDelta = 1 - ((CurTime() - gib2.time)/GIB_CLEAR_TIME)
		if fDelta < 0 then
			table.insert(ToRemove,k)
			local r, g, b = gib2.ent:GetColor()
			gib2.ent:SetColor(r,g,b,0)
		else
			local r,g,b = v2.ent:GetColor()
			gib2.ent:SetColor(r,g,b,math.Round(fDelta))
		end
	end
	if #ToRemove then
		for _1, index in pairs(ToRemove) do
			table.remove(ClearingGibs,index)
		end
	end
end)

local function OnGibRemoved(objEnt,strGroup,numIndex)
	Gibs[strGroup].gibs[numIndex] = nil
end

function Add(objEnt,strGroup)
	if not Gibs[strGroup] then
		LibErrorHalt("Gib-group '"..tostring(strGroup).."' is not registered.")
	end
	if table.getn(Gibs[strGroup]) > Gibs[strGroup].config.max then
		table.insert(ClearingGibs,table.remove(Gibs[strGroup].gibs,1))
	end
	objEnt:CallOnRemove("gibs_manager",OnGibRemoved,objEnt,strGroup,table.insert(Gibs[strGroup].gibs,{ent=objEnt,time=CurTime() + Gibs[strGroup].config.ttl}))
end

function RegisterGroup(strGroup,numMaxGibs,numLiveTime)
	Gibs[strGroup] = {config = {max=numMaxGibs,ttl=numLiveTime},gibs = {}}
end

function ClearGroup(strGroup)
	if not Gibs[strGroup] then
		LibErrorHalt("Gib-group '"..tostring(strGroup).."' is not registered.")
	end
	local clkTime = CurTime()
	for k, v in pairs(Gibs[strGroup].gibs) do
		v.ent:RemoveCallOnRemove("gibs_manager")
		table.insert(ClearingGibs,{ent=v.ent,time=clkTime})
	end
	Gibs[strGroup].gibs = {}
end
