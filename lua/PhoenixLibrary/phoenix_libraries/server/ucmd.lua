gamemode.Get('base')["PullUcmdData"] = function () end
SetGlobalBool("ucmd_networking",true)
module("ucmd",package.seeall)

local KEY_HIJACK = {
	IN_WEAPON1,
	IN_WEAPON2,
	IN_BULLRUSH
}

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

local ret, i
local function Hex2Bin(s)
	ret = ""
	i = 0
	for i in string.gmatch(s, ".") do
		i = string.lower(i)
		ret = ret..hex2bin[i]
	end
	return ret
end
local n
local function Dec2Bin(s, num)
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

local function ToBits(n,nBits)
	local bits = {}
	for i = 1, nBits do
		bits[i] = n & 2^(i-1)
	end
	return bits
end

--angle roll is a 24bit number
--_G.FIXER = 2^24-1
local function ReadData(cmd)
	local data = cmd:GetViewAngles().r + 2^23
	for i=25, 25+6 do
		if cmd:KeyDown(2^(i-5)) then
			data = data + 2^(i-1)
		end
	end
	return data
end

hook.Add("SetupMove",NAME,function (objPl,move)
	if objPl:GetCurrentCommand() then
		if objPl:GetInfo("~ucmd_networking")=="1" then
			gamemode.Call("PullUcmdData",ReadData(objPl:GetCurrentCommand()))
		end
		move:SetMoveAngles(Angle(objPl:GetCurrentCommand():GetViewAngles().p,objPl:GetCurrentCommand():GetViewAngles().y,0))
	end
end)
