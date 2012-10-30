
local TYPE_NUMBER = 1
local TYPE_NUMBERS = 2
local TYPE_CHAR = 3
local TYPE_STRING = 4
local TRANSMIT_START = 1
local TRANSMIT_ACTIVE = 2
local TRANSMIT_END = 3
local ASCII_SHIFT = 27
local STRING_MAXLEN = 12 --TO BE TESTED

local Commands = {}

local function RunCommand(objPl,numID,data)
	local func = Commands[numID]
	if type(func) == "function" then
		func(objPl,numID,data)
	end
end

function AddCommand(numID,funcCallback)
	Commands[numID] = funcCallback
end

local function FinishMessage(objPl)
	if objPl.CurrentMsg.type == TYPE_NUMBERS then
		RunCommand(objPl,objPl.CurrentMsg.id,objPl.CurrentMsg.data)
	elseif objPl.CurrentMsg.type == TYPE_STRING then
		RunCommand(objPl,objPl.CurrentMsg.id,math.CompactBytesToString(table.ConcatNumbers(objPl.CurrentMsg.data)))
	end
end

local function NewMessage(objPl,ID,Data)
	if Type == TYPE_NUMBER then
		RunCommand(objPl,ID,Data)
	elseif Type == TYPE_NUMBERS then
		objPl.CurrentMsg = {id=ID,type=Type,data = {Data}}
		objPl.ReceivingMsg = true
	elseif Type == TYPE_CHAR then
		RunCommand(objPl,ID,string.char(Data))
	elseif Type == TYPE_STRING then
		objPl.CurrentMsg = {id=ID,type=Type,data = {Data}}
		objPl.ReceivingMsg = true
	end
end



hook.Add("PlayerInitialSpawn","SetupUserCmdNetworking",function (objPl)
	objPl.ReceivingMsg = false
	objPl.CurrentMsg = nil
	objPl.StatusMsg = nil --might remove this
end)

--You may need to run it in a think or something
local function DoRCV(objPl,move)
	local cmd = objPl:GetCurrentCommand()
	local angCmd = move:GetMoveAngles()
	if angCmd.r ~= 0 then
		print("UCMD data being recvd:"..tostring(angCmd.r))
		local angAim = Angle(angCmd.p,angCmd.y,0)
		local strCmd = tostring(angCmd.r) --Cant use math, I would if I could (precision problems)
		local sep = string.Explode(".",strCmd)
		local Data = tonumber(sep[1])
		local Type = tonumber(string.sub(sep[2],1,1))
		local Status = tonumber(string.sub(sep[2],2,2))
		local ID = tonumber(string.sub(sep[2],3))
		if objPl.ReceivingMsg then
			if objPl.CurrentMsg.id == ID then
				table.insert(objPl.CurrentMsg.data,Data)
				if Status == TRANSMIT_END then
					FinishMessage(objPl)
					objPl.ReceivingMsg = false
				end
			else
				--FinishMessage(objPl)
				--objPl.ReceivingMsg = false
				ErrorNoHalt("UserCmdNet Error : Received id "..tostring(ID).." message instead of current id "..tostring(objPl.CurrentMsg.id))
			end
		else
			NewMessage(objPl,ID,Data)
		end
	elseif objPl.ReceivingMsg then
		FinishMessage(objPl)
		objPl.ReceivingMsg = false
	end
end

--[[
hook.Add("Tick","!ReceiveCommands",function ()
	for k, v in pairs(player.GetAll()) do
		DoRCV(v)
	end
end)
]]
UCMD_NETWORKING_DISABLE = true
hook.Add("SetupMove","!ReceiveCommands",function (objPl, move)
	if UCMD_NETWORKING_DISABLE then return end
	DoRCV(objPl,move)
end)
