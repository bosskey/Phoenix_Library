--serverside
module("scripted_vehicles",package.seeall)
local Type = {}
local Vehicles = {}
local PooledTypes = {}
local PooledClasses = {}


local function PoolType(strType)
	if not PooledTypes[strType] then
		PooledTypes[strType] = table.Count(PooledTypes) + 1
	end
end

local function GetPooledType(strType) return PooledTypes[strType] end

local function GetPooledClass(strType,strClass)
	if not PooledClasses[strType] then return {} end
	local tbl = PooledClasses[strType][strClass]
	if tbl then
		return tbl.id
	end
	return {}
end

local function GetClassData(strType,strClass)
	if not PooledClasses[strType] then return {} end
	local tbl = PooledClasses[strType][strClass]
	if tbl then
		return tbl.data
	end
	return {}
end

function _Register(strName, tblMeta)
	if not Type[strName] then
		PoolType(strName)
		Type[strName] = tblMeta
	end
end

function RegisterClass(strType,strClass,tblClassData)
	if not PooledClasses[strType] then PooledClasses[strType] = {} end
	if not PooledClasses[strType][strClass] then
		tblClassData.Model = tblClassData.Model or "null"
		PooledClasses[strType][strClass] = {id=table.Count(PooledClasses[strType]) + 1,data=tblClassData}
	end
end

function Create(strType,strClass)
	local objType = Type[strType]
	if objType then
		local objNew = {MetaName="ScriptedVehicle"}
		setmetatable(objNew,objType)
		table.Merge(objNew.Config,GetClassData(strType,strClass) or {})
		objNew.Type = strType
		objNew.Index = table.insert(Vehicles,objNew)
		objNew.Entity = ents.Create("base_anim_networkless")
		objNew.Entity:SetModel(tblClassData.Model)
		umsg.Start("sveh_spawn",0)
			umsg.Short(GetPooledType(strType))
			umsg.Short(GetPooledClass(strType,strClass))
		umsg.End()
		local func = objNew.Initialize --Run initialize hook on entity
		if type(func) == "function" then
			local bOk, valReturn = pcall(func,objNew)
			if not bOk then
				LibErrorHalt(valReturn)
			end
		else
			LibErrorHalt("attempt to call non-function")
		end
		return objNew
	end
	ErrorNoHalt("Scripted Vehicle : Cannot create unknown type '"..tostring(strType).."'\n")
end

function GetByIndex(numIndex)
	if type(numIndex) == "number" and numIndex > 0 then
		return Vehicles[numIndex] or NULL
	end
	return NULL
end

hook.Add("Tick",NAME,function () --make up networking etc
	for k, v in pairs(Vehicles) do
		if type(v.Snapshot) == "function" then
			local bOk, valReturn = pcall(v.Snapshot,v)
			if bOk then
				--implement valReturn table into usermessage for the snapshot
			else
				ErrorNoHalt("Scripted Vehicle : '"..v.Type.."' Snapshot failed : '"..tostring(valReturn).."'\n")
			end
		end
	end
end)

hook.Add("PlayerInitialSpawn",NAME,function (objPl)
	--send all vehicles currently active.
	for k, v in pairs(Vehicles) do
		umsg.Start("sveh_spawn_indexed",objPl)
			umsg.Short(k)
			umsg.Short(GetPooledType(strType))
			umsg.Short(GetPooledClass(strType,strClass))
		umsg.End()
	end
end)
