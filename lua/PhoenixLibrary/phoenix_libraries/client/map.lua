local SunPosition = Vector(0,0,0)
local strMapName = ''
hook.Add("InitPostEntity",NAME,function ()
	strMapName = string.gsub(string.gsub(Entity(0):GetModel(),"(%w*/)",""),".bsp","")
	if file.Exists("PhoenixLibrary/map/"..strMapName..".txt") then
		local strFile = file.Read("PhoenixLibrary/map/"..strMapName..".txt")
		local tblLines = string.Explode('\n',strFile)
		local sepSunPos = string.Explode(' ',string.Explode('=',tblLines[1])[2])
		SunPosition = Vector(tonumber(sepSunPos[1]),tonumber(sepSunPos[2]),tonumber(sepSunPos[3]))
	end
end)

hook.Add("ShutDown",NAME,function ()
	if file.Exists("PhoenixLibrary/map/"..strMapName..".txt") then
		file.Delete("PhoenixLibrary/map/"..strMapName..".txt")
	end
end)

module("map",package.seeall)

function GetSunPosition() return SunPosition end