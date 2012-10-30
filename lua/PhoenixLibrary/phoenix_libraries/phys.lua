module("phys",package.seeall)
local Phys = {
	Methods = {}
}

function AddMethod(strName,func)
	if not Phys.Methods[strName] then
		Phys.Methods[strName] = func
		return true
	end
	return false
end

function CallMethod(strName,...)
	if Phys.Methods[strName] then
		return Phys.Methods[strName](...)
	end
	return nil
end

function RemoveMethod(strName)
	if Phys.Methods[strName] then
		Phys.Methods[strName] = nil
		return true
	end
	return false
end
