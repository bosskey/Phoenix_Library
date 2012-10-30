module("mouse",package.seeall)
local Mouse = {}

--I'm thinking about caching this...instead of a free-call, run it in a think..yada yada yada
function GetTrace(origin,angles,fov)
	origin = origin or GetViewEntity():EyePos()
	angles = angles or RenderAngles()
	fov = fov or CL:GetFOV()
	local hFOV = fov*-.5 --LEAVE IT
	local w = ScrW()*.5
	local h = ScrH()*.5
	return util.TraceLine({start=origin,endpos=origin+((angles + Angle(((gui.MouseY() - h)/h)*hFOV,((gui.MouseX() - w)/w)*hFOV,0)):GetNormal()):Forward()*16384,filter=CL})
end
