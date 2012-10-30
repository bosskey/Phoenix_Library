if servermessage then return end
module('servermessage',package.seeall)

local hex2bin = {
	["0"] = "0000",
	["1"] = "0001",
	["2"] = "0010",
	["3"] = "0011",
	["4"] = "0100",
	["5"] = "0101",
	["6"] = "0110",
	["7"] = "0111",
	["8"] = "1000",
	["9"] = "1001",
	["a"] = "1010",
    ["b"] = "1011",
    ["c"] = "1100",
    ["d"] = "1101",
    ["e"] = "1110",
    ["f"] = "1111"
}

local function ParseBitsToString(tblBits)
	local str = ""
	for k, v in pairs(tblBits) do
		str=str..(v and "1" or "0")
	end
	return str
end

local function Hex2Bin(s)
	local ret = ""
	local i = 0
	for i in string.gmatch(s, ".") do
		i = string.lower(i)
		ret = ret..hex2bin[i]
	end
	return ret
end

local function Dec2Bin(s, num)
	local n
	if (num == nil) then
		n = 0
	else
		n = num
	end
	s = string.format("%x", tostring(s))
	s = Hex2Bin(s)
	while string.len(s) < n do
		s = "0"..s
	end
	return s
end

local function FormatByte(strBin)
	return string.reverse(tostring(strBin..string.rep('0',8-string.len(strBin)))) 
end
local function DecodeStream(str)
	local tblBits = {}
	local s = ""
	for i=1, string.len(str) do
		s = Dec2Bin(string.byte(string.sub(str,i,i)),8)
		for j=1, 8 do
			table.insert(tblBits, string.sub(s,j,j)=="1")
		end
	end
	return tblBits
end


local SM_READ = {}

local streams = {}
concommand.Add("\2",function (objPl,strCmd,tblArgs)
	if not objPl or objPl:EntIndex() == 0 then Msg("Console cannot run servermessages...\n") return end
	if streams[objPl] then Msg("Servermessage: "..tostring(objPl).." attempted to start long-stream before previous long-stream finished!\n") return end
	local cmd = tblArgs[1]
	table.remove(tblArgs,1)
	streams[objPl] = {cmd=cmd,data=table.concat(tblArgs,"\0")}
end)

concommand.Add("\3",function (objPl,strCmd,tblArgs)
	if not objPl or objPl:EntIndex() == 0 then Msg("Console cannot run servermessages...\n") return end
	streams[objPl].data=streams[objPl].data.."\n"..table.concat(tblArgs,"\0")
end)

concommand.Add("\4",function (objPl,strCmd,tblArgs)
	if not objPl or objPl:EntIndex() == 0 then Msg("Console cannot run servermessages...\n") return end
	local objNew = {data=DecodeStream(streams[objPl].data.."\n"..table.concat(tblArgs,"\0")),bit=1}
	setmetatable(objNew,SM_READ)
	servermessage.IncomingMessage(streams[objPl].cmd,objPl,objNew)
	streams[objPl] = nil
end)


concommand.Add("\1",function (objPl,strCmd,tblArgs) --all packets pckts[1 to (n-1)] had \n as last char
	if not objPl or objPl:EntIndex() == 0 then Msg("Console cannot run servermessages...\n") return end
	if streams[objPl] then Msg("Servermessage: "..tostring(objPl).." attempted to start single stream before long-stream finished!\n") return end
	local cmd = tblArgs[1]
	table.remove(tblArgs,1)
	local objNew = {data=DecodeStream(table.concat(tblArgs,"\0")),bit=1}
	--print('server = \''..ParseBitsToString(objNew.data)..'\'')
	setmetatable(objNew,SM_READ)
	servermessage.IncomingMessage(cmd,objPl,objNew)
end)

local function frombase255(s)
	local cm, n, c, b = 1, 0
	for d = string.len(s), 1, -1 do
		c = string.sub(s, d, d)
		b = string.byte(c)
		n = n+(b > 10 and b-1 or b)*cm
		cm = cm*254
	end
	return n
end

local tblHooks = {}

SM_READ.__index = SM_READ

local function ReadBits(self,numBits)
	local sBits = ""
	for i=self.bit+numBits-1, self.bit, -1  do
		sBits=sBits..(self.data[i] and "1" or "0")
	end
	self.bit = self.bit + numBits
	return sBits
end
local function CheckOutOfBounds(self)
	if self.bit > table.getn(self.data) then
		error("servermessage: no more data to read. "..tostring(self.bit).."/"..tostring(table.getn(self.data)),3)
	end
end
function SM_READ:ReadBool()
	CheckOutOfBounds(self)
	return ReadBits(self,1)=="1"
end

function SM_READ:ReadString()
	CheckOutOfBounds(self)
	local len = tonumber(ReadBits(self,8),2)
	local str = ""
	for i=1, len do
		str=str..string.char(tonumber(ReadBits(self,8),2))
	end
	return str
end
function SM_READ:ReadUShort()
	CheckOutOfBounds(self)
	return tonumber(ReadBits(self,8*2),2)
end
function SM_READ:ReadShort()
	CheckOutOfBounds(self)
	return tonumber(ReadBits(self,8*2),2) - 2^15 --might be 2^14
end
function SM_READ:ReadULong()
	CheckOutOfBounds(self)
	return tonumber(ReadBits(self,8*4),2)
end
function SM_READ:ReadLong()
	CheckOutOfBounds(self)
	return tonumber(ReadBits(self,8*4),2) - 2^31
end
function SM_READ:ReadChar()
	CheckOutOfBounds(self)
	return string.char(tonumber(ReadBits(self,8),2) or 0)
end
function SM_READ:Reset()
	self.bit = 1
end

function Hook(strName,funcCallback, ...)
	if string.match(strName,"%z") then
		error("servermessage: attempt to hook a name containing embedded null(s).",2)
	end
	if string.match(strName, "\n") then
		error("servermessage: attempt to hook a name containing end line character(s).",2)
	end
	tblHooks[strName] = {callback=funcCallback,args=...}
end

function IncomingMessage(strName,objPl,sm)
	if tblHooks[strName] then
		local bOk, valReturn = pcall(tblHooks[strName].callback,objPl,sm,tblHooks[strName].args)
		if not bOk then
			ErrorNoHalt("servermessage: hook '"..strName.."' failed '"..tostring(valReturn).."'\n")
		end
	else
		Msg("Warning: Unhandled servermessage '"..strName.."'\n")
	end
end
