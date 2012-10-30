
local meta = FindMetaTable("NPC")
function meta:Alive()
	return self:GetMoveType() ~= 0 --Only way to tell.
end

--[[
function meta:GetActiveWeapon()
	return self._activeweapon
end
]]