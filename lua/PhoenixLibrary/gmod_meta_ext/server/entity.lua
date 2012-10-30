local meta = FindMetaTable("Entity")
meta._bCanuse = true
function meta:SetCanUse(bAllow)
	self._bCanuse = bAllow == true
end

function meta:GetCanUse()
	return self._bCanuse
end
meta._bVisUpdate = false
function meta:EnableVisibilityUpdates(bOn)
	self._bVisUpdate = bOn == true
end
umsg.PoolString("__ent_visibility")
local tblVisible = {}
local tblVisiblePlayer = {}

local NEXT_THINK = 0
hook.Add("Think",NAME,function ()
	if CurTime() < NEXT_THINK then return end
	NEXT_THINK = CurTime() + 1
	
	-- Do check
	
end)
