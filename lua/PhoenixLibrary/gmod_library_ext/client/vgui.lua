local tblHide = {}
local vguiHidden = false

hook.Add("Think",NAME,function ()
	if GameInEscape() and not vguiHidden then
		for k, v in pairs(tblHide) do
			v.prefvis = v.vgui:IsVisible() --Update vgui's 'preferred' visibility so we don't override it when we un-escape game
			if v.prefvis then
				v.vgui:SetVisible(false)
			end
		end
		vguiHidden = true
	elseif not GameInEscape() and vguiHidden then
		for k, v in pairs(tblHide) do
			if not v.vgui:IsVisible() and v.prefvis then --Only make it visible when it was visible before we escaped game
				v.vgui:SetVisible(true)
			end
		end
		vguiHidden = false
	end
end)

vgui.HideOnConsole = function (objVGUI, bHide)
	if bHide == nil then bHide = true end
	if bHide then
		for k, v in pairs(tblHide) do
			if v == objVGUI then
				return false
			end
		end
		local bVis = objVGUI:IsVisible()
		table.insert(tblHide,{vgui=objVGUI,prefvis=bVis})
		if bVis and vguiHidden then --We added this vgui element while console was open and we have HideOnConsole enabled for this vgui object, so we hide vgui.
			objVGUI:SetVisible(false)
		end
	else
		for k, v in pairs(tblHide) do
			if v == objVGUI then
				table.remove(tblHide,k)
				return true
			end
		end
	end
	return true
end