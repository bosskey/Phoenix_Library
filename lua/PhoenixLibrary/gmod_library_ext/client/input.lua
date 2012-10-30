
local bScoreboard, bChat = false, false
hook.Add("ScoreboardShow",NAME,function () bScoreboard = true end)
hook.Add("ScoreboardHide",NAME,function () bScoreboard = false end)
hook.Add("StartChat",NAME,function () bChat = true end)
hook.Add("FinishChat",NAME,function () bChat = false end)

function input.IsGameEnv() --if you don't have any menus open etc
	return not GameInEscape() and not bScoreboard and not bChat and not vgui.GetKeyboardFocus()
end

function input.IsInputDown(numInput) --used for my hax atleast, it'll be useful down the road...
	if numInput > 106 then
		return input.IsMouseDown(numInput)
	end
	return input.IsKeyDown(numInput)
end
