
local META = {} META.__index = META
function META:__newindex(key,val)
	rawset(self,key,val)
	--must sync it next check
end



function FileSyncTable(strName, numSyncRate) --unique by file aswell, maybe?
	local tbl = {}
	setmetatable(tbl,META)
	--some sorta sync system, timed
	return tbl
end