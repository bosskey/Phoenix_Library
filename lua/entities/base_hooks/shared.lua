ENT.Type = "anim"
ENT.Base = "base_anim"
--Example compatible function style
--[[
function ENT:Use(objActivator,objCaller)
	local valReturn = self.BaseClass:Initialize(objActivator,objCaller)
	--YOUR CODE WHATEVER
	return valReturn
end
]]
