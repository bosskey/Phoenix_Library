if SERVER then include('server/servermessage.lua') end
local NAME = "stream"
module('stream',package.seeall)
local Hooks = {}
local Streams = {
	IN = SERVER and {},
	OUT = {}
}
--if SERVER then Streams.IN = {} end

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

local function NearestPower(n, pMax)
	for i=0, pMax or 256 do
		if 2^i >= n then
			return i
		end
	end
	return 256
end

local function string_split(str,d) --Thanks to Deco and Janorkie's datastream
    local t = {}
    local len = str:len()
    local i = 0
    while i*d < len do
        t[i+1] = str:sub(i*d+1,(i+1)*d)
        i=i+1
    end
    return t
end

local function Hex2Bin(s)
	local ret = ''
	local i = 0
	for i in string.gmatch(s, ".") do
		i = string.lower(i)
		ret = ret..hex2bin[i]
	end
	return ret
end

_G.Dec2Bin = function (s, num)
	local n
	if (num == nil) then
		n = 0
	elseif num > 2048 then
		ErrorNoHalt("Dec2Bin #2 argument is insanely high\n")
		return ""
	else
		n = num
	end
	s = Hex2Bin(string.format("%x", tostring(s)))
	while string.len(s) < n do
		s = '0'..s
	end
	return s
end

local function EncodeBinaryToString(tblBits)
	local str = ''
	local byte
	for i=1, #tblBits, 8 do
		byte = 0
		for bit=0, 7 do
			byte = byte + ((tblBits[i+bit] and 2^bit) or 0)
		end
		str = str..string.char(byte)
	end
	return str
end

local function DecodeStringToBinary(str)
	local bin = {}
	local t
	for i=1, #str do
		t = Dec2Bin(tostring(string.byte(string.sub(str,i,i))),8)
		for bit=8, 1, -1 do --normally 8 to 1
			table.insert(bin,string.sub(t,bit,bit)=='1')
		end
	end
	return bin
end

local function AppendBinary(bitsBuffer,strBin)
	for i=string.len(strBin), 1, -1  do
		table.insert(bitsBuffer,string.sub(strBin,i,i)=='1')
	end
end

local function ReadBits(tblBits,index,numBits)
	local sBits = ""
	for i=index+numBits-1, index, -1  do
		if type(tblBits[i])~="boolean" then error('fucking non-boolean index in bitstream :tblBits['..tostring(i)..'] dim is '..tostring(#tblBits)) end
		sBits=sBits..(tblBits[i] and "1" or "0")
	end
	return sBits
end

--TODO: Add table recursion support and key sending too!
local tblSpecificType = {
	--[[['Short'] = function (bitStream,n)
		AppendBinary(bitStream,Dec2Bin(math.Clamp(tonumber(n) or 0,-(2^15),2^15 - 1)+2^15,16))
	end,
	['UShort'] = function (bitStream,n)
		AppendBinary(bitStream,Dec2Bin(math.Clamp(tonumber(n) or 0,0,2^15),16))
	end,
	['ULong'] = function (bitStream,n)
		AppendBinary(bitStream,Dec2Bin(math.Clamp(tonumber(n) or 0,0,2^31),32))
	end,]]
	['number'] = {
		encode=function (bitStream,n) --signed long integer
			AppendBinary(bitStream,Dec2Bin(math.Clamp(tonumber(n) or 0,-(2^31),2^31 - 1)+2^31,32))
		end,
		decode=function (bitStream,index)
			return tonumber(ReadBits(bitStream,index,32),2)-2^31, index+32
		end},
	
	['Char'] = {
		encode=function (bitStream,ch)
			AppendBinary(bitStream,Dec2Bin(tostring(string.byte(ch)),8))
		end,
		decode=function (bitStream,index)
			return string.char(tonumber(ReadBits(bitStream,index,8),2)), index+8
		end},
	
	['string'] = {
		encode=function (bitStream,str)
			AppendBinary(bitStream,Dec2Bin(tostring(string.len(str)),8))
			for i=1, string.len(str) do
				AppendBinary(bitStream,Dec2Bin(tostring(string.byte(string.sub(str,i,i))),8))
			end
		end,
		decode=function (bitStream,index)
			local s=''
			for i=1, tonumber(ReadBits(bitStream,index,8),2) do
				index=index+8
				s=s..string.char(tonumber(ReadBits(bitStream,index,8),2))
			end
			return s, index+8
		end},

	['boolean'] = {
		encode=function (bitStream,b)
			table.insert(bitStream,b)
		end,
		decode=function (bitStream,index)
			return bitStream[index], index+1
		end},

	['Entity'] = {
		encode=function (bitStream,ent)
			AppendBinary(bitStream,Dec2Bin(tostring(ent:EntIndex()),16))
		end,
		decode=function (bitStream,index)
			return ents.GetByIndex(tonumber(ReadBits(bitStream,index,16),2)), index+16
		end},
	['table'] = true,
	['EOS']=true,
}
local tblSpecificTypeID = {}
local numMaxID = 0
for k,v in pairs(tblSpecificType) do
	numMaxID=numMaxID+1
	tblSpecificTypeID[k] = numMaxID
	tblSpecificTypeID[numMaxID] = k
end
local tblTypeAlias = { --Unique assignments such as player object
	['Player'] = 'Entity'
}
local TBL_DIM_BITSIZE = 32
local IDENT_BITS = NearestPower(table.Count(tblSpecificType)) --derpa
if not "devs only" then
print("IDENTBITS = "..IDENT_BITS)
end

_G.TYPTEST = function (typ,data)
	local tblBin = {}
	AppendBinary(tblBin,Dec2Bin(tostring(tblSpecificTypeID[typ]),IDENT_BITS))
	tblSpecificType[typ].encode(tblBin,data)
	PrintTable(tblBin)
	print("typ converted back to : "..tostring(tblSpecificTypeID[tonumber(ReadBits(tblBin,1,IDENT_BITS),2)]).." id="..tonumber(ReadBits(tblBin,1,IDENT_BITS),2))
	local dat, index = tblSpecificType[typ].decode(tblBin,IDENT_BITS+1)
	print('data converted back to : '..tostring(dat)..' new index:'..tostring(index))
end

--print("DERPA IS: maxid=",numMaxID,"tablecount=",table.Count(tblSpecificTypeID),"nearestpwr=",NearestPower(table.Count(tblSpecificTypeID)))


local function table_count_nonint(t, bAllowFloat)
	local n = 0
	for k, v in pairs(t) do
		if type(k) ~= 'number' or (bAllowFloat and math.floor(k)~=k) then
			n=n+1
		end
	end
	return n
end
local function ParseToStringX(tblBin,typ,tblX)
	local nonint = table_count_nonint(tblX,false)
	--AppendBinary(tblBin,Dec2Bin(tostring(#tblX),TBL_DIM_BITSIZE)) --number of integer keys
	for k, v in ipairs(tblX) do
		typ = type(v)
		if typ == 'table' then
			AppendBinary(tblBin,Dec2Bin(tostring(tblSpecificTypeID[typ]),IDENT_BITS)) --identify it as a table and then do recursion
			ParseToStringX(tblBin,typ,tblX[k])
		--elseif typ == 'number' then --Work on float and precision checking (try dynamic identification maybe?
		elseif typ~='nil' then
			typ = tblTypeAlias[typ] or typ
			if tblSpecificType[typ] then
				AppendBinary(tblBin,Dec2Bin(tostring(tblSpecificTypeID[typ]),IDENT_BITS))
				tblSpecificType[typ].encode(tblBin,v)
			end
		end
	end
	AppendBinary(tblBin,Dec2Bin(tostring(tblSpecificTypeID['EOS']),IDENT_BITS)) --a flag to end the stream (little endian?) instead of a huge 32 bit table dimension encoded 
	--TODO: add non-int key sending
	--[[table.insert(tblBin,nonint>0) --bit to tell if non-integer keys exist
	if nonint>0 then
		AppendBinary(tblBin,Dec2Bin(table_count_nonint(v,true)),2^32)
	end]]
	--[[ --todo non-integer indexed sending
		for k, v in pairs(tbl) do
			if type(k) ~= 'number' then --is NaN
			
			elseif math.floor(k)~=k then --# that has a decimal value
				
			end
		end
	]]
end

local function ParseToString(tbl, bAllowCompress)
	
	--DATA ENCODING PROCESS
	local tblBin = {}
	local typ
	ParseToStringX(tblBin,typ,tbl) --allows for recursion (some heavy duty shit bro)
	
	--STRING ENCODING then COMPRESSION PROCESS
	local str = EncodeBinaryToString(tblBin)
	local bCompressed = false
	if bAllowCompress then
		str, bCompressed = LibCompress.CompressLZW(str) --decode from table of bools to an encoded string then try to compress it
	end
	return str, bCompressed
end

local function ParseFromStringX(tbl,bitIndex,tblBin)
	local typ
	local tblIndex = 1
	while true do
		print("Reading a value...")
		typ = tblSpecificTypeID[tonumber(ReadBits(tblBin,bitIndex,IDENT_BITS),2)]
		if not typ then print("ERR With ID:"..tostring(tonumber(ReadBits(tblBin,bitIndex,IDENT_BITS),2))) end
		bitIndex = bitIndex + IDENT_BITS
		if typ then
			if typ == 'EOS' then
				break --end of table parsing
			else
				if typ == 'table' then
					tbl[i] = {}
					--[[if tonumber(ReadBits(tblBin,bitIndex,TBL_DIM_BITSIZE),2) > 512 then
						error("shit is so high "..tostring(tonumber(ReadBits(tblBin,bitIndex,TBL_DIM_BITSIZE),2)))
					end]]
					bitIndex = ParseFromStringX(tbl[i],bitIndex,tblBin)
				else --other object
					local dat, newBitIndex = tblSpecificType[typ].decode(tblBin,bitIndex)
					tbl[i] = dat
					bitIndex = newBitIndex
				end
				tblIndex = tblIndex + 1
			end
		else --a non-existant thingy
			--wtf
			ErrorNoHalt("stream: we gotz a problem with invalid values (possibly corrupted data sent?)\n")
		end
	end
	return bitIndex
end

local function ParseFromString(str,bCompressed)
	--DECOMPRESSION PROCESS
	if bCompressed then --decompress it if necessary
		str = LibCompress.DecompressLZW(str)
	end
	
	--STRING DECODING PROCESS
	local tblBin = DecodeStringToBinary(str) --It may be called Encode but whatever, it makes more sense in this function to call it decoding
	print("Fromstring to booltable:")
	PrintTable(tblBin)
	--DATA DECODING PROCESS (build that shit)
	local tbl = {}
	--local dim = tonumber(ReadBits(tblBin,1,TBL_DIM_BITSIZE),2)
	local bitIndex = 1
	bitIndex = ParseFromStringX(tbl,bitIndex,tblBin)
	return tbl
end

local CHUNK_SIZE_FROMSV = 252 --limit of the umsg library to send to clients in one package --252 realistically
local CHUNK_SIZE_FROMCL = 123 --limit of the smsg library to send to server in one package
if SERVER then
	local function FormatDestination(d)
		if type(d) == 'RecipientFilter' then
			--rage cuz we cant get a list
			return false
		elseif type(d) == 'Player' then
			return {d}
		elseif type(d) == 'number' then
			if d < 1 then
				return player.GetAll()
			end
			return {player.GetByID(d)}
		elseif type(d) == 'table' then
			return d
		end
		ErrorNoHalt("stream: Attempt to send a non-table of players to destination for stream!\n")
	end

	function Send(valDest,strName,tblData, bNoCompress, funcCallback)
		--if type(objIdent) == 'number' then objIdent = tostring(Dec2Bin(objIdent,16),2) end
		if string.len(strName) > CHUNK_SIZE_FROMSV - 4 - 1 then --1byte for len of identstr 4 for the size of stream
			ErrorNoHalt("stream: ident string exceeded "..tostring(CHUNK_SIZE_FROMSV - 4 - 1).." byte limit\n")
			return false
		end
		local strData, bCompress = ParseToString(tblData,not bNoCompress)
		local tblDest = FormatDestination(valDest)
		if not tblDest then ErrorNoHalt("stream: Cannot accept a RecipientFilter object for the destination\n") return false end
		local tblID = {}
		for k, objPl in pairs(tblDest) do
			if not Streams.OUT[objPl] then Streams.OUT[objPl] = {} end
			local tblChunks = string_split(strData,CHUNK_SIZE_FROMSV)
			--tblChunks[0] = string.sub(strData,1,#strName + 1 + 4)
			table.insert(tblID,table.insert(Streams.OUT[objPl],{name=strName,chunks=tblChunks,chunk=1,size=#strData,compress=bCompress,callback=funcCallback}))
		end
		return tblID --maybe more args like compressed %
	end
	
	hook.Add("Tick",NAME,function ()
		--IMPORTANT: when sending bytessize of stream to client use umsg.Long(size - 2^31)
		for objPl, listOut in pairs(Streams.OUT) do
			for id, strm in ipairs(listOut) do
				if not strm.started then
					umsg.Start((strm.compress and "\1") or "\2",objPl)
						umsg.String(strm.name)
						umsg.Long(strm.size - 2^31) --necessary to make the size signed to preserve accuracy when using Signed Long transport format
						--[[for i=1, string.len(strm.chunks[0]) do
							umsg.Char(string.sub(strm.chunks[0],i,i))
						end]]
					umsg.End()
					Streams.OUT[objPl][id].started=true
				else
					umsg.Start("\3",objPl)
						for i=1, string.len(strm.chunks[strm.chunk]) do
							umsg.Char(string.sub(strm.chunks[strm.chunk],i,i))
						end
					umsg.End()
					Streams.OUT[objPl][id].chunk = strm.chunk + 1
					if not strm.chunks[listOut[id].chunk] then
						--FINISHED STREAM TO CLIENT
						if type(strm.callback) == 'function' then
							local bOk, valReturn = pcall(strm.callback,strm.name,true)
							if not bOk then
								ErrorNoHalt("stream: sent-callback failed '"..tostring(strm.name).."' : "..tostring(valReturn).."\n")
							end
						end
						Streams.OUT[objPl][id] = nil --Thats the end of this stream; We don't use table.remove, it wouldn't preserve the ids of streams & this is faster.
					end
				end
				break
			end
		end
	end)
	
	local function CompletedRecv(objPl,strName,tblData) --completed receiving shit from the server
		local bOk, valReturn = pcall(Hooks[strName],objPl,tblData)
		if not bOk then
			ErrorNoHalt("stream: callback for received '"..tostring(strName).."' failed : "..tostring(valReturn).."\n")
		end
	end
	
	local function StartRecv(objPl,sm, bCompressed)
		local strIdent, numBytes = sm:ReadString(), sm:ReadULong() --# bytes, 4 bytes
		if Streams.IN[objPl] then ErrorNoHalt("stream: attempt to start a stream without finishing previous stream!\n") --[[should cut short the previous stream here]] return end
		if not Hooks[strIdent] then ErrorNoHalt("stream: attempt to start a stream with no accepting hook serverside!\n") return end
		--TODO: do a sizecheck somehow to prevent DoS on the memory
		local str = ''
		--[[for i=1, CHUNK_SIZE_FROMCL - 1 - #strIdent - 4 do
			str=str..sm:ReadChar()
		end]]
		print("stream: start comp="..tostring(bCompress).." ("..str..")")
		Streams.IN[objPl] = {name=strIdent,data=str,size=numBytes,comp=bCompressed}
	end
	servermessage.Hook('\1',StartRecv,true) --Start compressed from client
	servermessage.Hook('\2',StartRecv,false) --Start uncompressed from client
	servermessage.Hook('\3',function (objPl,sm) --continue stream (or last packet)
		if not Streams.IN[objPl] then ErrorNoHalt("stream: Attempt to continue a stream that hasn't been initialized!\n") return end
		for i=1, math.min(CHUNK_SIZE_FROMCL,Streams.IN[objPl].size - string.len(Streams.IN[objPl].data)) do
			Streams.IN[objPl].data = Streams.IN[objPl].data .. sm:ReadChar()
		end
		if string.len(Streams.IN[objPl].data) == Streams.IN[objPl].size then
			--finished stream successfully
			CompletedRecv(objPl,Streams.IN[objPl].name,ParseFromString(Streams.IN[objPl].data,Streams.IN[objPl].comp))
			Streams.IN[objPl] = nil
			--TODO: add >= and timeout functionality for troubleshooting
		end
	end)
end

if CLIENT then
	--VERIFYTHIS:
	function Send(strName,tblData, bNoCompress, funcCallback)
		local strData, bCompress = ParseToString(tblData,not bNoCompress)
		local tblChunks = string_split(strData,CHUNK_SIZE_FROMCL)
		return table.insert(Streams.OUT,{name=strName,chunks=tblChunks,size=#strData,compress=bCompress,callback=funcCallback})
	end
	
	--NEEDTODO:
	hook.Add("Tick",NAME,function ()
		for k, v in ipairs(Streams.OUT) do
			
			break
		end
	end)
	
	--NEEDTODO:
	local function CompletedRecv(strName,data)
		--bleh bleh bleh
		if Hooks[strName] then
			local bOk, valReturn = pcall(Hooks[strName],data)
			if not bOk then
				ErrorNoHalt("stream: callback for received '"..tostring(strName).."' failed : "..tostring(valReturn).."\n")
			end
		end
	end
	
	local function StartRecv(um, bCompressed)
		local strIdent, numBytes = um:ReadString(), um:ReadLong()+2^31
		if Streams.IN then Streams.IN = nil ErrorNoHalt("stream: attempt to start a stream without finishing previous stream!\n") --[[should cut short the previous stream here]] end
		if not Hooks[strIdent] then ErrorNoHalt("stream: attempt to start a stream with no accepting hook clientside!\n") return end
		--TODO: do a sizecheck somehow to prevent DoS on the memory
		local str = ''
		--[[for i=1, CHUNK_SIZE_FROMSV - 1 - #strIdent - 4 do
			str=str..um:ReadChar()
		end]]
		print("stream: start comp? "..(bCompress and 'yes' or 'no').." data='"..str.."'")
		Streams.IN = {name=strIdent,data=str,size=numBytes,comp=bCompressed}
		--[[if numBytes >= string.len(str) then
			--small packet and we're done 			--finished stream successfully
			CompletedRecv(Streams.IN.name,ParseFromString(Streams.IN.data,Streams.IN.comp))
			Streams.IN = nil
		end]]
	end
	usermessage.Hook('\1',function (um) StartRecv(um,true) end) --Start compressed from server
	usermessage.Hook('\2',function (um) StartRecv(um,false) end) --Start uncompressed from server
	usermessage.Hook('\3',function (um)
		if not Streams.IN then ErrorNoHalt("stream: attempt to continue a stream that hasn't been initialized yet!\n") return end
		for i=1, math.min(CHUNK_SIZE_FROMSV,Streams.IN.size - string.len(Streams.IN.data)) do
			Streams.IN.data = Streams.IN.data .. um:ReadChar()
		end
		if string.len(Streams.IN.data) == Streams.IN.size then
			--finished stream successfully
			--TODO: add >= and timeout functionality for troubleshooting
			CompletedRecv(Streams.IN.name,ParseFromString(Streams.IN.data,Streams.IN.comp))
			Streams.IN = nil
		end
	end)
	
	function GetDownloadProgress()
		if not Streams.IN then return nil end
		return string.len(Streams.IN.data)/Streams.IN.size
	end
	function GetUploadProgress(numID)
		if not Streams.OUT[numID] then ErrorNoHalt("stream: GetUploadProgress invalid identification number!\n") return 0 end
		return string.len(Streams.OUT[numID].data)/Streams.OUT[numID].size
	end
end

function Hook(strName,funcCallback)
	if type(funcCallback) ~= 'function' then ErrorNoHalt("stream: stream.Hook argument #2 must be a function!\n") return end
	Hooks[strName] = funcCallback
end
