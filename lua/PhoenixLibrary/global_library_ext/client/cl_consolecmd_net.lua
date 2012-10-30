
local QueuedCmds = {}
local RunConsoleCommand = _G.RunConsoleCommand
local SendingCommand = false
local CurrentCommand = nil
local SESSION_MAXBYTES = 253 - 3 --Added -3 so the ~ce command can run

function RunConsoleCommandLong(strCmd,...) --For arguments in excess of x bytes in size.
	local str = table.concat({...}," ")
	local tbl = {cmd = strCmd,bytesSent = 0,lastArg = 0}
	tbl.args = string.Explode(" ",str)
	tbl.numArgs = table.getn(tbl.args)
	tbl.bytes = string.len(str)
	table.insert(QueuedCmds,tbl)
end

hook.Add("Tick","SendLongConsoleCommands",function ()
	local numBytes = 0
	if not SendingCommand and #QueuedCmds > 0 then
		SendingCommand = true
		CurrentCommand = table.Copy(QueuedCmds[1])
		table.remove(QueuedCmds,1)
		local strArgCount = tostring(table.getn(CurrentCommand.args))
		numBytes = 5 + string.len(CurrentCommand.cmd) + string.len(strArgCount)
		RunConsoleCommand("~cs",CurrentCommand.cmd,strArgCount)
	end
	if SendingCommand then
		if CurrentCommand.argsSent < CurrentCommand.numArgs then
			local tblSendArgs = {}
			local bFinished = true
			for i=CurrentCommand.lastarg, CurrentCommand.numArgs do
				local strArg = CurrentCommand.args[i]
				numBytes = numBytes + string.len(strArg) + i - 1
				if numBytes > SESSION_MAXBYTES then --maybe 255
					CurrentCommand.lastarg = i
					bFinished = false
					break
				end
				table.insert(tblSendArgs,strArg)
			end
			CurrentCommand.bytesSent = CurrentCommand.bytesSent + bytesCount
			RunConsoleCommand("~cd",CurrentCommand.cmd,unpack(tblSendArgs))
			if not bFinished then
				return
			end
		end
		SendingCommand = false
		RunConsoleCommand("~ce")
	end
end)
