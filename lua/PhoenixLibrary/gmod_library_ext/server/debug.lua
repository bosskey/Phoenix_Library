--EPIC!
local Debug_Control = {}
debug.AddControl = function (strName,bOn) Debug_Control[strName] = bOn == true end
debug.GetControl = function (strName) return Debug_Control[strName] end

concommand.Add("phxlib_debug",function (objPl,strCmd,tblArgs)
	local strName, bOn = tblArgs[1], tblArgs[2] == "1"
	if Debug_Control[strName] ~= nil then
		
	else
		objPl:PrintMessage(HUD_PRINTCONSOLE,"PhoenixLibrary - debugcontrol '"..strName.."' does not exist")
	end
end)
