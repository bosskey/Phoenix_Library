gamemode.AddHook("ConsoleOpened","ConsoleClosed")

local bWasOpen, bConsole = SafeCall(GameInEscape), false
local function fA()
	bConsole = GameInEscape()
	if bConsole and not bWasOpen then
		gamemode.Call("ConsoleOpened")
		bWasOpen = true
	elseif not bConsole and bWasOpen then
		gamemode.Call("ConsoleClosed")
		bWasOpen = false
	end
end
hook.Add("Think",NAME,fA)