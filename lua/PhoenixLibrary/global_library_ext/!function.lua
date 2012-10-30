
function SafeCall(func,...)
	if type(func) == "function" then
		local bOk, objReturn = pcall(func,...)
		if not bOk then	return nil, objReturn end
		return objReturn
	end
end

function ForceBool(objData,objAlt)
	if IsBool(objData) then return objData end
	return objAlt
end

function ForceVector(objData,objAlt)
	if IsVector(objData) then return objData end
	return objAlt
end

function ForceAngle(objData,objAlt)
	if IsAngle(objData) then return objData end
	return objAlt
end

--Usage: If b is nil and valNil is nil then it returns valFalse.
function Condition(condition,valTrue,valFalse,valNil)
	local bCondition = ForceBool(condition) --(type(bCondition) == "bool" and bCondition) or type(bCondition) ~= "nil" --Wut, this is called forcing shit into a bool
	if bCondition == true then
		return valTrue
	elseif bCondition == false then
		return valFalse
	elseif type(valNil) ~= "nil" then
		return valNil
	end
	return valFalse
end

function ModuleEnv(...)
	local env = {}
	for _, strVarName in pairs({...}) do
		env[strVarName] = _G[strVarName]
	end
	return env
end

function Return(val)
	return function () return val end
end
