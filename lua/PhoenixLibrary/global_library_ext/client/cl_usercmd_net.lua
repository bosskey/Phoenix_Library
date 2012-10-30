--[[
local TYPE_NUMBER = 1
local TYPE_NUMBERS = 2
local TYPE_CHAR = 3
local TYPE_STRING = 4
local TRANSMIT_START = 1
local TRANSMIT_ACTIVE = 2
local TRANSMIT_END = 3
local ASCII_SHIFT = 27
local STRING_MAXLEN = 12 --TO BE TESTED

local SetViewAngles = _R["CUserCmd"].SetViewAngles
local GetViewAngles = _R["CUserCmd"].GetViewAngles
local QueuedMsgList = {}
local SendingMsg = false
local CurrentMsg = nil
local StatusMsg = nil

local function StringToCompactBytes(strMessage)
	local tbl = {}
	for i=1, string.len(strMessage) do
		tbl[i] = tostring(string.byte(string.sub(strMessage,i,1)) - ASCII_SHIFT)
	end
	return tonumber(table.concat(tbl))
end

function SendCommandNumber(numID,numData)
	local tbl = {id=numID,type=TYPE_NUMBER,data=numData}
	table.insert(QueuedMsgList,tbl)
end

function SendCommandNumbers(numID,...)
	if select("#",...) == 1 then
		SendCommandNumber(numID,(...))
	else
		local tbl = {id=numID,type=TYPE_NUMBERS,data={...},step=1}
		table.insert(QueuedMsgList,tbl)
	end
end

function SendCommandChar(numID,chData)
	local tbl = {id=numID,type=TYPE_CHAR,data=string.byte(chData)}
	table.insert(QueuedMsgList,tbl)
end

function SendCommandString(numID,strMessage)
	if string.len(strMessage) == 1 then
		SendCommandChar(numID,strMessage)
	else
		local tbl = {id=numID,type=TYPE_STRING,data=math.CompactBytesToTableChunks(string.StringToCompactBytes(strMessage),STRING_MAXLEN),step=1}
		table.insert(QueuedMsgList,tbl)
	end
end

hook.Add("CreateMove","!SendCommands",function (cmd)
	local qAng = GetViewAngles(cmd)
	qAng.r = 0
	SetViewAngles(cmd,qAng)
	if not SendingMsg and #QueuedMsgList > 0 then
		SendingMsg = true
		StatusMsg = TRANSMIT_START
		CurrentMsg = table.remove(QueuedMsgList,1)
	end
	if SendingMsg and type(CurrentMsg) == "table" then
		Msg("Sending packet[ ")
		local angAim = GetViewAngles(cmd)
		angAim.r = 0
		local angCmd = angAim
		local data = {0,0,0}
		local numID, numType, numData = 0, 0, 0
		if StatusMsg == TRANSMIT_START then
			if CurrentMsg.type == TYPE_NUMBER then
				numID = CurrentMsg.id
				numType = TYPE_NUMBER
				numData = CurrentMsg.data
				StatusMsg = TRANSMIT_END
			elseif CurrentMsg.type == TYPE_CHAR then
				numID = CurrentMsg.id
				numType = TYPE_CHAR
				numData = CurrentMsg.data
				StatusMsg = TRANSMIT_END
			elseif CurrentMsg.type == TYPE_NUMBERS then
				numID = CurrentMsg.id
				numType = TYPE_NUMBERS
				numData = CurrentMsg.data[1]
				CurrentMsg.step = 1
				StatusMsg = TRANSMIT_ACTIVE
			elseif CurrentMsg.type == TYPE_STRING then
				numID = CurrentMsg.id
				numType = TYPE_STRING
				numData = CurrentMsg.data[1]
				if table.getn(CurrentMsg.data) > 1 then
					CurrentMsg.step = 1
					StatusMsg = TRANSMIT_ACTIVE
				else
					StatusMsg = TRANSMIT_END
				end
			end
		elseif StatusMsg == TRANSMIT_ACTIVE then
			numID = CurrentMsg.id
			numType = CurrentMsg.type
			CurrentMsg.step = CurrentMsg.step + 1
			if CurrentMsg.step > table.getn(CurrentMsg.data) then
				StatusMsg = TRANSMIT_END
			else
				numData = CurrentMsg.data[CurrentMsg.step]
			end
		end
		angCmd.r = tonumber(tostring(numData).."."..tostring(numType)..tostring(StatusMsg)..tostring(numID))
		Msg(tostring(angCmd.r).." ]\n")
		SetViewAngles(cmd,angCmd)
		if StatusMsg == TRANSMIT_END then
			SendingMsg = false
			Msg("All packets sent\n")
		end
		return true
	end
end)
]]