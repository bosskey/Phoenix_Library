//Predefined movement (linear, others)

module("moveseq",package.seeall)
local Moves, CMoves = {}, {}
local MOVE = {sequence={}} MOVE.__index = MOVE

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

function MOVE:Think() --Used to update the node tweening
	local tDelta = CurTime() - self.StartTime
	if tDelta > self.sequence[self.CurrentNode].timeaccum then
		if self.CurrentNode == #self.sequence then
			self.Moving = false
		else
			self.CurrentNode = self.CurrentNode + 1
		end
	end
	self.Entity:SetPos(self.sequence[self.CurrentNode].startpos + self.sequence[self.CurrentNode].vecdiff*math.Clamp((tDelta-self.sequence[self.CurrentNode].timeaccum)/self.sequence[self.CurrentNode].time,0,1))
end
local ToRemove = {}
hook.Add("Think",NAME,function ()
	if #ToRemove then
		for _, v in pairs(ToRemove) do
			if v.client then
				CMoves[v.index] = nil
			else
				Moves[v.index] = nil
			end
		end
	end
	for _, move in pairs(Moves) do
		if move.Moving then
			move:Think()
		end
	end
	for _, move in pairs(CMoves) do
		if move.Moving then
			move:Think()
		end
	end
end)
function MOVE:Remove()
	table.insert(ToRemove,{index=self.Index,client=self.ClientOnly})
end

function MOVE:Start()
	self.StartTime = CurTime()
	self.Moving = true
	self.CurrentNode = 1
end
function MOVE:Stop() self.Moving = false self.CurrentNode = 1 end

function Create(strModel,vecPos)
	local objNew = {}
	setmetatable(objNew,MOVE)
	objNew.Model = strModel
	objNew.Entity = ClientsideModel(strModel,RENDERGROUP_OPAQUE)
	objNew.StartPos = vecPos
	objNew.Index = table.insert(CMoves,objNew) --Adds it to CLIENTMoves instead
	objNew.ClientOnly = true
	return objNew
end

usermessage.Hook("MoveSeqNW_Create",function (um)
	local objMove = {}
	setmetatable(objMove,MOVE)
	objMove.Index = table.insert(Moves,objMove)
	objMove.Model = um:ReadString()
	objMove.StartPos = um:ReadVector()
	objMove.Entity = ClientsideModel(objMove.Model,RENDERGROUP_OPAQUE)
end)

usermessage.Hook("MoveSeqNW_Start",function (um)
	local objMove = Moves[um:ReadShort()]
	objMove.StartTime = um:ReadFloat()
	local numNodes = um:ReadShort()
	for i=1, numNodes do
		objMove:AddMove(um:ReadVector(),um:ReadFloat())
	end
	self.Moving = true
	self.CurrentNode = 1
end)

usermessage.Hook("MoveSeqNW_Stop",function (um)
	local objMove = Moves[um:ReadShort()]
	objMove.Moving = false
	objMove.CurrentNode = 1
end)
