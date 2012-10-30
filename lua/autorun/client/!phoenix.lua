include('autorun/!phoenix.lua')
NAME = "!CL"
hook.Add("OnEntityCreated",NAME,function (objEnt)
	if objEnt:IsPlayer() and not ValidEntity(CL) then
		CL = objEnt
	end
end)

hook.Add("InitPostEntity",NAME,function ()
	if not ValidEntity(CL) then
		CL = LocalPlayer()
		print("LocalPlayer not created yet, valid after gamemode and map : "..print(ValidEntity(CL)))
	end
end)

Msg("----------------------------------------------------------\n===[ Starting Phoenix Libraries ]===\n")

local total, section = {shared=0,client=0}, {shared=0,client=0}
local function LoadFolder(strFolder,tblFileExceptions)
	for _, strName in pairs(file.FindInLua("PhoenixLibrary/"..strFolder.."/*.lua")) do
		if not tblFileExceptions[strName] then
			NAME = strFolder.."."..string.gsub(strName,".lua",'')..".shared"
			include('PhoenixLibrary/'..strFolder..'/'..strName)
			section.shared = section.shared + 1
		end
	end
	for _, strName in pairs(file.FindInLua("PhoenixLibrary/"..strFolder.."/client/*.lua")) do
		if not tblFileExceptions[strName] then
			NAME = strFolder.."."..string.gsub(strName,".lua",'')..".client"
			include('PhoenixLibrary/'..strFolder..'/client/'..strName)
			section.client = section.client + 1
		end
	end
	Msg("===[ "..strFolder.." <Section> Shared("..section.shared..") Client("..section.client..") ]===\n")
	total.shared = total.shared + section.shared
	total.client = total.client + section.client
	section = {shared=0,client=0}
end
if file.Exists("../lua/PhoenixLibrary/phoenix_core/!core.lua") then
	NAME = "phoenix_core.core"
	include('PhoenixLibrary/phoenix_core/!core.lua')
	section.shared = section.shared + 1
end
LoadFolder('phoenix_core',{['!core.lua']=true})
LoadFolder('thirdparty_ext',{})
LoadFolder('global_library_ext',{})
LoadFolder('phoenix_libraries',{})
LoadFolder('gmod_library_ext',{})
LoadFolder('gmod_meta_ext',{})
LoadFolder('phoenix_library_instances',{})

local precount = table.Count(gamemode.Get("base"))
for _, strName in pairs(file.FindInLua("PhoenixLibrary/gamemode_event_ext/*.lua")) do
	NAME = "gamemode_event_ext."..string.gsub(strName,'.lua','')..".shared"
	include('PhoenixLibrary/gamemode_event_ext/'..strName)
	section.shared = section.shared + 1
end
for _, strName in pairs(file.FindInLua("PhoenixLibrary/gamemode_event_ext/client/*.lua")) do
	NAME = "gamemode_event_ext."..string.gsub(strName,'.lua','')..".client"
	include('PhoenixLibrary/gamemode_event_ext/client/'..strName)
	section.client = section.client + 1
end
Msg("===[ gamemode_event_ext <Section> Hooks("..(table.Count(gamemode.Get("base")) - precount)..") Shared("..section.shared..") Client("..section.client..") ]===\n")
total.shared = total.shared + section.shared
total.client = total.client + section.client
section = {count = 0}
local function LoadObjects()
	for _, strFolder in pairs(file.FindDirInLua("PhoenixLibrary/phoenix_objects/*.")) do
		if strFolder ~= ".svn" then
			local tblMetaBase = {MetaName='base'} tblMetaBase.__index = tblMetaBase
			if file.IsDirInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/base") then
				OBJ = tblMetaBase
				if file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/base/shared.lua") then
					NAME = "phoenix_objects."..strFolder..".base.shared"
					include('PhoenixLibrary/phoenix_objects/'..strFolder..'/base/shared.lua')
				end
				if file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/base/cl_init.lua") then
					NAME = "phoenix_objects."..strFolder..".base.cl_init"
					include('PhoenixLibrary/phoenix_objects/'..strFolder..'/base/cl_init.lua')
				end
				tblMetaBase = OBJ
				OBJ = nil
			end
			for _2, strFolder2 in pairs(file.FindDirInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/*.")) do
				if strFolder2 ~= ".svn" and strFolder2 ~= "base" then
					OBJ = {MetaName=strFolder2} OBJ.__index = OBJ
					OBJ = table.Inherit(OBJ,tblMetaBase)
					local bClientReg = false
					if file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/"..strFolder2.."/shared.lua") then
						NAME = "phoenix_objects."..strFolder.."."..strFolder2..".shared"
						include('PhoenixLibrary/phoenix_objects/'..strFolder..'/'..strFolder2..'/shared.lua')
						bClientReg = true
					end
					if file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/"..strFolder2.."/cl_init.lua") then
						NAME = "phoenix_objects."..strFolder.."."..strFolder2..".cl_init"
						include('PhoenixLibrary/phoenix_objects/'..strFolder..'/'..strFolder2..'/cl_init.lua')
						bClientReg = true
					end
					if bClientReg and file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/register.lua") then
						OBJ_NAME = strFolder2
						NAME = "phoenix_objects."..strFolder..".register"
						include('PhoenixLibrary/phoenix_objects/'..strFolder..'/register.lua')
						OBJ_NAME = nil
					end
					OBJ = nil
					section.count = section.count + 1
				end
			end
		end
	end
end
LoadObjects()
concommand.Add("phxlib_objects_reload_cl",function (objPl,strCmd,tblArgs)
	LoadObjects()
	Msg("Successfully reloaded phoenix library objects!\n")
end)
Msg("===[ phoenix_objects <Section> Objects("..section.count..") ]===\n")

Msg("===[ Phoenix Library Loaded <Total> Shared("..total.shared..") Client("..total.client..") ]===\n----------------------------------------------------------\n")
