module("move",package.seeall)
local Move = {
	Defaults = {
		["AirControl"] = .15
	},
	Events = {
		["StartTouch"] = {},
		["EndTouch"] = {},
		["OnCollide"] = {}
	},
	Utils = {}
}
function SetDefault(strName, val)
	if Move.Defaults[strName] then
		Move.Defaults[strName] = val
		return true
	end
	return false
end

function CallEvent(strEvent,...)
	local tbl = Move.Events[strEvent]
	if tbl ~= nil then
		local bOk, retval
		for k, v in pairs(tbl) do
			if type(v) == "function" then
				bOk, retval = pcall(v, ...)
				if bOk then
					if retval ~= nil then
						return retval
					end
				else
					ErrorNoHalt("Move Event '"..tostring(k).."' Failed: "..tostring(retval).."\n")
					tbl[k] = nil
				end
			else
				ErrorNoHalt("Move Event '"..tostring(k).."' tried to call a nil function!\n")
				tbl[k] = nil
				break
			end
		end
		return retval
	end
end

function RegisterEvent(strEvent)
	if not Move.Events[strEvent] then
		Move.Events[strEvent] = {}
		return true
	end
	return false
end

function Hook(strEvent,strName,funcCallback)
	if not Move.Events[strEvent] then
		return false
	end
	Move.Events[strEvent][strName] = funcCallback
	return true
end

function UnHook(strEvent,strName)
	if not Move.Events[strEvent] then
		return false
	end
	Move.Events[strEvent][strName] = nil
	return true
end

function AddUtil(strName,func)
	if not Move.Utils[strName] then
		Move.Utils[strName] = func
		return true
	end
	return false
end

function CallUtil(strName,...)
	if Move.Utils[strName] then
		return Move.Utils[strName](...)
	end
	return nil
end

function RemoveUtil(strName)
	if Move.Utils[strName] then
		Move.Utils[strName] = nil
		return true
	end
	return false
end

local meta = FindMetaTable("Player")
function meta:SetMoveAttribute(strName,val)
	self.MoveData[strName] = val
end
meta.SetMoveData = meta.SetMoveAttribute

function meta:GetMoveAttribute(strName,val)
	return self.MoveData[strName] or val
end
meta.GetMoveData = meta.GetMoveAttribute

hook.Add("PlayerInitialSpawn",NAME,function (objPl)
	objPl.MoveData = table.Copy(Move.Defaults)
	--[[
	local ent = ents.Create("player_move_object")
	ent:Spawn()
	ent:SetPlayer(objPl)
	objPl.MoveObject = ent
	]]
end)

hook.Add("PlayerDisconnected",NAME,function (objPl)
--[[
	if ValidEntity(objPl.MoveObject) then
		objPl.MoveObject:Remove()
	end
]]
end)
