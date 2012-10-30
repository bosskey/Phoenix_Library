move.RegisterEvent("WallJump")
move.RegisterEvent("WallHit")
move.SetDefault("LastWallJump",0)
move.SetDefault("WallJumpDelay",.3)
move.SetDefault("WallJumpPower",300)
--[[
hook.Add("KeyPress",NAME,function (objPl, numKey)
	if numKey == IN_JUMP and not objPl:OnGround() then
		local lastWallJump = objPl:GetMoveData("LastWallJump",0)
		local wallJumpDelay = objPl:GetMoveData("WallJumpDelay",.6)
		local wallJumpPower = objPl:GetMoveData("WallJumpPower",300)
		if Time(lastWallJump) > wallJumpDelay then
			local pos = objPl:GetPos()
			local numWallMaxDist = 25
			local vecAim = objPl:GetAimVector()
			local vecAim2D = vecAim:GetNoZ()
			local traceData1 = {start=pos,endpos=pos + vecAim2D*1000,filter=objPl}
			local traceData2 = {start=pos,endpos=pos + vecAim2D*-1000,filter=objPl}
			local tr, dist, index = GetShortestTrace(util.TraceLine(traceData1),util.TraceLine(traceData2))
			if dist < numWallMaxDist + 16 and objPl:GetGroundDistance() > 10 and tr.HitNormal.x ~= 0 and tr.HitNormal.y ~= 0 then
				--objPl:SetAnimation(ACT_MP_DOUBLEJUMP) -- does not work
				local vecWallAim = vecAim
				if index == 1 then
					vecWallAim = vecWallAim*-1
				end
				vecWallAim.z = math.Clamp(vecWallAim.z,-.2,.75)
				local dir = tr.HitNormal:AddAngle((tr.HitNormal:Angle()):Difference(vecWallAim:Angle()))
				local vel = dir*wallJumpPower --*(1 - math.Clamp(Time(lastJump)/wallJumpDelay,0,1))
				objPl:SetVelocity(vel)
				objPl:SetMoveData("LastWallJump",CurTime())
			end
		end
	end
end)
]]