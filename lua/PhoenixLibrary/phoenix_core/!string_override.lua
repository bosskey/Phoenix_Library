--String functionality addition
local meta = getmetatable("")

meta.__index = function (str,k)
	if type(k) == "number" then
		return string.sub(str,k,k)
	end
	return string[k]
end

--I'm thinking about removing this division idea, it's sloppy to use this kind of bullshit
meta.__div = function (str,data)
	local strType = type(data)
	if strType == "number" then
		if data == 0 then error("Cannot divide a string by zero",2) end
		if data < 0 then data = -data end
		local numLen = string.len(str)
		if numLen < data then error("Cannot divide a string into more than the length of the string parts",2) end
		local tblStrings, numSep = {}, math.ceil(numLen/data)
		for i=1, numLen, numSep do
			table.insert(tblStrings,string.sub(str,i,math.min(i+numSep-1,numLen)))
			i=i+1
		end
		return tblStrings
	elseif strType == "string" then
		local numCount, numLast, numDataLen = 0, 1, string.len(data)
		while true do
			numLast = string.find(str,data,numLast)
			if numLast then
				numCount = numCount + 1
				numLast = numLast + numDataLen --small optimisation and also required to keep from returning the same section found over and over
			else
				return numCount
			end
		end
	end
end

meta.__copy = function (str)
	local strCopy = str
	return strCopy
end
