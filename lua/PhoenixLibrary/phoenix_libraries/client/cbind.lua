
module('cbind',package.seeall)
local tblBinds = {}
local tblToggles = {}
local tblChecks = {}

local function UpdateCheckValidity(numKey) --To keep Checks on only actively used key binds after they get totally removed.
	if table.Count(tblBinds[numKey] or {}) == 0 and table.Count(tblToggles[numKey] or {}) == 0 then
		tblChecks[numKey] = nil
	end
end

function AddBind(numKey,strName,fCallback)
	if not tblBinds[numKey] then tblBinds[numKey] = {} end
	tblBinds[numKey][strName] = fCallback
	tblChecks[numKey] = input.IsInputDown(numKey) and input.IsGameEnv()
end

function RemoveBind(numKey,strName)
	if not tblBinds[numKey] then return end
	tblBinds[numKey][strName] = nil
	UpdateCheckValidity(numKey)
end

function AddToggle(numKey,strName,fCallbackD,fCallbackU)
	if not tblToggles[numKey] then tblToggles[numKey] = {} end
	tblToggles[numKey][strName] = {d=fCallbackD,u=fCallbackU}
	tblChecks[numKey] = input.IsInputDown(numKey) and input.IsGameEnv()
end

function RemoveToggle(numKey,strName)
	if not tblToggles[numKey] then return end
	tblToggles[numKey][strName] = nil
	UpdateCheckValidity(numKey)
end

local function KDown(numKey)
	if tblBinds[numKey] then
		for k, v in pairs(tblBinds[numKey]) do
			local bOk, retVal = pcall(v)
			if not bOk then
				ErrorNoHalt("LuaBind '"..tostring(k).."' failed : '"..tostring(retVal).."'\n")
			end
		end
	end
	if tblToggles[numKey] then
		for k, v in pairs(tblToggles[numKey]) do
			local bOk, retVal = pcall(v.d)
			if not bOk then
				ErrorNoHalt("LuaToggle '"..tostring(k).."' failed : '"..tostring(retVal).."'\n")
			end
		end
	end
end

local function KUp(numKey)
	if tblToggles[numKey] then
		for k, v in pairs(tblToggles[numKey]) do
			local bOk, retVal = pcall(v.u)
			if not bOk then
				ErrorNoHalt("LuaToggle '"..tostring(k).."' failed : '"..tostring(retVal).."'\n")
			end
		end
	end
end

hook.Add("Tick","LUABINDS",function ()
	if input.IsGameEnv() then
		for k, bDown in pairs(tblChecks) do
			if not bDown then
				if input.IsInputDown(k) then
					tblChecks[k] = true
					KDown(k)
				end
			elseif not input.IsInputDown(k) then
				tblChecks[k] = false
				KUp(k)
			end
		end
	end
end)
