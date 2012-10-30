
--[[
--Meh, its still pretty much theory.

function AverageOBBFromAngle( objEnt, angDir )
	local min, max = objEnt:OBBMins(), objEnt:OBBMaxs()
	local corners = {
		Vector( min.x, min.y, min.z ),
		Vector( min.x, min.y, max.z ),
		Vector( min.x, max.y, min.z ),
		Vector( min.x, max.y, max.z ),
		Vector( max.x, min.y, min.z ),
		Vector( max.x, min.y, max.z ),
		Vector( max.x, max.y, min.z ),
		Vector( max.x, max.y, max.z )
	}
	
	local minX, minY, maxX, maxY = ScrW(), ScrH(), 0, 0
	for _, corner in pairs( corners ) do
		local onScreen = ent:LocalToWorld( corner ):ToScreen()
		minX, minY = math.min( minX, onScreen.x ), math.min( minY, onScreen.y )
		maxX, maxY = math.max( maxX, onScreen.x ), math.max( maxY, onScreen.y )
	end
	
	return minX, minY, maxX, maxY
end

function AverageBonesFromAngle( objEnt, angDir )
end

]]

local quality = 9001 --OH SHIT
function VisibleEntity(objEnt)
	if not ValidEntity(objEnt) then return false end
	if objEnt:IsPlayer() then
		
	elseif objEnt:IsWeapon() then
		return objEnt:IsWeaponVisible()
	else
		
	end
	return false
end
