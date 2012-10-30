local NW = {
	Shared = {},
	Team = {},
	IndexedStrings = {},
	DataTypeTranslate = {
		["Int"]=umsg.Long,
		["Float"]=umsg.Float,
		["Entity"]=umsg.Entity,
		["Vector"]=umsg.Vector,
		["VectorNormal"]=umsg.VectorNormal,
		["Angle"]=umsg.Angle,
		["Bool"]=umsg.Bool,
		["Char"]=umsg.Char,
		["String"]=umsg.String
	}
}
local BaseNWTable = {["Angle"]={},["Bool"]={},["Char"]={},["Entity"]={},["Float"]={},["Int"]={},["String"]={},["Vector"]={},["VectorNormal"]={}}
--concommand.Add("~initnetworking",function (objPl,strCmd,tblArgs)
hook.Add("PlayerInitialSpawn",NAME,function (objPl)
	if NW.Shared[objPl] and not NW.Shared[objPl].Initialized then
		NW.Shared[objPl].Initialized = true
		local tbl = NW.Shared[objPl] or BaseNWTable
		if table.Count(tbl["Angle"]) then
			umsg.Start("SendPlayerSharedAngles",objPl)
				local num = table.Count(tbl["Angle"])
				umsg.Short(num)
				for k, v in pairs(tbl["Angle"]) do
					umsg.String(k)
					umsg.Angle(v)
				end
			umsg.End()
		end
		for strDataType, tblVars in pairs(tbl) do
			local num = table.Count(tblVars)
			if num then
				umsg.Start("SendPlayerShared"..strDataType.."s",objPl)
					umsg.Short(num)
					for strIndex, varVal in pairs(tblVars) do
						umsg.String(k)
						NW.DataTypeTranslate[strDataType](varVal)
					end
				umsg.End()
			end
		end
		local tbl = NW.Team[objPl:Team()] or BaseNWTable
		for strDataType, tblVars in pairs(tbl) do
			local num = table.Count(tblVars)
			if num then
				umsg.Start("SendTeamShared"..strDataType.."s",objPl)
					umsg.Short(num)
					for strIndex, varVal in pairs(tblVars) do
						umsg.String(k)
						NW.DataTypeTranslate[strDataType](varVal)
					end
				umsg.End()
			end
		end
	end
end)
if type(team) == "table" then
	local function CheckTeamNW(numTeam)
		if not NW.Team[numTeam] then
			NW.Team[numTeam] = table.Copy(BaseNWTable)
		end
	end
	local function SetTeamNW(numTeam,strDataType,strIndex,varVal,bSetRarely)
		if bSetRarely == true then
			NW.IndexedStrings[strindex] = true
		elseif not NW.IndexedStrings[strIndex] then
			umsg.PoolString(strIndex)
			NW.IndexedStrings[strIndex] = true
		end
		local oldVal = NW.Team[numTeam][strDataType][strIndex]
		if oldVal == nil or varVal ~= oldVal then
			NW.Team[numTeam][strDataType][strIndex] = varVal
			local rp = RecipientFilter()
			for _, objPl in pairs(team.GetPlayers(numTeam)) do
				rp:AddPlayer(objPl)
			end
			umsg.Start("SetTeamShared"..strDataType,rp)
				umsg.String(strIndex)
				NW.DataTypeTranslate[strDataType](varVal)
			umsg.End()
		end
	end
	team.SetSharedInt = function (numTeam,strIndex,numVal,bSetRarely)
		CheckTeamNW(numTeam)
		SetTeamNW(numTeam,"Int",strIndex,numVal,bSetRarely)
	end
	team.SetSharedFloat = function (numTeam,strIndex,numVal,bSetRarely)
		CheckTeamNW(numTeam)
		SetTeamNW(numTeam,"Float",strIndex,numVal,bSetRarely)
	end
	team.SetSharedString = function (numTeam,strIndex,strVal,bSetRarely)
		CheckTeamNW(numTeam)
		SetTeamNW(numTeam,"String",strIndex,strVal,bSetRarely)
	end
	team.SetSharedBool = function (numTeam,strIndex,bVal,bSetRarely)
		CheckTeamNW(numTeam)
		SetTeamNW(numTeam,"Bool",strIndex,bVal,bSetRarely)
	end
	team.SetSharedVector = function (numTeam,strIndex,vecVal,bSetRarely)
		CheckTeamNW(numTeam)
		SetTeamNW(numTeam,"Vector",strIndex,vecVal,bSetRarely)
	end
	team.SetSharedVectorNormal = function (numTeam,strIndex,vecVal,bSetRarely)
		CheckTeamNW(numTeam)
		SetTeamNW(numTeam,"VectorNormal",strIndex,vecVal,bSetRarely)
	end
	team.SetSharedAngle = function (numTeam,strIndex,angVal,bSetRarely)
		CheckTeamNW(numTeam)
		SetTeamNW(numTeam,"Angle",strIndex,angVal,bSetRarely)
	end
	team.SetSharedChar = function (numTeam,strIndex,chVal,bSetRarely)
		CheckTeamNW(numTeam)
		SetTeamNW(numTeam,"Char",strIndex,chVal,bSetRarely)
	end
	team.SetSharedEntity = function (numTeam,strIndex,objEnt,bSetRarely)
		CheckTeamNW(numTeam)
		SetTeamNW(numTeam,"Entity",strIndex,objEnt,bSetRarely)
	end
	local function GetTeamNW(numTeam,strDataType,strIndex,varVal)
		return NW.Team[numTeam][strDataType][strIndex] or varVal
	end
	team.GetSharedInt = function (numTeam,strIndex,numVal)
		CheckTeamNW(numTeam)
		GetTeamNW(numTeam,"Int",strIndex,numVal)
	end
	team.GetSharedFloat = function (numTeam,strIndex,numVal)
		CheckTeamNW(numTeam)
		GetTeamNW(numTeam,"Float",strIndex,numVal)
	end
	team.GetSharedString = function (numTeam,strIndex,strVal)
		CheckTeamNW(numTeam)
		GetTeamNW(numTeam,"String",strIndex,strVal)
	end
	team.GetSharedBool = function (numTeam,strIndex,bVal)
		CheckTeamNW(numTeam)
		GetTeamNW(numTeam,"Bool",strIndex,bVal)
	end
	team.GetSharedVector = function (numTeam,strIndex,vecVal)
		CheckTeamNW(numTeam)
		GetTeamNW(numTeam,"Vector",strIndex,vecVal)
	end
	team.GetSharedVectorNormal = function (numTeam,strIndex,vecVal)
		CheckTeamNW(numTeam)
		GetTeamNW(numTeam,"VectorNormal",strIndex,vecVal)
	end
	team.GetSharedAngle = function (numTeam,strIndex,angVal)
		CheckTeamNW(numTeam)
		GetTeamNW(numTeam,"Angle",strIndex,angVal)
	end
	team.GetSharedChar = function (numTeam,strIndex,chVal)
		CheckTeamNW(numTeam)
		GetTeamNW(numTeam,"Char",strIndex,chVal)
	end
	team.GetSharedEntity = function (numTeam,strIndex,objEnt)
		CheckTeamNW(numTeam)
		GetTeamNW(numTeam,"Entity",strIndex,objEnt)
	end
end

local function CheckPlayerNW(objPl)
	if not NW.Shared[objPl] then
		NW.Shared[objPl] = table.Copy(BaseNWTable)
	end
end
local function SetPlayerNW(objPl,strDataType,strIndex,varVal,bSetRarely)
	if bSetRarely == true then
		NW.IndexedStrings[strIndex] = true
	elseif not NW.IndexedStrings[strIndex] then
		umsg.PoolString(strIndex)
		NW.IndexedStrings[strIndex] = true
	end
	local oldVal = (NW.Shared[objPl]['old'..strDataType] or {})[strIndex]
	if oldVal == nil or oldVal ~= varVal then
		NW.Shared[objPl][strDataType][strIndex] = varVal
		umsg.Start("SetPlayerShared"..strDataType,objPl)
			umsg.String(strIndex) --Now indexed, so yeah just enforce this has to be a string, yada yada
			NW.DataTypeTranslate[strDataType](varVal)
		umsg.End()
	end
end
local function GetPlayerNW(objPl,strDataType,strIndex, optVal)
	return NW.Shared[objPl][strDataType][strIndex] or optVal
end
local meta = FindMetaTable("Player")
function meta:SetSharedInt(strIndex,numVal,bSetRarely)
	CheckPlayerNW(self)
	SetPlayerNW(self,"Int",strIndex,numVal,bSetRarely)
end
function meta:SetSharedFloat(strIndex,numVal,bSetRarely)
	CheckPlayerNW(self)
	SetPlayerNW(self,"Float",strIndex,numVal,bSetRarely)
end
function meta:SetSharedString(strIndex,strVal,bSetRarely)
	CheckPlayerNW(self)
	SetPlayerNW(self,"String",strIndex,strVal,bSetRarely)
end
function meta:SetSharedBool(strIndex,bVal,bSetRarely)
	CheckPlayerNW(self)
	SetPlayerNW(self,"Bool",strIndex,bVal,bSetRarely)
end
function meta:SetSharedVector(strIndex,vecVal,bSetRarely)
	CheckPlayerNW(self)
	SetPlayerNW(self,"Vector",strIndex,numVal,bSetRarely)
end
function meta:SetSharedVectorNormal(strIndex,vecVal,bSetRarely)
	CheckPlayerNW(self)
	SetPlayerNW(self,"VectorNormal",strIndex,vecVal,bSetRarely)
end
function meta:SetSharedAngle(strIndex,angVal,bSetRarely)
	CheckPlayerNW(self)
	SetPlayerNW(self,"Angle",strIndex,angVal,bSetRarely)
end
function meta:SetSharedChar(strIndex,chVal,bSetRarely)
	CheckPlayerNW(self)
	SetPlayerNW(self,"Char",strIndex,chVal,bSetRarely)
end
function meta:SetSharedEntity(strIndex,objEnt,bSetRarely)
	CheckPlayerNW(self)
	SetPlayerNW(self,"Entity",strIndex,objEnt,bSetRarely)
end


function meta:GetSharedInt(strIndex,numVal)
	CheckPlayerNW(self)
	GetPlayerNW(self,"Int",strIndex,numVal)
end
function meta:GetSharedFloat(strIndex,numVal)
	CheckPlayerNW(self)
	return GetPlayerNW(self,"Float",strIndex,numVal)
end
function meta:GetSharedString(strIndex,strVal)
	CheckPlayerNW(self)
	return GetPlayerNW(self,"String",strIndex,strVal)
end
function meta:GetSharedBool(strIndex,bVal)
	CheckPlayerNW(self)
	return GetPlayerNW(self,"Bool",strIndex,bVal)
end
function meta:GetSharedVector(strIndex,vecVal)
	CheckPlayerNW(self)
	return GetPlayerNW(self,"Vector",strIndex,numVal)
end
function meta:GetSharedVectorNormal(strIndex,vecVal)
	CheckPlayerNW(self)
	return GetPlayerNW(self,"VectorNormal",strIndex,vecVal)
end
function meta:GetSharedAngle(strIndex,angVal)
	CheckPlayerNW(self)
	return GetPlayerNW(self,"Angle",strIndex,angVal)
end
function meta:GetSharedChar(strIndex,chVal)
	CheckPlayerNW(self)
	return GetPlayerNW(self,"Char",strIndex,chVal)
end
function meta:GetSharedEntity(strIndex,objEnt)
	CheckPlayerNW(self)
	return GetPlayerNW(self,"Entity",strIndex,objEnt)
end

for _, strMessageName in pairs({
	"SetPlayerSharedInt",
	"SetPlayerSharedFloat",
	"SetPlayerSharedChar",
	"SetPlayerSharedAngle",
	"SetPlayerSharedEntity",
	"SetPlayerSharedVector",
	"SetPlayerSharedVectorNormal",
	"SetPlayerSharedString",
	"SetTeamSharedInt",
	"SetTeamSharedFloat",
	"SetTeamSharedChar",
	"SetTeamSharedAngle",
	"SetTeamSharedEntity",
	"SetTeamSharedVector",
	"SetTeamSharedVectorNormal",
	"SetTeamSharedString"
}) do
	umsg.PoolString(strMessageName)
end
