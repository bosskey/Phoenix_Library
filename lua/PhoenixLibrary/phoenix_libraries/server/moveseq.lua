
module("moveseq",package.seeall)
local Moves = {}
local MOVE = {sequence={},Model=""} MOVE.__index = MOVE

function MOVE:GetPos()
	if self.Moving then
		local tDelta = CurTime() - self.StartTime
		return self.sequence[self.CurrentNode].startpos + self.sequence[self.CurrentNode].vecdiff*math.Clamp((tDelta-self.sequence[self.CurrentNode].timeaccum)/self.sequence[self.CurrentNode].time,0,1)
	end
	return self.StartPos
end

function MOVE:AddMove(vecPos,numTime)
	local tAccum = numTime
	for k, v in pairs(self.sequence) do
		tAccum = tAccum + v.time
	end
	local vecLastPos = self.StartPos
	if #self.sequence > 0 then
		vecLastPos = self.sequence[#self.sequence].pos
	end
	table.insert(self.sequence,{pos=vecPos, time=numTime, timeaccum=tAccum, startpos=vecLastPos, vecdiff=vecPos - vecLastPos})
end

function MOVE:Think()
	local tDelta = CurTime() - self.StartTime
	if tDelta > self.sequence[self.CurrentNode].timeaccum then
		if self.CurrentNode == #self.sequence then
			self.Moving = false
		else
			self.CurrentNode = self.CurrentNode + 1
		end
	end
end
hook.Add("Think",NAME,function ()
	for _, move in pairs(Moves) do
		if move.Moving then
			move:Think()
		end
	end
end)

function MOVE:Start()
	self.StartTime = CurTime()
	self.Moving = true
	self.CurrentNode = 1
	umsg.Start("MoveSeqNW_Start",0)
		umsg.Short(self.Index)
		umsg.Float(self.StartTime)
		umsg.Short(#self.sequence)
		for k, v in pairs(self.sequence) do
			umsg.Vector(v.pos)
			umsg.Float(v.time)
		end
	umsg.End()
end

function MOVE:Stop()
	self.Moving = false
	self.CurrentNode = 1
	umsg.Start("MoveSeqNW_Stop",0)
		umsg.Short(self.Index)
	umsg.End()
end

function Create(strModel,vecPos)
	local objNew = {}
	setmetatable(objNew,MOVE)
	objNew.Model = strModel
	objNew.StartPos = vecPos
	objNew.Index = table.insert(Moves,objNew)
	umsg.Start("MoveSeqNW_Create",0)
		umsg.String(strModel)
		umsg.Vector(vecPos)
	umsg.End()
	return objNew
end