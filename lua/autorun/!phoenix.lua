--DO hook library override here

math.randomseed(tonumber(os.time()))

--When using random in security-conscious situations (lua weapon-cone calculation), make sure to set up your own randomseed for that run...example
--[[
	math.randomseed(tonumber(os.time()) + tonumber(os.clock())) --Includes CPU usage time as a random seed part --unpredictably good, dangerously cheesy
	<CODE>
	math.randomseed(tonumber(os.time())) --So other code runs on this seed, this line is pretty much not needed...
]]

--Set Variables to _PHX to make them only last through the 
local _PHX = {} --Keep it in phoenixlibrary, so we can cut off access after loading phoenixlibrary
_PHX.__index = _PHX
function _PHX:__index(key)
	return rawget(self,key)
end
function _PHX:__newindex(key,val)
	_G[key] = val
	rawset(self,key,val)
end
_G._PHX = _PHX --Set global _PHX to reference local _PHX table (pseudo-environment for phoenixlibrary)

--TODO: Test loading files in custom environments
/* --Attempted custom load to make _PHX env a little more professional, but I am unsure of syntax/workings of this type of system, so I'll use global settings
function PhoenixInclude(strFile,strName)
	local oldIncludeEnv = getfenv(_G.include) --Probably just _G
	local envPhx = table.Inherit({NAME = strName},_PHX)
	setfenv(_G.include,envPhx)
	include(strFile)
	setfenv(_G.include,oldIncludeEnv)
end
*/