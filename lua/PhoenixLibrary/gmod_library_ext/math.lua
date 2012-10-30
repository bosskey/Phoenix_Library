--[[math.AddAbs = function (a,b)
	if a < 0 then
		return a - b
	else
		return a + b
	end
end]]

math.AddUnsigned = function (a,b)
	if a < 0 then
		return a - b
	end
	return a + b
end

math.AddUnsignedClamped = function (a,b)
	if a < 0 then
		return math.min(0,a-b)
	end
	return math.max(0,a+b)
end

--[[
math.AddAbsToZero = function (a,b)
	if a < 0 then
		return math.min(0,a - b)
	else
		return math.max(0,a + b)
	end
end]]

-- Example math.floorAbs( -1.2 ) returns -1
math.floorAbs = function (num) --So you can floor to zero instead of number positivity
	if num < 0 then
		return math.ceil(num)
	end
	return math.floor(num)
end

-- Example math.ceilAbs( -1.2 ) returns -2
math.ceilAbs = function (num)
	if num < 0 then
		return math.floor(num)
	end
	return math.ceil(num)
end

-- Example math.RoundAbs( -1.5 ) returns -2 and math.RoundAbs( -1.2 ) returns -1
math.RoundAbs = function (num)
	if num < 0 then
		return math.ceil(num + 0.5)
	end
	return math.floor(num + 0.5)
end

--accepts any type of matching objects that have __add and __newindex functions with a __div function supporting integers
math.mean = function (...)
	local avg
	for k, v in pairs({...}) do
		if avg then
			avg = avg + v
		else
			avg = v
		end
	end
	return avg/select("#",...)
end

math.mode = function (...)
	local num, data = 0, nil
	local tbl = {}
	for _, v in pairs({...}) do
		if tbl[v] then
			tbl[v] = tbl[v] + 1
		else
			tbl[v] = 1
		end
	end
	local bestval = nil
	local bestnum = 0
	for k, v in pairs(tbl) do
		if v > bestnum then
			bestval = k
			bestnum = v
		end
	end
	return bestval, bestnum
end
math.popular = math.mode

math.median = function(...)
	local min, max, median
	for k, v in pairs({...}) do
		if not min or v < min then
			min = v
		end
		if not max or v > max then
			max = v
		end
	end
	return (max - min)*.5
end

math.single = function (...)
	local tblSingles, tblSinglesReturn = {}, {}
	for _, v in pairs({...}) do
		if not tblSingles[v] then
			tblSingles[v] = true
			table.insert(tblSinglesReturn,v)
		end
	end
	return unpack(tblSinglesReturn)
end

-- Example math.iDigits( 5555.000 ) returns 4
math.iDigits = function (num)
	return math.floor(math.log(math.floor(num))) + 1
end

-- Example math.fDigits( 0.555 ) returns 3
math.fDigits = function (num)
	local f = math.abs(num - math.floor(num))
	if f == 0 then return 0 end
	local c = 0
	while f > 0 do
		f = f*10
		f = f - math.floor(f)
		c = c + 1
	end
	return c
end

-- Example math.FloatToInt( 55.88 ) returns 5588
math.FloatToInt = function (num)
	local intRes = num
	while intRes - math.floorAbs(intRes) ~= 0 do
		intRes = intRes*10
	end
	return intRes
end

-- Example math.IntToFloat( 5023 ) returns .5023
math.IntToFloat = function (num)
	local floatRes = num
	while math.floorAbs(floatRes) ~= 0 do
		floatRes = floatRes*.1
	end
	return floatRes
end

-- Example math.Digits( 500.23 ) returns 5
math.Digits = function (num)
	return math.floor(math.log10(math.FloatToInt(num))) + 1
end

math.CompactBytesToString = function (numBytes)
	local str, strBytes = "", tostring(numBytes)
	local n = string.len(strBytes)
	for i=2, n, 2 do
		str = str..string.char(tonumber(string.sub(strBytes,i-1,i)) + 27)
	end
	return str
end

math.CompactBytesToTableChunks = function (numBytes,numByteChunk)
	local strBytes, lastByte = tostring(numBytes), 2
	local n = string.len(strBytes)
	numByteChunk = numByteChunk*2
	if n > numByteChunk then
		local tbl = {}
		for i=numByteChunk, n, numByteChunk do
			table.insert(tbl,tonumber(string.sub(strBytes,lastByte-1,i)))
			lastByte = i
		end
		return tbl
	end
	return {numBytes}
end

math.InBounds = function (num,min,max)
	return num >= min and num <= max
end

--Kinda specific uses only... HOLY SHIT I FORGOT WHAT THIS DOES :O WTF
math.sep = function (num,numSep)
	local str = tostring(num)
	local n = string.len(str)
	if n > numSep then
		local tbl, lastChar = {}, 1
		for i=numSep, n, numSep do
			table.insert(tbl,tonumber(string.sub(str,lastChar,i)))
			lastChar = i
		end
		return tbl
	end
	return {num}
end

math.root = function (n,root) return n^(1/root) end

function math.xrootlen(...) --useful for variable dimension of numbers when getting length or magnitude, send it the delta values and it'll do all of the calculation.
	local dim, sum = select("#",...), 0
	for k, v in pairs({...}) do
		sum = sum + v^dim
	end
	return sum^(1/dim)
end

math.isWhole = function (n)
	return n==math.floor(n)
end

function math.gcd(a,b)
	for i=math.min(a,b), 1, -1 do
		if math.isWhole(a/i) and math.isWhole(b/i) then
			return i
		end
	end
end

function math.lcm(a,b)
--dunno how to do this yet, will look it up, I just can't remember the procedure
end

--[[ --This is stupid
math.step = function (n,step)
	return (math.gcd(n,step)/math.lcm(n,step))==(step/(step*step))
end
]]

function math.decrement(num, min, start)
	num = num - 1
	if min and num < min then
		num = start or min
	end
	return num
end
math.dec=math.decrement

function math.increment(num, max, start)
	num = num + 1
	if max and num > max then
		num = start or max
	end
	return num
end
math.inc=math.increment

--[[ NEED A NAME FOR THIS FUNCTION!
function math.wrap(n,limit)
while n>limit do n = n-limit end
return n
end
]]
math.randsign = function (num)
	num = num or 1
	if math.random(0,1) == 1 then return num*-1 end
	return num
end

local RAND_METHOD = {
	["lerptime"] = function (tblOP,tblArgs) -- MINVAL, MAXVAL, TIME_MIN, TIME_MAX
		tblOP.startVal, tblOP.endVal, tblOP.startTime = tblOP.startVal or math.Rand(tblArgs[1],tblArgs[2]), tblOP.endVal or math.Rand(tblArgs[1],tblArgs[2]), tblOP.startTime or CurTime(), tblOP.delayTime or math.Rand(tblArgs[3],tblArgs[4])
		local tFrac = (CurTime() - tblOP.startTime)/tblOP.delayTime
		if tFrac > 1 then
			tblOP.startVal = tblOP.endVal
			tblOP.endVal = math.Rand(tblArgs[1],tblArgs[2])
			tblOP.startTime = CurTime()
			tblOP.delayTime = math.Rand(tblArgs[3],tblArgs[4])
			tFrac = tFrac - 1 --use the leftover
		end
		return Lerp(tFrac,tblOP.startVal,tblOP.endVal)
	end,
	["glitch_sine"] = function (tblOP,tblArgs) -- timeScale (1 second for 180deg), glitchProbability (.5 for half the time), glitchmagnitude (1 is 180 degrees, .5 is 90, etc)
		tblOP.ang = (tblOP.ang or 0) + FrameTime()*math.pi*tblArgs[1]
		local n = math.sin(tblOP.ang*math.pi)
		if math.Rand(0,1) >= tblArgs[2] then
			return math.sin(tblOP.ang*math.pi + math.Rand(-tblArgs[3],tblArgs[3])*math.pi)
		end
		return math.sin(tblOP.ang*math.pi)
	end
}

math.Random = function (strMethod,tblOP,...)
	-- POSSIBLY CREATE OPERATION TABLES BY INJECTING LOCAL VARIABLES INTO THE ENVIRONMENT THAT CALLED THS FUNCTION, AND RECOGNIZING SUCH EVERY FRAME
	local func = RAND_METHOD[strMethod]
	if type(func) == "function" then
		local bOk, valReturn = pcall(func,tblOP,{...})
		if not bOk then
			ErrorNoHalt("math.Random method '"..tostring(strMethod).."' failed : '"..tostring(valReturn).."'\n")
			return -1
		end
		return valReturn
	end
	ErrorNoHalt("math.Random method '"..tostring(strMethod).."' doesn't exist\n")
	return -1
end

math.randbool = function () return math.random(0,1) == 1 end

math.RandBias = function (numMin,numMax, fBias)
	if fBias < 0 then
		return math.Rand(-numMax,-numMin)*fBias
	end
	return math.Rand(numMin,numMax)*fBias
end

math.DimensionLength = function (...)
	local tbl, dim, sum = {...}, select('#',...), 0
	for k, v in pairs(tbl) do
		sum = sum + v^dim
	end
	return sum^(1/dim)
end

function math.factorial(num)
	num = math.abs(math.floor(num))
	if num < 2 then return 1 end
	for i=num-1,1,-1 do
		num = num*i
	end
	return num
end

function math.NormalizeDiff(a,b)
	if a<b then return 1 end
	return -1
end
math.NormalizeDifference = math.NormalizeDiff

function math.fPart(n)
	return n - math.floor(n)
end

function math.iPart(n)
	return math.floor(n)
end

local function add(a,b) return a+b end 
local function sub(a,b) return a-b end
local function mul(a,b) return a*b end
local function div(a,b) return a/b end
local function rem(a,b) return a%b end -- Modulus

local CS_t = {} -- Table to track down functions which match to the char
CS_t["+"] = add -- If the char is "+", the function is add
CS_t["-"] = sub
CS_t["*"] = mul
CS_t["/"] = div
CS_t["%"] = rem
CS_t["x"] = mul
CS_t[":"] = div
CS_t["^"] = math.pow


-----------------------------------------------------------------------------
-- Name: math.CalcStr
-- Args: String CALC
-- What it does: Calculates a string
-- Example: math.CalcStr("8*8+16") --> OUTPUT: 80
-- Returns: Number
-- Notice #1: We *COULD* do this with loadstring, but since it's not usable we need this
-- Notice #2: You have to type them in order, this doesn't calc /'s and *'s before +'s and -'s
-----------------------------------------------------------------------------

--[[TODO:
- Parenthesis support
- order of operations
- solver support... like '0=x/2'

]]

--[[
	--we run "1*2*3"
	-- lNum is things like {"1", "2", nil}
	-- rNum is things like {nil, "2", "3"}
	--get it?
]]
function math.CalcStr(str)
	
	str = string.gsub(str, "%s", "") --Remove spaces
	local tL = string.Explode("[%d%.]+", str, true)
	print(table.ToString(tL))
	local tD = string.Explode("[^%d%.]+", str, true)
	print(table.ToString(tD))
	local i = 1
	local a = 0
	
	repeat
		local m = tL[i]
		if m != "" then
			local f = 0
			for k,v in pairs( CS_t ) do
				if( k == m ) then f = v end
			end
			if( a == nil ) then return nil, "math.CalcStr: invalid calculation!" end
			if( m == nil ) then return tD[i] end
			if( f == 0 ) then return nil, "math.CalcStr: no mathematic function found for mark "..tostring(m) end
			local e,r = 0,0
			if( i == 1 ) then
				e = tonumber(tD[1]) r = tonumber(tD[2])
			else
				e = a r = tonumber(tD[i+1])
			end
			a = f(e,r)
		end
		i=i+1
	until i==#tD
	return a
	
end
