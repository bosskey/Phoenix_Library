
function CreateMetaTable(strMetaName,bInstantiate) --Maybe add the metatable to _R
	if type(strMetaName) ~= "string" then strMetaName = 'undefined' end
	local tblNew = {MetaName=strMetaName}
	tblNew.__index = tblNew
	function tblNew:__index(tbl,key)
		if type(key) == "string" then
			if key == "MetaName" then return strMetaName end
			return rawget(tbl,key)
		end
	end
	function tblNew:__newindex(tbl,key,val)
		if not(type(key) == "string" and key == "MetaName") then
			rawset(tbl,key,val)
		end
	end
	if bInstantiate then setmetatable(tblNew,tblNew) end
	return tblNew
end

-- TODO: Verify that this all works (MetaIndex and such)
function index(var)
	local strType = type(var)
	if strType == "table" then return rawget(var,"MetaIndex") end
	return -1
end
