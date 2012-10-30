
local tblPipeSlots = {}
local bPiping = false
--Add a pipe slot, dont be stupid, this is for serious networking business, broseph.
function umsg.PipeSlot(strName,funcCallback)
	if type(funcCallback) ~= "function" then error(2,"arg #2 must be a valid function!") end
	tblPipeSlots[strName] = funcCallback
	bPiping = true
end

local TICK_SKIP = 33 --1 per second? on most servers
local NEXT_TICK = 0
local bOk, valReturn
hook.Add("Tick",NAME,function ()
	NEXT_TICK = NEXT_TICK - 1
	if NEXT_TICK > 0 then return end
	NEXT_TICK = TICK_SKIP
	if !bPiping then return end
	for _, objPl in pairs(player.GetAll()) do
		umsg.Start('usermessage_pipe',objPl)
			for strName, funcCallback in pairs(tblPipeSlots) do
				local bOk, valReturn = pcall(funcCallback,objPl)
				if not bOk then
					ErrorNoHalt("Usermessage Pipe-Slot failed '"..strName.."' : '"..tostring(valReturn).."'\n")
				end
			end
		umsg.End()
	end
end)
