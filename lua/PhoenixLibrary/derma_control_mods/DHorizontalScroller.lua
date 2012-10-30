
function PANEL:RemovePanel(pnl)
	local index = nil
	for k, v in pairs(self.Panels) do
		if v == pnl then
			index = k
			break
		end
	end
	local tab = self.Panels[index]
	table.remove(self.Panels,index)
	if tab then	tab:Remove() end
end