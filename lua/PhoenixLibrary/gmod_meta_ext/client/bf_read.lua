local function FormatByte(strBin)
	local s = string.reverse(tostring(strBin))
	return string.rep('0', 8 - string.len(s) )..s
end

_R.bf_read.ReadBitNumber = function (self,nBits, bSigned, nFloat) --nBits = how many bits
	nBits = math.max(nBits,4)
	local s = ''
	for i=1, nBits do
		s=s..(self:ReadBool() and '1' or '0')
	end
	--print(s)
	s=FormatByte(s)
	--print("formatted: "..s)
	return ((tonumber(s,2) or 0) - (bSigned and 2^(nBits-1) or 0))*.1^(nFloat or 0)
end

_R.bf_read.ReadByteString = function (self)
	local s=''
	for i=1, string.byte(self:ReadChar()) do
		s=s..self:ReadChar()
	end
	return s
end

_R.bf_read.ReadLiteralString = function (self)
	local s=''
	for i=1, string.byte(self:ReadChar()) do
		s=s..string.char(self:ReadBitNumber(7) + 32)
	end
	return s
end

_R.bf_read.ReadColor = function (self, bNoAlpha)
	return Color(string.byte(self:ReadChar()),string.byte(self:ReadChar()),string.byte(self:ReadChar()),(bNoAlpha and 255) or string.byte(self:ReadChar()))
end

--Implement http://oldsvn.wowace.com/wowace/trunk/LibCompress/