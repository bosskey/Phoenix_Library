
string.FormatFileExtension = function(strExt)
	local numCh = string.len(strExt)
	if numCh > 3 then
		return "*."..string.Right(strExt,3)
	elseif numCh < 3 then
		return "*."..strExt.."*"
	end
	return "*."..strExt
end

string.GetFolderFromPath = function(strPath)
	local sep = string.Explode("/",string.gsub(strPath,"\\","/"))
	if #sep > 1 then
		return sep[#sep]
	elseif #sep == 1 then
		return sep[1]
	end
	return strPath
end

string.FormatPath = function(strPath)
	strPath = string.gsub(strPath,"\\","/")
	strPath = string.gsub(strPath,"//","/")
	if string.Right(strPath,1) ~= "/" then
		strPath = strPath.."/"
	end
	return strPath
end

string.Max = function (str,numMax,bTrail)
	local n = string.len(str)
	if n > numMax then
		if bTrail then
			return string.Left(str,math.max(1,numMax - 3)).."..."
		end
		return string.Left(str,math.max(1,numMax))
	end
	return str
end

string.Min = function (str,numMin,chSpace)
	chSpace = chSpace or " "
	local n = string.len(str)
	if n < numMin then
		return str..string.rep(chSpace,numMin - n)
	end
	return str
end

string.Clamp = function (str,numMin,numMax,chSpace,bTrail)
	local len, fstr = string.len(str), str
	if len < numMin then
		fstr = string.Min(fstr,numMin,chSpace)
	elseif len > numMax then
		fstr = string.Max(fstr,numMax,bTrail)
	end
	return fstr
end

string.sep = function (str,numSep)
	local n = string.len(str)
	if n > numSep then
		local tbl, lastChar = {}, 1
		for i=numSep, n, numSep do
			table.insert(tbl,string.sub(str,lastChar,i))
			lastChar = i
		end
		return tbl
	end
	return {str}
end

string.StringToCompactBytes = function (str)
	local tbl = {}
	for i=1, string.len(str) do
		tbl[i] = tostring(string.byte(string.sub(str,i,i)) - 27)
	end
	return tonumber(table.concat(tbl))
end


--[[
TODO: Finish the formatting and separation.
local CURRENT_IPv = 4
string.GetIPFromAddress = function (str,numIPv)
	numIPv = numIPv or CURRENT_IPv
	if numIPv == 4 then
	
	elseif numIPv == 6 then
	
	end
end

string.GetPortFromAddress = function (str,numIPv)
	numIPv = numIPv or CURRENT_IPv
	if numIPv == 4 then
	
	elseif numIPv == 6 then
	
	end
end
]]

--TODO make it actually filter correctly
local tblNormalChar = {
	[9] = true,
	[10] = true,
	--[11] = true,
	--[13] = true,
}
local byte
string.filternormal = function (str)
	local strNew = ""
	for i=1, string.len(str) do
		byte = string.byte(string.sub(str,i,i))
		if (byte > 31 and byte < 127) or tblNormalChar[byte] then
			strNew = strNew..string.sub(str,i,i)
		end
	end
	return strNew
end

string.set = function (str,k,v)
	local strNew = ""
	for i=1, string.len(str) do
		if i == k then
			strNew = strNew..string.sub(v,1,1)
		else
			strNew = strNew..string.sub(str,i,i)
		end
	end
	return strNew
end
local ll, i, ie
function string.findAll(str,strF, iStart, bPlain)
	local tbli={}
	ll=iStart or 1
	while true do
		i, ie = string.find(str,strF,ll,bPlain)
		if i == nil then break end
		table.insert(tbli,i)
	end
	return tbli
end

--added bAllowPatterns support
function string.Explode(seperator,str, bAllowPatterns)
	if seperator == "" then	return string.ToTable(str) end
	local tble={}
	ll=1
	while true do
		i, ie = string.find( str, seperator, ll, !bAllowPatterns )
		if i != nil then
			table.insert(tble, string.sub(str,ll,i-1))
			ll=i+1+(ie-i)
		else
			table.insert(tble, string.sub(str,ll))
			break
		end
	end
	return tble
end