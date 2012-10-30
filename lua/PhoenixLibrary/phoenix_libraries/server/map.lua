local objSun = NullEntity()
hook.Add("InitPostEntity",NAME,function ()
	local strMapName, strFile = game.GetMap(), ''
	
	local tblSuns = ents.FindByClass("env_sun")
	if #tblSuns > 0 then 
		objSun = tblSuns[1]
		if objSun and objSun:IsValid() then
			strFile = strFile.."SunPosition="..tostring(objSun:GetPos())..'\n'
		end
	else
		strFile = strFile.."SunPosition=0 0 0\n"
	end

	file.Write("PhoenixLibrary/map/"..strMapName..".txt",strFile)
	resource.AddFile("data/PhoenixLibrary/map/"..strMapName..".txt")
end)

module("map",package.seeall)

function GetSunPosition()
	if ValidEntity(objSun) then return objSun:GetPos() end
	return Vector(0,0,0)
end