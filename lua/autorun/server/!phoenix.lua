AddCSLuaFile("autorun/!phoenix.lua")
AddCSLuaFile("autorun/client/!phoenix.lua")
include('autorun/!phoenix.lua')
if not ConVarExists("phoenixlib_enabled") then
	CreateConVar("phoenixlib_enabled","yup",FCVAR_NOTIFY)
end
Msg("----------------------------------------------------------\n===[ Starting Phoenix Libraries ]===\n")
local function LoadDermaControls()
	AddCSLuaFile("skins/!phoenix.lua")
	local num = 0
	for _, strName in pairs(file.FindInLua("PhoenixLibrary/derma_control_mods/*.lua")) do
		AddCSLuaFile("PhoenixLibrary/derma_control_mods/"..strName)
		num = num + 1
	end
	Msg("===[ derma_control_mods <Section> Client("..num..") ]===\n") num = 0
	for _, strName in pairs(file.FindInLua("PhoenixLibrary/phoenix_derma_controls/*.lua")) do
		AddCSLuaFile("PhoenixLibrary/phoenix_derma_controls/"..strName)
		num = num + 1
	end
	Msg("===[ phoenix_derma_controls <Section> Client("..num..") ]===\n")
end
LoadDermaControls()
local total, section = {shared=0,client=0,server=0}, {shared=0,client=0,server=0}
local function LoadFolder(strFolder,tblFileExceptions)
	for _,strName in pairs(file.FindInLua("PhoenixLibrary/"..strFolder.."/*.lua")) do
		if not tblFileExceptions[strName] then
			AddCSLuaFile("PhoenixLibrary/"..strFolder.."/"..strName)
			NAME = strFolder.."."..string.gsub(strName,'.lua','')..".shared"
			include('PhoenixLibrary/'..strFolder..'/'..strName)
			section.shared = section.shared + 1
		end
	end
	for _,strName in pairs(file.FindInLua("PhoenixLibrary/"..strFolder.."/server/*.lua")) do
		if not tblFileExceptions[strName] then
			NAME = strFolder.."."..string.gsub(strName,'.lua','')..".server"
			include('PhoenixLibrary/'..strFolder..'/server/'..strName)
			section.server = section.server + 1
		end
	end
	for _,strName in pairs(file.FindInLua("PhoenixLibrary/"..strFolder.."/client/*.lua")) do
		if not tblFileExceptions[strName] then
			AddCSLuaFile("PhoenixLibrary/"..strFolder.."/client/"..strName)
			section.client = section.client + 1
		end
	end
	Msg("===[ "..strFolder.." <Section> Shared("..section.shared..") Server("..section.server..") Client("..section.client..") ]===\n")
	total.shared = total.shared + section.shared
	total.client = total.client + section.client
	total.server = total.server + section.server
	section = {shared=0,client=0,server=0}
end
if file.Exists("../lua/PhoenixLibrary/phoenix_core/!core.lua") then
	AddCSLuaFile("PhoenixLibrary/phoenix_core/!core.lua")
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
	AddCSLuaFile("PhoenixLibrary/gamemode_event_ext/"..strName)
	NAME = "gamemode_event_ext."..string.gsub(strName,'.lua','')..".shared"
	include('PhoenixLibrary/gamemode_event_ext/'..strName)
	section.shared = section.shared + 1
end
for _, strName in pairs(file.FindInLua("PhoenixLibrary/gamemode_event_ext/server/*.lua")) do
	NAME = "gamemode_event_ext."..string.gsub(strName,'.lua','')..".server"
	include('PhoenixLibrary/gamemode_event_ext/server/'..strName)
	section.server = section.server + 1
end
for _, strName in pairs(file.FindInLua("PhoenixLibrary/gamemode_event_ext/client/*.lua")) do
	AddCSLuaFile("PhoenixLibrary/gamemode_event_ext/client/"..strName)
	section.client = section.client + 1
end
Msg("===[ gamemode_event_ext <Section> Hooks("..(table.Count(gamemode.Get("base")) - precount)..") Shared("..section.shared..") Client("..section.client..") Server("..section.server..") ]===\n")
total.shared = total.shared + section.shared
total.client = total.client + section.client
total.server = total.server + section.server
section = {count = 0}
local function LoadObjects()
	for _, strFolder in pairs(file.FindDirInLua("PhoenixLibrary/phoenix_objects/*.")) do
		if strFolder ~= ".svn" then
			if file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/register.lua") then
				AddCSLuaFile("PhoenixLibrary/phoenix_objects/"..strFolder.."/register.lua")
			end
			local tblMetaBase = {}
			tblMetaBase.__index = tblMetaBase
			if file.IsDirInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/base") then
				OBJ = tblMetaBase
				if file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/base/shared.lua") then
					AddCSLuaFile("PhoenixLibrary/phoenix_objects/"..strFolder.."/base/shared.lua")
					NAME = "phoenix_objects."..strFolder..".base.shared"
					include('PhoenixLibrary/phoenix_objects/'..strFolder..'/base/shared.lua')
				end
				if file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/base/init.lua") then
					NAME = "phoenix_objects."..strFolder..".base.init"
					include('PhoenixLibrary/phoenix_objects/'..strFolder..'/base/init.lua')
				end
				if file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/base/cl_init.lua") then
					AddCSLuaFile("PhoenixLibrary/phoenix_objects/"..strFolder.."/base/cl_init.lua")
				end
				tblMetaBase = OBJ
				OBJ = nil
			end
			for _2, strFolder2 in pairs(file.FindDirInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/*.")) do
				if strFolder2 ~= ".svn" and strFolder2 ~= "base" then
					OBJ = {}
					OBJ.__index = OBJ
					OBJ = table.Inherit(OBJ,tblMetaBase)
					local bServerReg = false
					if file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/"..strFolder2.."/shared.lua") then
						AddCSLuaFile("PhoenixLibrary/phoenix_objects/"..strFolder.."/"..strFolder2.."/shared.lua")
						NAME = "phoenix_objects."..strFolder.."."..strFolder2..".shared"
						include('PhoenixLibrary/phoenix_objects/'..strFolder..'/'..strFolder2..'/shared.lua')
						bServerReg = true
					end
					if file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/"..strFolder2.."/init.lua") then
						NAME = "phoenix_objects."..strFolder.."."..strFolder2..".init"
						include('PhoenixLibrary/phoenix_objects/'..strFolder..'/'..strFolder2..'/init.lua')
						bServerReg = true
					end
					if bServerReg and file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/register.lua") then
						OBJ_NAME = strFolder2
						NAME = "phoenix_objects."..strFolder..".register"
						include('PhoenixLibrary/phoenix_objects/'..strFolder..'/register.lua')
						OBJ_NAME = nil
					end
					OBJ = nil
					if file.ExistsInLua("PhoenixLibrary/phoenix_objects/"..strFolder.."/"..strFolder2.."/cl_init.lua") then
						AddCSLuaFile("PhoenixLibrary/phoenix_objects/"..strFolder.."/"..strFolder2.."/cl_init.lua")
					end
					section.count = section.count + 1
				end
			end
		end
	end
end
LoadObjects()
concommand.Add("phxlib_objects_reload",function (objPl,strCmd,tblArgs)
	if objPl:IsSuperAdmin() or objPl:EntIndex() == 0 then
		LoadObjects()
		Msg("Successfully reloaded phoenix library objects!\n")
		return
	end
	Msg("You must be an admin or developer to use this console command!\n")
end)
Msg("===[ phoenix_objects <Section> Objects("..section.count..") ]===\n")

Msg("===[ Phoenix Library Loaded <Total> Shared("..total.shared..") Client("..total.client..") Server("..total.server..") ]===\n----------------------------------------------------------\n")
