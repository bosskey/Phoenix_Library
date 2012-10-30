----------------------------------------------------------------------------------
--
-- LibCompress.lua
--
-- Authors: jjsheets and Galmok of European Stormrage (Horde)
-- Email : sheets.jeff@gmail.com and galmok@gmail.com
-- Licence: GPL version 2 (General Public License)
----------------------------------------------------------------------------------

local MAJOR, MINOR = "LibCompress", 3
local oldminor = MINOR

LibCompress = {}

-- list of codecs in this file:
-- \000 - Never used
-- \001 - Uncompressed
-- \002 - LZW
-- \003 - Huffman

-- local is faster than global
local table_insert = table.insert
local table_remove = table.remove
local table_concat = table.concat
local string_char = string.char
local string_byte = string.byte
local string_len = string.len
local string_sub = string.sub
local unpack = unpack
local type = type
local pairs = pairs
local math_modf = math.modf
local bit_band = (bit or {}).band or function (a,b) return (a or 0) & (b or 0) end
local bit_bor = (bit or {}).bor or function (a,b) return (a or 0) | (b or 0) end
local bit_lshift = (bit or {}).lshift or function (a,b) return (a or 0) << (b or 0) end
local bit_rshift = (bit or {}).rshift or function (a,b) return (a or 0) >> (b or 0) end

--------------------------------------------------------------------------------
module('LibCompress')
--------------------------------------------------------------------------------
-- LZW codec
-- implemented by sheets.jeff@gmail.com

-- encode is used to uniquely encode a number into a sequence of bytes that can be decoded using decode()
-- the bytes returned by this do not contain "\000"
local bytes = {}
local function encode(x)
	for k = 1, #bytes do bytes[k] = nil end
	local xmod
	x, xmod = math_modf(x/255)
	xmod = xmod * 255
	bytes[#bytes + 1] = xmod
	while x > 0 do
		x, xmod = math_modf(x/255)
		xmod = xmod * 255
		bytes[#bytes + 1] = xmod
	end
	if #bytes == 1 and bytes[1] > 0 and bytes[1] < 250 then
		return string_char(bytes[1])
	else
		for i = 1, #bytes do bytes[i] = bytes[i] + 1 end
		return string_char(256 - #bytes, unpack(bytes))
	end
end

--decode converts a unique character sequence into its equivalent number, from ss, beginning at the ith char.
-- returns the decoded number and the count of characters used in the decode process.
local function decode(ss,i)
	i = i or 1
	local a = string_byte(ss,i,i)
	if a > 249 then
		local r = 0
		a = 256 - a
		for n = i+a, i+1, -1 do
			r = r * 255 + string_byte(ss,n,n) - 1
		end
		return r, a + 1
	else
		return a, 1
	end
end

-- Compresses the given uncompressed string.
-- Unless the uncompressed string starts with "\002", this is guaranteed to return a string equal to or smaller than
-- the passed string.
-- the returned string will only contain "\000" characters in rare circumstances, and will contain none if the
-- source string has none.
local dict = {}
function CompressLZW(uncompressed)
	if type(uncompressed) == "string" then
		local dict_size = 256
		for k in pairs(dict) do
			dict[k] = nil
		end
		local result = {}
		local w = ''
		local ressize = 1
		for i = 0, 255 do
			dict[string_char(i)] = i
		end
		for i = 1, #uncompressed do
			local c = uncompressed:sub(i,i)
			local wc = w..c
			if dict[wc] then
				w = wc
			else
				dict[wc] = dict_size
				dict_size = dict_size +1
				local r = encode(dict[w])
				ressize = ressize + #r
				result[#result + 1] = r
				w = c
			end
		end
		if w then
			local r = encode(dict[w])
			ressize = ressize + #r
			result[#result + 1] = r
		end
		if #uncompressed > ressize then
			return table_concat(result), true
		else
			return uncompressed, false
		end
	else
		return nil, "Can only compress strings"
	end
end

-- if the passed string is a compressed string, this will decompress it and return the decompressed string.
-- Otherwise it return an error message
-- compressed strings are marked by beginning with "\002"
function DecompressLZW(compressed)
	if type(compressed) == "string" then
		local dict_size = 256
		for k in pairs(dict) do
			dict[k] = nil
		end
		for i = 0, 255 do
			dict[i] = string_char(i)
		end
		local result = {}
		local t = 1
		local delta, k
		k, delta = decode(compressed,t)
		t = t + delta
		result[#result+1] = dict[k]
		local w = dict[k]
		local entry
		while t <= #compressed do
			k, delta = decode(compressed,t)
			t = t + delta
			entry = dict[k] or (w..w:sub(1,1))
			result[#result+1] = entry
			dict[dict_size] = w..entry:sub(1,1)
			dict_size = dict_size + 1
			w = entry
		end
		return table_concat(result), true
	else
		return nil, false
	end
end
