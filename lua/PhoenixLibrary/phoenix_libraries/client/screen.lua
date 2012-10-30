module("screen",package.seeall)

function ToVector(numX,numY,origin,angles,fov)
	angles = angles or RenderAngles()
	fov = fov or CL:GetFOV()
	local hFOV = fov*-.5 --LEAVE IT
	local hw = ScrW()*.5
	local hh = ScrH()*.5
	return util.TraceLine({start=origin,endpos=origin + (angles + Angle(((numY - hh)/hh)*hFOV,((numX - hw)/hw)*hFOV,0)):Forward()*16384,filter=CL}).HitPos
end

function VectorToPos(vecPos)
	local diff = RenderAngles():Difference(((vecPos - GetViewEntity():EyePos()):GetNormal()):Angle():GetNormal())
	local hh = ScrH()*.5
	local hw = ScrW()*.5
	local hFOV = CL:GetFOV()*.5
	return Position(hw + (-diff.y/hFOV)*hw,hh + (-diff.p/hFOV)*hh)
end

function GetPixelColor(numX,numY,origin,angles)
	origin = ForceVector(origin,EyePos())
	angles = ForceAngle(angles,RenderAngles())
	local vecDir = gui.ScreenToVector(numX,numY)
	local vecColor = render.GetSurfaceColor(origin,origin + angles:Forward()*3000)
	return Color(math.Round(vecColor.x*255),math.Round(vecColor.y*255),math.Round(vecColor.z*255))
end


--[[
	2Dimensional physics object, I hope to apply this to a dynamic GUI library or HUD configuration application in the future.
]]

local PhysObjects = {}
function Create2DPhysObject(tblVertices)

end
local function CheckCollision(x,y) --RETURN: bCollide, xhitnorm, yhitnorm
	--Check dynamic solids on screen

	--Check edges of screen
	if y<0 then
		return true, 0, 1
	elseif y>ScrH() then
		return true, 0, -1
	elseif x<0 then
		return true, 1, 0
	elseif x>ScrW() then
		return true, -1, 0
	end
	return false, 0, 0
end
hook.Add("Think",NAME,function ()
	for k, v in pairs(PhysObjects) do
		
	end
end)

local ScreenEffects = {}
local scrW, scrH = ScrW(), ScrH()
hook.Add("HUDPaintBackground",NAME,function ()
	scrW, scrH = ScrW(), ScrH()
	for k, v in pairs(ScreenEffects) do
		if v.active then
			local bOk, valReturn = pcall(v.draw,scrW,scrH)
			if not bOk then
				v.active = false
				ErrorNoHalt("screenEffect '"..tostring(k).."' failed : '"..tostring(valReturn).."'\n")
			end
		end
	end
end)

function Effect(strName,bOn)
	if ScreenEffects[strName] then
		ScreenEffects[strName].active = bOn == true
	end
end

function RegisterEffect(strName,funcDraw, bStartOn)
	if type(funcDraw) == "function" then
		ScreenEffects[strName] = {draw=funcDraw,active=bStartOn==true}
	end
end
