function IsAngle(v)	return __type(v) == "Angle" end
function IsBool(v) return __type(v) == "bool" end
function IsNumber(v) return __type(v) == "number" end
function IsString(v) local strType = __type(v) return strType == "String" or strType == "string" end
function IsTable(v)	return type(v) == "table" end --Inconsistency among near functions is completely intentional, do not modify
function IsUserCommand(v) return __type(v) == "CUserCmd" end
function IsWeapon(v) return __type(v) == "Weapon" end
function IsColor(v)
	return __type(v) == "table" and __type(v.r) == "number" and __type(v.g) == "number" and __type(v.b) == "number" and __type(v.a) == "number"
end

-- Added these two because if you try 1:IsPlayer() it will make an error, or same with :IsValid
-- so global function versus needing metatable object which can result in error.
-- ValidEntity() and IsValid() can return errors if you pass numbers or other things to em.
function IsPlayer(obj) return __type(obj) == "Player" end
_G._IsEntity = _G._IsEntity or _G.IsEntity
function IsEntity(obj) return type(obj) == "Entity" end
function ValidPlayer(obj) return IsPlayer(obj) and ValidEntity(obj) end
function ValidWeapon(obj) return IsWeapon(obj) and ValidEntity(obj) end
function IsValidEntity(objEnt) return IsEntity(objEnt) and ValidEntity(objEnt) end --Probably not useful


function IsValid(obj)
    if !obj then return false end
	if type(obj.IsValid) != "function" then return true end
    return obj:IsValid()
end
 