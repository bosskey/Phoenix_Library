
module("thread",package.seeall)
local Threads, ACTIVE = {}, false
local THREAD = {MetaName="PseudoThread",Active=false} THREAD.__index = THREAD
function THREAD:Run()
	self.Active = true
end
function THREAD:Stop()
	self.Active = false
end
function THREAD:Remove()
	Threads[self.Index] = nil
	self.Index = nil
	self.Active = nil
end
function THREAD:__tostring()
	return "PseudoThread ["..self.Index.."]"
end

local bOk, valReturn, tStart
local function Activate()
	ACTIVE = true
	hook.Add("Think",NAME,function ()
		for k, v in pairs(Threads) do
			if v.Active then
				tStart = CurTime()
				bOk, valReturn = pcall(v.call,v)
				if bOk then
					if not valReturn then
						v.Active = false
					end
					v.LastThreadTime = CurTime() - tStart
				else
					ErrorNoHalt(tostring(v).." failed : '"..tostring(valReturn).."'\n")
					Threads[k] = nil
				end
			end
		end
	end)
end

function Create(funcCall)
	if not ACTIVE then Activate() end
	local objThread = {call=funcCall}
	setmetatable(objThread,THREAD)
	objThread.Index = table.insert(Threads,objThread)
	return objThread
end
