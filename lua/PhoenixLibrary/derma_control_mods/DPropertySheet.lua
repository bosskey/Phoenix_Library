
function PANEL:RemoveSheet(pnl)
	local index
	for k, v in pairs(self.Items) do
		if v.Panel and v.Panel == pnl then
			index = k
			break
		end
	end
	local oldTab = self.Items[index].Tab
	table.remove(self.Items,index)
	local newTab = self.Items[1].Tab
	newTab:GetPanel():SetVisible(true)
	newTab:GetPanel():SetAlpha( 255 )
	self.m_pActiveTab = newTab
	self.tabScroller:RemovePanel(oldTab)
	if oldTab then oldTab:Remove() end
	self:PerformLayout()
	newTab:GetPanel():InvalidateLayout()
	newTab:GetPanel():SetZPos( 100 )
end
