local tblWeapons = {}
local tblNPCs = {}
local tblAll = {}
local tblProps = {}
local tblOthers = {}
local tblClasses = {}

function ents.GetAllProps()
	local tbl = {}
	for k, v in pairs(tblProps) do
		if v and ValidEntity(v) then
			table.insert(tbl,v)
		end
	end
	return tbl
end

function ents.GetAllWeapons()
	local tbl = {}
	for k, v in pairs(tblWeapons) do
		if v and ValidEntity(v) then
			table.insert(tbl,v)
		end
	end
	return tbl
end

function ents.GetAllNPCs()
	local tbl = {}
	for k, v in pairs(tblNPCs) do
		if v and ValidEntity(v) then
			table.insert(tbl,v)
		end
	end
	return tbl
end

function ents.GetAllOtherEnts()
	local tbl = {}
	for k, v in pairs(tblOthers) do
		if v and ValidEntity(v) then
			table.insert(tbl,v)
		end
	end
	return tbl
end
function ents.GetCachedClass(...)
	if select('#',...) == 1 then return tblClasses[(...) or ""] or {} end
	local tbl = {}
	for _, strClass in pairs({...}) do
		if tblClasses[strClass] then
			tbl = table.Add(tbl,tblClasses[strClass])
		end
	end
	return tbl
end
--[[
function ents.FindByClass(strClass)
	if not tblClasses[strClass] then return {} end
	local tbl = {}
	for k, v in pairs(tblClasses[strClass]) do
		if v and ValidEntity(v) then
			table.insert(tbl,v)
		end
	end
	return tbl
end
]]
if CLIENT then gamemode.Get("base")["PlayerInitialized"] = function () end end
local IS_PROP = {["prop_physics"]=true,["prop_physics_multiplayer"]=true}
local function ParseEntity(objEnt)
	if ValidEntity(objEnt) and not tblAll[objEnt] then
		local strClass = objEnt:GetClass() or ""
		if objEnt:IsWeapon() then
			table.insert(tblWeapons,objEnt)
		elseif objEnt:IsNPC() then
			table.insert(tblNPCs,objEnt)
		elseif CLIENT and objEnt:IsPlayer() then
			gamemode.Call("PlayerInitialized",objEnt)
		else
			if IS_PROP[strClass] then
				table.insert(tblProps,objEnt)
			else
				table.insert(tblOthers,objEnt)
			end
		end
		if tblClasses[strClass] then
			table.insert(tblClasses[strClass],objEnt)
		else
			tblClasses[strClass] = {objEnt}
		end
		tblAll[objEnt] = true
	end
end
hook.Add("OnEntityCreated",NAME,ParseEntity)
hook.Add("PostInitEntity",NAME,function ()
	for k, v in pairs(ents.GetAll()) do
		ParseEntity(v)
	end
end)

hook.Add("EntityRemoved",NAME,function (objEnt)
	if ValidEntity(objEnt) and tblAll[objEnt] then
		if objEnt:IsWeapon() then
			for k, v in pairs(tblWeapons) do
				if v and ValidEntity(v) and v == objEnt then
					table.remove(tblWeapons,k)
					break
				end
			end
		elseif objEnt:IsNPC() then
			for k, v in pairs(tblNPCs) do
				if v and ValidEntity(v) and v == objEnt then
					table.remove(tblNPCs,k)
					break
				end
			end
		elseif IS_PROP[objEnt:GetClass() or ""] then
			for k, v in pairs(tblProps) do
				if v and ValidEntity(v) and v == objEnt then
					table.remove(tblProps,k)
					break
				end
			end
		else
			for k, v in pairs(tblOthers) do
				if v and ValidEntity(v) and v == objEnt then
					table.remove(tblOthers,k)
					break
				end
			end
		end
	end
end)
