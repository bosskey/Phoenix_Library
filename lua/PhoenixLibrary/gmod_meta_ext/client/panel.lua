local meta = FindMetaTable("Panel")

function meta:HideOnConsole(bOn)
	return vgui.HideOnConsole(self,bOn)
end

local AttGet = {
	["x"] = function (p) local x, y = p:GetPos() return x end,
	["y"] = function (p) local x, y = p:GetPos() return y end,
	["w"] = meta.GetWide,
	["h"] = meta.GetTall,
	["alpha"] = meta.GetAlpha
}
--[[
function meta:Animate(tblAtt,tLen, fCallback)
	self._anim = {eTime=CurTime()+tLen,callback=fCallback}
	for k, v in pairs(tblAtt) do
		if AttGet[k] then
			self[k]
		end
	end
end
]]