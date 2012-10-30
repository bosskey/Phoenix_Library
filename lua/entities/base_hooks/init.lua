AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local Hooks = {}

function ENT:CallHooks(strEvent,...)
	local HookTable = Hooks[strEvent]
	local ToRemove, bOk, valReturn = {}
	if HookTable ~= nil then
		for strName, funcCallback in pairs(Hooks[strEvent]) do
			if type(funcCallback) == "function" then
				bOk, valReturn = pcall(funcCallback,...)
				if bOk then
					if type(valReturn) ~= "nil" then
						return valReturn
					end
				else
					ErrorNoHalt("Ent "..tostring(self).." Hook '"..tostring(strName).."' Failed: "..tostring(valReturn).."\n")
				end
			else
				ErrorNoHalt("Ent "..tostring(self).." Hook '"..tostring(strName).."' tried to call a nil function!\n") 
 				table.insert(ToRemove,strName)
 				--break
			end
		end
	end
	if #ToRemove > 0 then
		for _, strName in pairs(ToRemove) do
			HookTable[strName] = nil
		end
	end
	return valReturn
end

function ENT:AddHook(strEvent,strName,funcCallback)
	if strEvent ~= "AddHook" and strEvent ~= "RemoveHook" then
		if type(self.BaseClass[strEvent]) == "function" or type(self[strEvent]) == "function" then --check if ent has this
			if not Hooks[strEvent] then --No need to check type is function here, since nobody can edit the local hooks table
				Hooks[strEvent] = {}
			end
			Hooks[strEvent][strName] = funcCallback
		end
	end
end

function ENT:RemoveHook(strEvent,strName)
	if strEvent ~= "AddHook" and strEvent ~= "RemoveHook" then
		if Hooks[strEvent] and Hooks[strEvent][strName] then
			Hooks[strEvent][strName] = nil
		end
	end
end

local tbl = {
	"AcceptInput",
	"EndTouch",
	"Initialize",
	"KeyValue",
	"OnRemove",
	"OnRestore",
	"OnTakeDamage",
	"PhysicsCollide",
	"PhysicsSimulate",
	"PhysicsUpdate",
	"StartTouch",
	"Think",
	"Touch",
	"UpdateTransmitState",
	"Use"
}

for _, strFuncName in pairs(tbl) do
	ENT[strFuncName] = function (self,...)
		local valReturn = self:CallHooks(strFuncName,...)
		return valReturn
	end
end
