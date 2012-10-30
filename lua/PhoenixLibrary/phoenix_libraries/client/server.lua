module("server",package.seeall)
local CurrentMap = nil
hook.Add("InitPostEntity",NAME,function ()
	CurrentMap = string.gsub(string.gsub(Entity(0):GetModel(),"(%w*/)",""),".bsp","")
end)

function GetMap()
	return CurrentMap or "Loading..."
end 

function FlashlightsAllowed()
	return GetConVarNumber("mp_flashlights") == 1
end

function GetIP()
	return GetConVarString("hostip","Invalid")
end
