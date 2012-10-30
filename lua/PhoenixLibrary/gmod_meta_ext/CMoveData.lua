local meta = FindMetaTable("CMoveData")
function meta:AddVelocity(vecVelocity)
	self:SetVelocity(self:GetVelocity() + vecVelocity)
end