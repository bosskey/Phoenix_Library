gamemode.Get('base')["PushUcmdData"]=function () end --return a number which is 32 bit
module("ucmd",package.seeall)

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
	s = Hex2Bin(string.format("%x", tostring(s)))
	while string.len(s) < n do
		s = "0"..s
	end
	return s
end

local function ParseBitsToString(tblBits)
	local str = ""
	for k, v in pairs(tblBits) do
		str=str..(v and "1" or "0")
	end
	return string.sub(str,1,#tblBits - #tblBits%8)..string.sub(str,-(#tblBits%8))..string.rep("0",(#tblBits%8!=0 and 8-#tblBits%8 or 0))
end

local function ParseBitsToBytes(strBits)
	local str = ""
	for i=1, string.len(strBits), 8 do --could do len%8 as end var for optimization and removal of if statement
		str = str..string.char(tonumber(string.sub(strBits,i,i+7),2) or 0)
	end
	return str
end

local cvar_on = CreateClientConVar("~ucmd_networking","1",false,true)
--[[
hook.Add("CreateMove",NAME,function (cmd)
	if cvar_on:GetBool() and GetGlobalBool("ucmd_networking",false) then --so we dont fuck up phoenixlib clients ( who run it in addons) on other servers
		cmd:SetViewAngles(EncodeViewAngle(cmd:GetViewAngles()))
		return true
	end
end)]]

local function EncodeViewAngle(ang,data)
	--24 bits per cmd
	return Angle(math.NormalizeAngle(ang.p),math.NormalizeAngle(ang.y),data - 2^23)
end

local function ToBits(n,nBits)
	local bits = {}
	for i = 1, nBits do
		bits[i] = n & 2^(i-1)
	end
	return bits
end

local oldCall = hook.Call
function hook.Call(strHook,gm,...)
	if GetGlobalBool("ucmd_networking",false) then
		if strHook=="CalcView" and cvar_on:GetBool() then
			(select(3,...)).r = 0 --get rid of the roll when calcview is called
		elseif strHook=="CreateMove" then
			oldCall(strHook,gm,...)
			local cmd = (...)
			local code = gamemode.Call("PushUcmdData")
			--so we dont fuck up phoenixlib clients ( who run it in addons) on other servers
			if cvar_on:GetBool() and type(code)=="number" then
				local bin = ToBits(code,24+6)
				local angr, buttonCode = 0, cmd:GetButtons()
				for i=1, 24 do
					angr = angr + bin[i]
				end
				for i=25, 24+6 do
					if bin[i] ~= 0 then buttonCode = buttonCode + 2^(i-5) end
				end
				--print('sending = '..tostring(angr))
				cmd:SetViewAngles(EncodeViewAngle(cmd:GetViewAngles(),angr))
				cmd:SetButtons(buttonCode)
			else
				cmd:SetViewAngles(Angle(cmd:GetViewAngles().p,cmd:GetViewAngles().y,0))
			end
			return true
		end
	end
	return oldCall(strHook,gm,...)
end

hook.Add("Move",NAME,function (objPl,move)
	--if not cvar_on:GetBool() then return end
	if not GetGlobalBool("ucmd_networking",false) then return end
	local cmd = objPl:GetCurrentCommand()
	if cmd then
		local ang = cmd:GetViewAngles()
		move:SetMoveAngles(Angle(ang.p,ang.y,0))
	end
end)
