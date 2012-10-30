
/*
	PRE-CONCEPTION : So the thought occurred to me that making a debugger OBJECT would be supremely more useful than manual function calls from a debugger library...so here you go.
	
	DEFINITION : This debugger object is meant to piggyback on any object of any type and log all variable requests and variable assignments aswell as all arithmetic and function calls off the object.
		The main use for this is to reload a current script and have AttachDebugger(<the object>) added to the program right after <the object> is instantiated.
		This will tell us where exactly errors are occurring and what happened leading up to the error.
		!!! - This is not actually writing anything into the original object, it is merely encapsulating it and then used in place of just putting the vanilla object in a block of code
		
	TODO : possibly limit rawget from accessing DEBUG object or encapsulated object while encapsulated object is being debugged, also to log the access
	TODO: FINISH _call
*/

local DEBUG = {} DEBUG.__index = DEBUG

local function Log(self,str)
	local tblLog = rawget(self,"__log")
	rawset(tblLog,#tblLog + 1,str)
end

function DEBUG:__index(key)
	if type(key) == "string" and key == "MetaName" then --Asking for objects type, return the encapsulated object's type
		Log(self,"obj type accessed")
		return rawget(self,"__type")
	end
	local obj = rawget(self,"__object")
	if type(obj.__index) == 'function' then
		local bOk, valReturn = pcall(obj.__index,obj,key)
		if bOk then Log(self,"obj["..tostring(key).."] accessed as "..tostring(valReturn)) return valReturn end
		Log(self,"error while accessing '"..tostring(key).."' : "..tostring(valReturn))
		return nil
	end
	local val = rawget(obj,key)
	Log(self,"obj["..tostring(key).."] accessed as "..tostring(val))
	return val
end

function DEBUG:__newindex(key,val)
	local obj = rawget(self,"__object")
	if type(obj.__newindex) == 'function' then
		local bOk, valReturn = pcall(obj.__newindex,obj,key,val)
		if not bOk then
			Log(self,"error while modifying : "..tostring(valReturn))
		end
	end
	rawset(obj,key,val)
	if type(key) == "string" then
		Log(self,"obj['"..key.."'] modified to "..tostring(val))
	else
		Log(self,"obj["..tostring(key).."] modified to "..tostring(val))
	end
end

function DEBUG:__eq(v)
	local obj = rawget(self,"__object")
	if type(obj.__eq) == "function" then
		local bOk, valReturn = pcall(obj.__eq,obj,v)
		if bOk then 
			Log(self,"obj == "..tostring(v).." : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"obj == "..tostring(v).." : failed")
	return false
end

function DEBUG:__lt(v)
	local obj = rawget(self,"__object")
	if type(obj.__lt) == "function" then
		local bOk, valReturn = pcall(obj.__lt,obj,v)
		if bOk then 
			Log(self,"obj < "..tostring(v).." : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"obj < "..tostring(v).." : failed")
	return false
end

function DEBUG:__mul(v)
	local obj = rawget(self,"__object")
	if type(obj.__mul) == "function" then
		local bOk, valReturn = pcall(obj.__mul,obj,v)
		if bOk then 
			Log(self,"obj * "..tostring(v).." : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"obj * "..tostring(v).." : failed")
	return nil
end

function DEBUG:__div(v)
	local obj = rawget(self,"__object")
	if type(obj.__div) == "function" then
		local bOk, valReturn = pcall(obj.__div,obj,v)
		if bOk then 
			Log(self,"obj / "..tostring(v).." : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"obj / "..tostring(v).." : failed")
	return nil
end

function DEBUG:__pow(v)
	local obj = rawget(self,"__object")
	if type(obj.__pow) == "function" then
		local bOk, valReturn = pcall(obj.__pow,obj,v)
		if bOk then 
			Log(self,"obj ^ "..tostring(v).." : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"obj ^ "..tostring(v).." : failed")
	return nil
end

function DEBUG:__add(v)
	local obj = rawget(self,"__object")
	if type(obj.__add) == "function" then
		local bOk, valReturn = pcall(obj.__add,obj,v)
		if bOk then 
			Log(self,"obj + "..tostring(v).." : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"obj + "..tostring(v).." : failed")
	return nil
end

function DEBUG:__sub(v)
	local obj = rawget(self,"__object")
	if type(obj.__sub) == "function" then
		local bOk, valReturn = pcall(obj.__sub,obj,v)
		if bOk then 
			Log(self,"obj - "..tostring(v).." : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"obj - "..tostring(v).." : failed")
	return nil
end

function DEBUG:__concat(v)
	local obj = rawget(self,"__object")
	if type(obj.__concat) == "function" then
		local bOk, valReturn = pcall(obj.__concat,obj,v)
		if bOk then 
			Log(self,"obj .. "..tostring(v).." : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"obj .. "..tostring(v).." : failed")
	return nil
end

function DEBUG:__tostring()
	local obj = rawget(self,"__object")
	if type(obj.__tostring) == "function" then
		local bOk, valReturn = pcall(obj.__tostring,obj,v)
		if bOk then 
			Log(self,"obj tostring : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"obj tostring : failed")
	return nil
end
function DEBUG:__mod(v)
	local obj = rawget(self,"__object")
	if type(obj.__mod) == "function" then
		local bOk, valReturn = pcall(obj.__mod,obj,v)
		if bOk then
			Log(self,"obj % "..tostring(v).." : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"obj % "..tostring(v).." : failed")
	return nil
end
function DEBUG:__unm()
	local obj = rawget(self,"__object")
	if type(obj.__unm) == "function" then
		local bOk, valReturn = pcall(obj.__unm,obj,v)
		if bOk then
			Log(self,"-obj : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"-obj : failed")
	return nil
end
function DEBUG:__call(func,...)
	if type(func) == "function" then 
		local bOk, valReturn = pcall(func,...)
		if bOk then
			Log(self,"obj.func("..tostring(...)..") : "..tostring(valReturn))
			return valReturn
		end
	end
	Log(self,"obj.func("..tostring(...)..") : failed")
	return nil
end

debug.attach = function (obj)
	local objDebug = {}
	objDebug.__type = type(obj)
	objDebug.MetaName = objDebug.__type
	objDebug.__object = obj
	objDebug.__log = {}
	setmetatable(objDebug,DEBUG)
	return objDebug
end

debug.detach = function (objDebug)
	local obj, tblLog = rawget(objDebug,"__object"), rawget(objDebug,"__log")
	return obj, tblLog
end
