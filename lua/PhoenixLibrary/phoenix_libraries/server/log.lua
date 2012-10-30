--[[
module("log",package.seeall)
local strFilePrefix = "PhoenixLibrary/logs/sv_"
local strCurDay = os.date("%d")
local clkTimeStart = tonumber(os.time()) --find epoch time start, so we can centralize the file with time offsets
local strLogDate = os.date("%m_%d_%y")
if file.Exists(strFilePrefix..strLogDate..".txt") then
	local strFile = file.Read(strFilePrefix..strLogDate..".txt")
	local timeStart = tonumber(string.Explode('\n',strFile)[1])
	if 
end
local function GetTimeStamp()
	return tonumber(os.time()) - clkTimeStart
end
local function AddLog(strLine)
	local curDay = os.date("%d")
	if curDay ~= strCurDay then
	file.Write(strFilePrefix..os.date("%m_%d_%y")..".txt")
end
]]