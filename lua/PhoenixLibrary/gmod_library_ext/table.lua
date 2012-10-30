table.random = function (t, s, e)
	if type(t) ~= "table" then return nil end
	s = s or 1
	e = e or #t
	if s > e then
		return nil
	else
		return t[math.random(s,e)]
	end
end

table.removex = function (t,index) --useful for tables with non-integer indexes
	local val = t[index]
	t[index] = nil
	return val
end

--whatever inspiration brought me to do this should die. (its actually rather good I guess, but ummm wtf?)
table.removehack = function (t,index)
	local tblNew = {}
	for k, v in pairs(t) do
		if type(k) ~= type(index) or k ~= index then
			tblNew[k] = v
		end
	end
	t = tblNew
end

table.GetValueIndex = function (t,val)
	for k, v in pairs(t) do
		if v == val then
			return k
		end
	end
	return nil
end

table.ConcatNumbers = function (t)
	local str = ""
	for k, v in pairs(t) do
		str = str..tostring(v)
	end
	return tonumber(str)
end
table.ConcatNums = table.ConcatNumbers

table.AddMult = function (...) --like table.Add but uses multiple args
	local tbl = {}
	for k, v in pairs({...}) do
		tbl = table.Add(tbl,v)
	end
	return tbl
end

--[[
	* SYNTAX: Protect( table T )
	* DESC: Use this to protect an entire table from being written to but still be able to be read
	* USE: MyScript = MyScript:Protect()
	* RETURNS: table
]]

local PROTECTED = {}
PROTECTED.__index = PROTECTED
PROTECTED.__newindex = function (t,k,v)
	error("Attempt to change variable '" .. tostring (k) .. "' to " .. tostring (v).." in a protected table", 2 )
end

function table.Protect(tbl)
	setmetatable(tbl,PROTECTED)
end

function table:Protect( )
	return setmetatable( {}, {
		__index = self, __newindex = function ( t, n, v ) error( "attempting to change constant " .. tostring (n) .. " to " .. tostring (v), 2 ) end } )
end
