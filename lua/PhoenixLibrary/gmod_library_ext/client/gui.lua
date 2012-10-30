--[[local bKeepClicker = false
local EnableScreenClicker = gui.EnableScreenClicker
gui.EnableScreenClicker = function (bOn)
	if not bKeepClicker then
		EnableScreenClicker(bOn)
	end
end
gui.KeepScreenClicker = function (bKeep)
	bKeepClicker = bKeep
end
]]