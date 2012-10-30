local type = _type or __type or type --_type or __type are phxlib internals, and so they are the pure function calls to the original type function
if type(usermessage) ~= "table" then return end
local ObjectConvert = {}
usermessage.RegisterObject = function (strMetaName,funcDecode)
	ObjectConvert[strMetaName] = funcDecode
end
local bf_read = _R["bf_read"]
bf_read.ReadObject = function (self,strMetaName)
	if type(strMetaName) == "string" then
		local funcDecode = ObjectConvert[strMetaName]
		if type(funcDecode) == "function" then
			local bOk, valReturn = pcall(funcDecode,self)
			if bOk then
				return valReturn
			else
				LibError("'"..strMetaName.."' failed : '"..tostring(valReturn).."'")
			end
		else
			LibError("'"..strMetaName.."' is not registered.")
		end
	end
	LibErrorHalt("Must pass a metaname for the object for the reading process.")
	return nil
end

bf_read.ReadHuge = function (self) --DUMB DUMB DUMB SO FUCKING DUMB
	local iPart, fPart = self:ReadLong(), self:ReadLong()
	repeat fPart = fPart*.1 until math.floor(fPart) == 0 --Turn the integer representation of the float value back into a float value.
	return iPart + fPart
end

--Implement http://oldsvn.wowace.com/wowace/trunk/LibCompress/