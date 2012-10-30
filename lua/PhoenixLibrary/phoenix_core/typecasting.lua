
boolean = {}
boolean.__index = boolean
local function conv2bool(v)
	local strType = type(key)
	if strType == "nil" then return false end
	if strType == "number" then return key ~= 0 end
	return true
end
function boolean:__index(key) return conv2bool(key) end
function boolean:__newindex() end
function boolean:__mul(v) return conv2bool(v) end

number = {}
number.__index = number
local function conv2num(v)
	local strType = type(key)
	if strType == 'nil' then return 0 end
	if strType == 'number' then return key end
	if strType == 'string' then return tonumber(key) or 0 end
	if strType == 'boolean' and v then return 1 end
	return 0
end
function number:__index(key) return conv2num(key) end
function number:__newindex() end
function number:__mul(v) return conv2num(v) end

local function conv2str(v)
	local strType = type(v)
	if strType == 'nil' then return '' end
	if strType == 'number' then return tostring(v) or '0' end
	if strType == 'string' then return v end
	local meta = getmetatable(v)
	if meta and type(meta.__tostring) == 'function' then
		local bOk, valReturn = pcall(meta.__tostring,v)
		if bOk and type(valReturn) == 'string' then return valReturn end
	end
	return ''
end
string.__mul = function (t, v) return conv2str(v) end
