
local META = {} META.__index = META
function META:__index(k)
	if k=="__func" then return nil end
	return rawget(self,k)
end

function META:__call(...)
	--print("Call ",...)
	local bOk, valReturn = pcall(rawget(self,"__func"),...)
	if not bOk then
		error(3,tostring(valReturn))
	end
	return valReturn
end

function META:__tostring()
	return tostring(rawget(self,"__func"))
end

function META:__newindex(k,v)
	--Do nothing
end

function Function(func)
	local o={__func=func,MetaName="function"}
	setmetatable(o,META)
	return o
end
