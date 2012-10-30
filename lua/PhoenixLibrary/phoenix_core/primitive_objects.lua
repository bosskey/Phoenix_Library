local NULLOBJ = {MetaName="NullObject"} NULLOBJ.__index = NULLOBJ
function NULLOBJ:__index(key) if key == "MetaName" then return "NullObject" end return NULL end
function NULLOBJ:__newindex(key,val) --[[Do nothing, a null object is not meant to store data, lol]] end
function NULLOBJ:__eq(val) return type(val) == type(NULL) end --TODO: reconsider what null's type is
function NULLOBJ:__lt(val) return false end --NULL should always be less than anything, just think about it.
function NULLOBJ:__tostring() return "NullObject" end
function NullObject() local objNew = {} setmetatable(objNew,NULLOBJ) return objNew end

local CHAR = {MetaName = "char"} CHAR.__index = CHAR
function CHAR:__newindex(key,val) end
function CHAR:__eq(v) return type(v) == "Char" and rawget(self,"character") == v end
function CHAR:__tostring() return rawget(self,"character") end
function CHAR:SetValue(char) if type(char) == "string" and string.len(char) < 2 then rawset(self,"character",char) end end
function CHAR:GetValue() return rawget(self,"character") end
function CHAR:__concat(v) return rawget(self,"character")..tostring(v) end
function Char(char) local objNew = {} setmetatable(objNew,CHAR) objNew:SetValue(char) return objNew end

local STRING = {MetaName = "string",Chars={}} STRING.__index = STRING
function STRING:__index(key)
	if type(key) == "number" and key > 0 then
		return rawget(rawget(self,"Chars"),math.Round(key)) --Make it return Char object
	end
	return string[key]
end
function STRING:__newindex(key,val)
	if type(key) == "number" and key > 0 then
		if type(val) == "char" then
			val = val:GetValue()
		elseif type(val) == "string" and string.len(val) > 1 then
			return
		else
			return
		end
		local tblChars = rawget(self,"Chars")
		if key - #tblChars > 1 then --Needs checking possibly (Verify the if statement)
			for i=#tblChars + 1, key - 1 do
				rawset(tblChars,i,' ')
			end
		end
		rawset(tblChars,key,val)
	end
end

function STRING:__tostring() return table.concat(rawget(self,"Chars")) end
function STRING:__concat(v) return tostring(self)..tostring(v) end
STRING.GetValue = STRING.__tostring

function STRING:SetValue(str)
	local tblChars = {}
	for i=1, string.len(str) do
		tblChars[i] = string.sub(str,i,i)
	end
	rawset(self,"Chars",tblChars)
end

function String(str)
	local objNew = {}
	setmetatable(objNew,STRING)
	objNew:SetValue(str)
	return objNew
end
