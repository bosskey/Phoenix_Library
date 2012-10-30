
local numGravity = 515.2
cvars.AddChangeCallback("sv_gravity",function (cvar,vOld,vNew)
	numGravity = (vNew/600)*515.2
end)
--Maybe force phys_timescale on all phys methods...that pertain to it.
phys.AddMethod("Gravity",function (vecVel,fDelta)
	return Vector(vecVel.x,vecVel.y,vecVel.z - numGravity*fDelta)
end)