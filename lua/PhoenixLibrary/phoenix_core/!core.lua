--This is required to access custom objects made in phoenixlibrary, their typename; so they don't just look like 'table' objects

_G.__type = _G.__type or _G.type
_G._unpack = _G._unpack or _G.unpack

local oldType = __type
function type(var)
	local strType = (__type or oldType)(var)
	if strType == "table" then return rawget(var,"MetaName") or "table" end
	return strType
end
--[[
local PhoenixErrors = {}
local function PcallHandle(bOk,...)

end
function call(func,...)
	if _type(func) == "function" then
	
	else
		table.insert(PhoenixErrors,"First argument for <call> should be a function!")
	end
end
]]
--[[ Doesn't work, it wants to change locals and it needs a local to work or something
function localise(...)
	for k, v in pairs({...}) do
		debug.setlocal(2,v,rawget(_G,v))
	end
end
]]

local function HandleVarArg(bOk,...)
	if bOk then
		return ...
	end
	ErrorNoHalt("Internal metamethod '__unpack' in object ["..tostring(obj).."] failed : '"..tostring(({...})[1]).."'\n")
end
function unpack(obj)
	local meta = getmetatable(obj)
	if meta then
		local func = meta.__unpack
		if _type(func) == "function" then
			return HandleVarArg(pcall(func,obj))
		end
	elseif type(obj) == "table" then
		return _unpack(obj)
	else
		ErrorNoHalt("Could unpack object : '"..tostring(obj).."'\n")
	end
end

--For copying non-primitive data types like tables, vectors, angles, phoenix pseudo-objects
local ignoreCopy = {["function"] = true,["string"]=true,["number"]=true,["boolean"]=true}
function copy(var)
	local strType = _type(var)
	if ignoreCopy[strType] then return var end
	local m_table = getmetatable(var)
	if m_table and _type(m_table.__copy) == "function" then
		local bOk, valReturn = pcall(m_table.__copy,var)
		if not bOk then
			error(2,"Object copy failed : '"..tostring(valReturn).."'")
		end
		return valReturn
	elseif strType == "table" then --Real table or phoenix pseudo-objects
		local bOk, valReturn = pcall(table.Copy,var)
		if not bOk then
			error(2,"Table copy failed : '"..tostring(valReturn).."'")
		end
		return valReturn
	end
	return var
end
getmetatable(Vector(0,0,0)).__copy = function (vec)	return Vector(vec.x,vec.y,vec.z) end
getmetatable(Angle(0,0,0)).__copy = function (ang) return Angle(ang.p,ang.y,ang.r) end

--[[
function SET(var,val)
	var = val
end
]]
if CLIENT then
function PhxLibServer() return GetGlobalBool("PhxLibEquipped",false) end
end

--Setup a PhoenixLibrary loader only environment where stuff can be merged but not accessed from outside the library! Put this in !phoenix.lua loaders
--[[
_PHXLIB = {} _PHXLIB.__index = 
]]