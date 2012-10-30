
gamemode.AddHook("ScreenResized")

local last_numWidth, last_numHeight = ScrW(), ScrH()
local function fA()
	if ScrW() ~= last_numWidth or ScrH() ~= last_numHeight then
		gamemode.Call("ScreenResized",last_numWidth,last_numHeight,ScrW(),ScrH())
		last_numWidth = ScrW()
		last_numHeight = ScrH()
	end
end
hook.Add("Think",NAME,fA)