
local DefaultMaxBytes = 512
local LongCCs = {}
local SESSION_MAXBYTES = 253

hook.Add("PlayerInitialSpawn","SetupLongCCs",function (objPl)
	objPl.CurrentLongCommand = {name = nil,numargs = 0,args = {}}
end)

local function CommandExists(strName)
	return LongCCs[strName] ~= nil
end

local function CommandCall(objPl,strName,tblArgs)
	local func = LongCCs[strName].func
	if type(func) == "function" then
		func(objPl,strName,tblArgs)
	else
		ErrorNoHalt("CommandCall: invalid callback function\n")
	end
end

concommand.AddLong = function (strName,funcCallback,numMaxBytes)
	if type(funcCallback) == "function" then
		numMaxBytes = numMaxBytes or DefaultMaxBytes
		LongCCs[strName] = {func=funcCallback,max=numMaxBytes}
	end
end

concommand.RemoveLong = function (strName)
	LongCCs[strName] = nil
end

concommand.Add("~cs",function (objPl,strCmd,tblArgs) --Command Start
	if ValidEntity(objPl) and objPl:EntIndex() ~= 0 and not objPl.CurrentLongCommand.name then
		local strName = tblArgs[1]
		if CommandExists(strName) then
			local numArgs = tonumber(tblArgs[2])
			if numArgs and numArgs > 0 then
				objPl.CurrentLongCommand = {name = strName,numargs = numArgs,args = {}}
			end
		end
	end
end)

concommand.Add("~cd",function (objPl,strCmd,tblArgs) --Command Data
	if ValidEntity(objPl) and objPl:EntIndex() ~= 0 and objPl.CurrentLongCommand.name then
		objPl.CurrentLongCommand.args = table.Add(objPl.CurrentLongCommand.args,tblArgs)
	end
end)

concommand.Add("~ce",function (objPl,strCmd,tblArgs) --Command End
	if ValidEntity(objPl) and objPl:EntIndex() ~= 0 and objPl.CurrentLongCommand.name then
		CommandCall(objPl,objPl.CurrentLongCommand.name,objPl.CurrentLongCommand.args)
		objPl.CurrentLongCommand = {name=nil,numargs=-1,args={}}
	end
end)


