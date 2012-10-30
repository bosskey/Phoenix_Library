function GetConVarBool(strName,bAlt)
	local b = GetConVar(strName):GetBool()
	if b == nil then
		return bAlt
	end
	return b
end

function ToConVarBool(b)
	if b then
		return "1"
	end
	return "0"
end
