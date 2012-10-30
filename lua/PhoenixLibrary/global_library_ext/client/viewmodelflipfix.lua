
function VMFlipFix(vmAng,viewAng)
	viewAng = viewAng or RenderAngles() -- renderangles is not updated fast enough to be a permanent alternative, so send calcview final angle
	return Angle(vmAng.p,viewAng.y - (vmAng.y - viewAng.y),vmAng.r)
end