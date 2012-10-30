local RunConsoleCommand = _G.RunConsoleCommand
module("smsg",package.seeall) --bleh

local function largest_mul(n)
	local mul = 1
	while mul*254 < n do
		mul = mul*254
	end
	return mul
end

local function tobase255(n)
	local s, cm, m, c = "", largest_mul(n)
	while cm >= 1 do
		m = math.floor(n/cm)
		n = n-m*cm
		s = s..string.char(m >= 10 and m+1 or m)
		cm = cm/254
	end
	return s
end
local strCurrent = nil
local bytesBuffer = ""
local bitsBuffer = {}

function Start(strName) --TODO: Maybe add [, bLZWCompressed]
	if strCurrent then
		error("smsg: Started a servermessage without ending the last!",2)
	end
	if string.match(strName, "%z") then
		error("smsg: Started servermessage using a name containing embedded null(s).",2)
	end
	if string.match(strName, "\n") then
		error("smsg: Started servermessage using a name containing end line character(s).",2)
	end
	strCurrent = strName
	bytesBuffer = ""
end

local function ParseBitsToString(tblBits)
	local str = ""
	for k, v in pairs(tblBits) do
		str=str..(v and "1" or "0")
	end
	return string.sub(str,1,#tblBits - #tblBits%8)..string.sub(str,-(#tblBits%8))..string.rep("0",((#tblBits%8 == 0 and 0) or 8-#tblBits%8))
end

local function ParseBitsToBytes(strBits)
	local str = ""
	for i=1, string.len(strBits), 8 do --could do len%8 as end var for optimization and removal of if statement
		str = str..string.char(tonumber(string.sub(strBits,i,i+7),2) or 0)
	end
	return str
end
--thanks to JSharpe
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

local function Hex2Bin(s)
	local ret = ''
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
	s = Hex2Bin(string.format("%x", tostring(s)))
	while string.len(s) < n do
		s = "0"..s
	end
	return s
end
--end thanks to JSharpe

local function AppendBinary(strBin)
	for i=string.len(strBin), 1, -1  do
		table.insert(bitsBuffer,string.sub(strBin,i,i)=="1")
	end
end
local function FormatByte(strBin)
	local s = string.reverse(tostring(strBin))
	return s..string.rep('0', 8 - string.len(s) )
end
--TODO make \0 convert to new argument -done
function End()
	if not strCurrent then
		error("smsg: Ended smsg before a servermessage was started.",2)
	end
	local strArg = strCurrent.."\0"..ParseBitsToBytes(ParseBitsToString(bitsBuffer))
	if string.len(strArg) > 123 then
		strCurrent = nil
		error("smsg: Cannot dispatch servermessage larger than 128 bytes!",2)
	end
	if string.find(strArg,"\10") then
		local tbl = string.Explode("\10",strArg)
		RunConsoleCommand("cmd","\2",unpack(string.Explode("\0",tbl[1]))) --say its multiple \n chars, and we need to send multiple commands, so do it faggot
		for i=2, table.getn(tbl)-1 do
			RunConsoleCommand("cmd","\3",unpack(string.Explode("\0",tbl[i]))) --dispatch the cmd
		end
		RunConsoleCommand("cmd","\4",unpack(string.Explode("\0",tbl[#tbl])))
	else
		--print('client = \''..ParseBitsToString(bitsBuffer)..'\'')
		RunConsoleCommand("cmd","\1",unpack(string.Explode("\0",strArg)))
	end
	strCurrent = nil
	bitsBuffer = {}
end
	function Bool(b) --done and working
		table.insert(bitsBuffer,(b and true or false))
	end
	function Char(ch) --done and working
		AppendBinary(Dec2Bin(tostring(string.byte(string.sub(tostring(ch), 1, 1))),8))
	end
	function String(str)
		AppendBinary(Dec2Bin(tostring(string.len(str)),8))
		for i=1, string.len(str) do
			AppendBinary(Dec2Bin(tostring(string.byte(string.sub(str,i,i))),8))
		end
	end
	function Short(num) --done and working
		AppendBinary(Dec2Bin(math.Clamp(tonumber(num) or 0,-(2^15),2^15 - 1)+2^15,16)) --might be 2^14
	end
	function UShort(num)
		AppendBinary(Dec2Bin(math.Clamp(tonumber(num) or 0,0,2^15),16))
	end
	function Long(num)
		AppendBinary(Dec2Bin(math.Clamp(tonumber(num) or 0,-(2^31),2^31 - 1)+2^31,32))
	end
	function ULong(num)
		AppendBinary(Dec2Bin(math.Clamp(tonumber(num) or 0,0,2^31),32))
	end
