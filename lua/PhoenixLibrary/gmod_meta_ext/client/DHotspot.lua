	
	local PANEL = {}
	
	Derma_Hook( PANEL, 	"Paint", 				"Paint", 	"DHotspot" )
	Derma_Hook( PANEL, 	"ApplySchemeSettings", 	"Scheme", 	"DHotspot" )
	Derma_Hook( PANEL, 	"PerformLayout", 		"Layout", 	"DHotspot" )
	
	function PANEL:Init()
		self.Hotspots = {}
		self.WasOnHotspotLast = false
		self.CurrentHotspotPressed = nil
	end
	
	function PANEL:GetHotspotAtPos(x,y)
		for k, v in pairs(self.Hotspots) do
			if x > v.x and x < v.x+v.w and y > v.y and y < v.y+v.h then
				return k
			end
		end
	end
	function PANEL:OnCursorMoved(x,y)
		if not self.WasOnHotspotLast and GetHotspotAtPos(x,y) then
			self:SetCursor("hand")
			self.WasOnHotspotLast = true
		elseif self.WasOnHotspotLast and not GetHotspotAtPos(x,y) then
			self:SetCursor("arrow")
			self.WasOnHotspotLast = false
		end
	end
	
	function PANEL:AddHotspot(x,y,w,h,funcCallback)
		table.insert(self.Hotspots,{x=x,y=y,w=w,h=h,callback=funcCallback})
	end
	
	function PANEL:OnMousePressed(mc)
		if mc == 107 then
			self.CurrentHotspotPressed = self:GetHotspotAtPos(self:CursorPos())
		end
	end
	
	function PANEL:OnMouseReleased(mc)
		if mc == 107 and self.CurrentHotspotPressed then
			self.Hotspots[self.CurrentHotspotPressed].callback()
			self.CurrentHotspotPressed = nil
		end
	end
	
	function PANEL:Setup( ply )
		self:InvalidateLayout()
	end
	
	derma.DefineControl( "DHotspot", "", PANEL, "DPanel" )