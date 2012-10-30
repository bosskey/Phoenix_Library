--[[
purpose of this meta object is to create a file caching table that manages persistant data automatically.
]]
--[[
	- Add support for timed caching
	- Add support for immediate caching
	- Add support for Reset TableFile cache (redo it)
]]
local tblFileCacheTick = {}
local tblFileCacheTimed = {}
local tblFileCacheEvent = {} -- when a gamemode hook calls
hook.Add("Think",NAME,function ()
	for k, v in pairs(tblFileCacheTick) do
		if v.HasChanged then
			--overwrite file and save table (optimized, not shitty fucking tokeyvalues ffs)
		end
	end
end)

local META = {}
function META:__index(key)
	return rawget(self,key)
end

function META:__newindex(key,val)
	
end

function META:__tostring()
	
end
/*
function META:__call() --? params
	
end*/