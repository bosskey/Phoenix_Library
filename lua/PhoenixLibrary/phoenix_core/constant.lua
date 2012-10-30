--[[
	WHAT : PhoenixLibrary constant storing system (for global constants)
	FACT : The constants are not actually stored in _C table, I moved them to a seperate table so it could be efficient in accessing and such.
	NOTE: Just don't set _C to nil...seriously theres a way now to protect against that
	EX: _C.Hello = "CONSTANT NEVER CHANGES AFTER THIS ASSIGNMENT"
]]

local Vars, Count = {}, 0
_C = {MetaName="GlobalConstantList"}
	_C.__index = function (self,key)
		if type(key) == "string" then
			if key == "MetaName" then return "GlobalConstantList" end
			return rawget(Vars,key)
		end
		return nil 
	end
	_C.__newindex = function (self,key,val)
		if type(key) == "string" and rawget(Vars,key) == nil then
			_G[key] = val
			rawset(Vars,key,val)
			Count = Count + 1
		end
	end
	_C.__tostring = function(self)
		local str = 'Constants:'
		for strName, val in pairs(Vars) do
			str=str..'\n'..strName..'='..tostring(val)
		end
		return str
	end
	_C.__len = function (self)
		return Count
	end
setmetatable(_C,_C)

--Lol...yeah
hook.Add("Initialize",NAME,function () if type(_C) ~= "GlobalConstantList" then ErrorNoHalt("WHO THE HELL DELETED THE CONSTANT LIST!\n") end end)
function GetConstants()
	local tbl = {}
	for k, v in pairs(Vars) do
		rawset(tbl,k,v)
	end
	return tbl
end
--Look at overriding _G.__newindex (may be locked though)