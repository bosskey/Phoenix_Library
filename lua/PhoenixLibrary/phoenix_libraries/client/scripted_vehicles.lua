--clientside
module("scripted_vehicles",package.seeall)
local Type = {}
local Vehicles = {}
local PooledTypes = {}
local PooledClasses = {}
local Classes = {}

local function GetPooledClassData(strType,num)
	if not PooledClasses[strType] then Msg("no classes in type '"..tostring(strType).."'\n") return {} end
	return (PooledClasses[strType][num] or {}).data or {}
end

function _Register(strName, tblMeta)
	--doesn't support phxlib_reload objects -.- wtf was I thinking...
	table.insert(PooledTypes,strName)
	Type[strName] = tblMeta
end

function RegisterClass(strType,strClass,tblClassData)
	if not PooledClasses[strType] then PooledClasses[strType] = {} end
	
	-- >> specialization on this line is optional
	
	PooledClasses[strType][strClass] = tblClassData
	table.insert(PooledClasses[strType],{name=strClass,data=tblClassData})
end

local function GetClassData(strType,strClass)
	if not PooledClasses[strType] then Msg("no classes in type '"..tostring(strType).."'\n") return {} end
	return PooledClasses[strType][strClass] or {}
end

local function Create(strType,strClass)
	local objType = Type[strType]
	if objType then
		local objNew = {MetaName="ScriptedVehicle"}
		setmetatable(objNew,objType)
		table.Merge(objNew.Config,GetClassData(strType,strClass))
		objNew.Type = strType
		objNew.Index = table.insert(Vehicles,objNew)
		--objNew.Entity = ClientsideModel(tblClassData.Model,RENDERGROUP_OPAQUE)
		
		return objNew
	end
	ErrorNoHalt("Scripted Vehicle : Cannot create unknown type '"..tostring(strType).."'\n")
end

function Remove(index)
	if Vehicles[index] then
		Vehicles[index] = nil
	end
end

function GetByIndex(numIndex)
	if type(numIndex) == "number" and numIndex > 0 then
		return Vehicles[numIndex] or NULL
	end
	return NULL
end

local PredictedData = {}
usermessage.Hook("sveh_spawn",function (um)
	local strType = PooledTypes[um:ReadShort()]
	local strClass = PooledClasses[um:ReadShort()]
	--local tblClassData = GetPooledClassData(strType,numClass)
	PredictedData.type = strType
	PredictedData.class = strClass
	util.Effect("scriptedvehicle_core",EffectData(),true,true)
	--Create(strType,strClass)
end)

usermessage.Hook("sveh_spawn_indexed",function (um)
	local numIndex = um:ReadShort()
	local strType = PooledTypes[um:ReadShort()]
	local strClass = PooledClasses[um:ReadShort()]
	PredictedData.type = strType
	PredictedData.class = strClass
	PredictedData.index = numIndex
	util.Effect("scriptedvehicle_core",EffectData(),true,true)
end)

usermessage.Hook("sveh_update",function (um)
	--is only by pvs
end)

function _SpawnVehicle(objEffect)
	local objVeh = Create(PredictedData.type,PredictedData.class)
	objVeh.Entity = objEffect.Entity
	objEffect.VehicleObject = objVeh
	local func = objVeh.Initialize
	if type(func) == "function" then
		local bOk, valReturn = pcall(func,objVeh)
		if not bOk then
			LibErrorHalt(valReturn)
		end
	else
		LibErrorHalt("attempt to call non-function")
	end
	if PredictedData.index then
		objVeh.index = PredictedData.index
		Vehicles[PredictedData.index] = objVeh
		PredictedData.index = nil
	else
		objVeh.Index = table.insert(Vehicles,objVeh)
	end
end

function _ThinkVehicle(objEffect)
	local func = objEffect.VehicleObject.Think
	if type(func) == "function" then
		local bOk, valReturn = pcall(func,objEffect.VehicleObject)
		if not bOk then
			LibErrorHalt(valReturn)
		end
		return Vehicles[objEffect.VehicleObject.Index] != nil
	else
		LibErrorHalt("attempt to call non-function")
	end
end

local bOk, valReturn
hook.Add("Tick",NAME,function () --handles vehicle calls for clientside think of vehicles
	for k, v in pairs(Vehicles) do
		if type(v.Tick) == "function" then
			bOk, valReturn = pcall(v.Tick,v)
			if not bOk then
				ErrorNoHalt("Scripted Vehicle : '"..v.Type.."' Tick failed : '"..tostring(valReturn).."'\n")
			end
		end
	end
end)
--[[
hook.Add("RenderScreenspace",NAME,function ()
	for k, v in pairs(Vehicles) do
		if type(v.Draw) == "function" then
			bOk, valReturn = pcall(v.Draw,v)
			if not bOk then
				ErrorNoHalt("Scripted Vehicle : '"..v.Type.."' Draw failed : '"..tostring(valReturn).."'\n")
			end
		end
	end
end)]]
