
-- To easily setup sequences in timers

--Need to add think and fix up pausing

local SEQ = {MetaName="TimerSequence"} SEQ.__index = SEQ
function SEQ:Start() self.LastEvent = 0 self.Active = true self.LastTime = CurTime() end
function SEQ:Stop() self.LastEvent = 0 self.Active = false end
function SEQ:Restart() self.LastEvent = 0 self.Active = true self.LastTime = CurTime() end
function SEQ:Pause() self.Active = false self.LastTime = CurTime() - self.LastTime end
function SEQ:UnPause() self.Active = true self.LastTime = CurTime() - self.LastTime end

function SEQ:AddEvent(numDelay,funcCallback, ...)
	table.insert(self.Events,{delay=numDelay,callback=funcCallback,args=...})
end
function SEQ:AddEvents(tblEvents)
	for k, v in pairs(tblEvents) do
		table.insert(self.Events,{delay=v.delay,callback=v.callback,args=v.args})
	end
end
function SEQ:Clear()
	self.Events = {}
	self.Active = false
end

timer.CreateSequence = function ()
	local objNew = {MetaName="TimerSequence"}
	setmetatable(objNew,SEQ)
	objNew.Active = false
	objNew.LastEvent = 0
	return objNew
end