module("env",package.seeall)
local Data = {} --Store gas spills and other things
local Event = {}
local Attribute = {
	"Ignitor",
	"Flammable"
}

function IGNITOR_TRACE(vecOrigin,vecRay)
	local tr = util.TraceLine({start=vecOrigin,endpos=vecOrigin+vecRay})
	if tr.Hit then
		local vecPos = tr.HitPos
		for k, v in pairs(Data) do
			
		end
	end
end

function Do(strEvent,...)
	if Event[strEvent] then
		local func = Event[strEvent].callback
		if type(func) == "function" then
			local bOk, valReturn = pcall(func,...)
			if not bOk then
				LibErrorHalt(valReturn)
			end
		end
	end
end

function RegisterEvent(strName,tblData,funcCallback)
	Event[strName] = {data=tblData,callback=funcCallback}
end