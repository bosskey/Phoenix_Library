local tblPipeSlots = {}

function usermessage.PipeHook(strName,funcCallback)
	if type(funcCallback) ~= "function" then error(2,"arg #2 must be a valid function!") end
	tblPipeSlots[strName] = funcCallback
end

usermessage.Hook('usermessage_pipe',function (um)
	for strName, funcCallback in pairs(tblPipeSlots) do
		local bOk, valReturn = pcall(funcCallback,um)
		if not bOk then
			ErrorNoHalt("Usermessage Pipe-Slot failed '"..strName.."' : '"..tostring(valReturn).."'\n")
		end
	end
end)