local CC = {
	cmds = {},
	methods = {
		["boolean"] = {},
		["number"] = {},
		["string"] = {},
		--["plselect"] = {} --no archive
	}
}
CC.methods["boolean"].GetOutput = function (strCmd)
	return "\""..strCmd.."\" = \""..(CC.cmds[strCmd].val and '1' or '0').."\"\nCC_Bool"
end
CC.methods["number"].GetOutput = function (strCmd)
	return "\""..strCmd.."\" = \""..(CC.cmds[strCmd].val).."\"\nCC_Number"
end
CC.methods["string"].GetOutput = function (strCmd)
	return "\""..strCmd.."\" = \""..(CC.cmds[strCmd].val).."\"\nCC_String"
end

CC.methods['boolean'].Load = function (v)
	return v == '1'
end
CC.methods['number'].Load = function (v)
	return tonumber(v) or 0
end
CC.methods['string'].Load = function (v)
	return v
end

CC.methods['boolean'].Save = function (v)
	return v and '1' or '0'
end
CC.methods['number'].Save = function (v)
	return tostring(v)
end
CC.methods['string'].Save = function (v)
	return tostring(v)
end

--[[
local file = file
local string = string
local pairs = pairs
local concommand = concommand
local type = type
local Entity = Entity
local Condition = Condition --Phoenixlib
]]
module("cc",package.seeall)

local function Load(strType)
	if type(strType) ~= "string" then return end
	if file.Exists("PhoenixLibrary/cc/archive/"..strType..".txt") then
		local strFile = file.Read("PhoenixLibrary/cc/archive/"..strType..".txt")
		for _, line in pairs(string.Explode("\n",strFile)) do
			local k, v = string.match(line,"([%w_]+)=(.+)")
			if k then
				CC.cmds[k]={type=strType,archive=true,val=CC.methods[strType].Load(v)}
			end
		end
	else
		file.Write("PhoenixLibrary/cc/archive/"..strType..".txt","")
	end
end

for k, _ in pairs(CC.methods) do
	Load(k)
end

local function Save(strType)
	if CC.cmds and type(strType) == 'string' and CC.methods[strType] then
		local str = ''
		for k, v in pairs(CC.cmds) do
			if v.archive and v.type==strType then
				str = str..k..'='..CC.methods[strType].Save(v.val)..'\n'
			end
		end
		file.Write("PhoenixLibrary/cc/archive/"..strType..".txt",str)
	end
end

concommand.Add("findcc",function (objPl,strCmd,tblArgs)
	if #tblArgs == 1 then
		local strOutput = ""
		local strFind = tblArgs[1]
		for strCmd, tblData in pairs(CC.cmds) do
			if string.find(strCmd,strFind) or (tblData.desc and string.find(tblData.desc,strFind)) then
				strOutput = strOutput..CC.methods[tblData.type].GetOutput(strCmd)..'\n'
			end
		end
		if strOutput ~= "" then
			objPl:PrintMessage(HUD_PRINTCONSOLE,strOutput)
		else
			objPl:PrintMessage(HUD_PRINTCONSOLE,"findcc: unable to find any matches to "..strFind.."\n")
		end
		return
	end
	objPl:PrintMessage(HUD_PRINTCONSOLE,"Usage: findcc <string>\n")
end)

concommand.Add("helpcc",function (objPl,strCmd,tblArgs)
	if #tblArgs == 1 then
		local strOutput, strCmdQuery = '', string.lower(tblArgs[1])
		for strCmd, v in pairs(CC.cmds) do
			if string.lower(strCmd) == strCmdQuery then
				objPl:PrintMessage(HUD_PRINTCONSOLE,CC.methods[v.type].GetOutput(strCmd).."\n")
				return
			end
		end
		objPl:PrintMessage(HUD_PRINTCONSOLE,"helpcc: no cvar or command named "..tostring(tblArgs[1]).."\n")
		return
	end
	objPl:PrintMessage(HUD_PRINTCONSOLE,"Usage: helpcc <cvarname>\n")
end)

local TypeTranslate = {
	["boolean"] = function (tblArgs) return tblArgs[1] == '1' end,
	["number"] = function (tblArgs) return tonumber(tblArgs[1]) end,
	["string"] = function (tblArgs) return table.concat(tblArgs) end
}

local function CC_Callback(objPl,strCmd,tblArgs)
	if #tblArgs > 0 then
		CC.cmds[strCmd].val = CC.methods[CC.cmds[strCmd].type].Load(table.concat(tblArgs,' '))
		if type(CC.cmds[strCmd].callback) == 'function' then
			local bOk, valReturn = pcall(CC.cmds[strCmd].callback,(CLIENT and objPl) or Entity(0),strCmd,CC.cmds[strCmd].val)
			if not bOk then
				ErrorNoHalt("CC callback '"..strCmd.."' failed : "..tostring(valReturn).."\n")
			end
		end
		Save(CC.cmds[strCmd].type)
	else
		objPl:PrintMessage(HUD_PRINTCONSOLE,CC.methods[CC.cmds[strCmd].type].GetOutput(strCmd).."\n")
	end
end
local TranslateAutoComplete = {
	["boolean"] = function (strCmd) return {strCmd.." 1",strCmd.." 0"} end,
	['number'] = function (strCmd) return {strCmd.." #"} end,
	["string"] = function (strCmd) return {strCmd.." <string>"} end
}
local function CC_AutoComplete(strCmd,strArgs)
	if string.len(strArgs) > 1 then return {} end
	return TranslateAutoComplete[CC.cmds[strCmd].type](strCmd)
end

--All the shit above this is depreciated...new dynamic type definition for concommands
function AddVar(strCmd,varDefault, bArchive, funcCallback, strDesc)
	local bNew = true
	if CC.cmds[strCmd] ~= nil then varDefault = CC.cmds[strCmd].val	bNew=false end --Allows it to load pre-existing commands' values.
	CC.cmds[strCmd] = {type=type(varDefault),val=varDefault,callback=funcCallback,archive=FORCE(bArchive,true),desc=FORCE(strDesc,"N/A")}
	if type(funcCallback)=='function' then
		local bOk, valReturn = pcall(funcCallback,(CLIENT and LocalPlayer()) or Entity(0),strCmd,varDefault)
		if not bOk then
			ErrorNoHalt("CC callback '"..strCmd.."' failed : "..tostring(valReturn).."\n")
		end
	end
	concommand.Add(strCmd,CC_Callback,CC_AutoComplete)
	if bArchive == true and bNew then Save(type(varDefault)) end
end

function RemoveVar(strCmd)
	if CC.cmds[strCmd] ~= nil then
		concommand.Remove(strCmd)
		local bArchive = CC.cmds[strCmd].archive
		local oldtype = CC.cmds[strCmd].type
		CC.cmds[strCmd] = nil
		if bArchive then Save(oldtype) end
	end
end

function GetVar(strCmd)
	if CC.cmds[strCmd] then
		return CC.cmds[strCmd].val
	end
end

function SetVar(strCmd,newVal)
	if CC.cmds[strCmd] and type(newVal)==CC.cmds[strCmd].type then
		CC.cmds[strCmd].val = newVal
	end
end

function Exists(strCmd)
	return CC.cmds[strCmd or ''] ~= nil
end