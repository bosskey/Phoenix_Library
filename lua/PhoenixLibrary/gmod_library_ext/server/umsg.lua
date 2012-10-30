--[[ NOTE:
	- smallest usermessage is one with an id of '' unpooled. very sneaky :P but it pools automatically at 5 calls

]]

local MAX_SIZE = 255 --really its 255
--wtf bools????
local tblSizes = {
	["char"] = 1,
	["short"] = 2,
	["long"] = 4,
	["float"] = 4,
	["bool"] = 1/8
}

local counter = nil
local strID = nil

--now you better realize that after 5 calls using the same string will automatically pool that string,
--umsg.PoolString seems to be ineffective...wtfzzz
--so you should usually poolID's just to be safe...that way I can properly assign accuracies
function umsg.SizeCheck(tblData,bIsPooledID) --does not have any way to know if a string like umsg.String is pooled, so bug off
	local n = counter+0
	if bIsPooledID then
		n = n + 2
	else
		n = n + 1 + string.len(strID)
	end
	for k, v in pairs(tblData) do
		if type(v) == "number" then --if its a number, its the length of a string we added
			n = n + 1 + v
		elseif type(v) == "string" then
			n = n + (tblSizes[v] or 0)
		end
	end
	print('n = '..n)
	return n <= MAX_SIZE
end

local oldStart = umsg.Start
function umsg.Start(id,rf)
	counter = 1 --durp cuz umsg sends 1 byte to say its a usermessage? :P
	strID = id
	local bOk, valReturn = pcall(oldStart,id,rf)
	if not bOk then
		error(tostring(valReturn),2)
	end
end

local oldEnd = umsg.End
function umsg.End()
	counter = nil
	strID = nil
	local bOk, valReturn = pcall(oldEnd)
	if not bOk then
		error(tostring(valReturn),2)
	end
end
local oldBool = oldBool or umsg.Bool	function umsg.Bool(v) counter = counter + tblSizes.bool oldBool(v) end
local oldChar = oldChar or umsg.Char	function umsg.Char(v) counter = counter + tblSizes.char oldChar(v) end
local oldShort = oldShort or umsg.Short	function umsg.Short(v) counter = counter + tblSizes.short oldShort(v) end
local oldLong = oldLong or umsg.Long	function umsg.Long(v) counter = counter + tblSizes.long oldLong(v) end
local oldFloat = oldFloat or umsg.Float	function umsg.Float(v) counter = counter + tblSizes.float oldFloat(v) end
local oldString = oldString or umsg.String	function umsg.String(v) counter = counter + 1 + string.len(v) oldString(v) end

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
	local n = num or 0
	s = string.format("%x", tostring(s))
	s = Hex2Bin(s)
	while string.len(s) < n do
		s = '0'..s
	end
	return s
end
--signed or unsigned? that is the question!
function umsg.BitNumber(n,nBits, bSigned, nFloat) -- nBits must be in power of 2 format for obvious reasons in math dont be stupid and put 1,1, you're just dumb then.
	n = ((n or 0) + ((bSigned and 2^(nBits-1)) or 0))*10^(nFloat or 0)
	nBits = math.max(nBits,4)
	local s=Dec2Bin(n,nBits)
	for i=nBits, 1, -1 do
		umsg.Bool(string.sub(s,i,i)=="1")
	end
end

function umsg.ByteString(str)
	if string.len(str)>254 then error("length of umsg ByteString exceeds maximum usermessage size of 255 bytes.") end --account for 1 byte of length data
	umsg.Char(string.char(string.len(str)))
	for i=1, string.len(str) do
		umsg.Char(string.sub(str,i,i))
	end
end

local function FormatStringToLiteral(str)
	if string.len(str)>254 then error("length of umsg ByteString exceeds maximum usermessage size of 255 bytes.") end
	local nstr = ''
	for i=1, string.len(str) do
		local ascii = string.byte(string.sub(str,i,i))
		if ascii > 31 and ascii < 127 then
			nstr=nstr..string.char(ascii)
		end
	end
	return nstr
end

function umsg.LiteralString(str)
	local nstr = FormatStringToLiteral(str)
	umsg.Char(string.char(string.len(nstr)))
	for i=1, string.len(nstr) do
		umsg.BitNumber(string.byte(string.sub(nstr,i,i))-32,7)
	end
end

umsg.Color = function (col, bNoAlpha)
	umsg.Char(string.char(math.Clamp(col.r,0,255)))
	umsg.Char(string.char(math.Clamp(col.g,0,255)))
	umsg.Char(string.char(math.Clamp(col.b,0,255)))
	if bNoAlpha then return end
	umsg.Char(string.char(math.Clamp(col.a,0,255)))
end

--[[
umsg.LuaNumber = function (num)

end]]
local type = _type or __type or type --_type or __type are phxlib internals, and so they are the pure function calls to the original type function
if type(usermessage) ~= "table" or type(umsg) ~= "table" then return end
local ObjectConvert = {}
usermessage.RegisterObject = function (strMetaName,funcEncode)
	ObjectConvert[strMetaName] = funcEncode
end

umsg.Object = function (obj) --maybe I'll hijack the umsg table and turn it into a metatable then use the index function callback to make it dynamically run these operations.
	local strType = type(obj)
	if strType == "table" and type(obj.MetaName) == "string" then
		local funcEncode = ObjectTranslate[obj.MetaName]
		if type(funcEncode) == "function" then
			local bOk, val = pcall(funcEncode,obj)
			if bOk then
				return true
			else
				LibError("'"..obj.MetaName.."' failed '"..tostring(val).."'")
			end
		else
			LibError("'"..obj.MetaName.."' is not registered")
		end
	end
	return nil
end
