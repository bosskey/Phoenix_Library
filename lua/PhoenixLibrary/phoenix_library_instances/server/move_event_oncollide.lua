move.RegisterEvent("OnCollide")
move.SetDefault("LastVelAccel",Vector(0,0,0))
move.SetDefault("LastVelDelta",Vector(0,0,0))
move.SetDefault("LastVel",Vector(0,0,0))
move.SetDefault("VelAccelAvg",Vector(0,0,0))
move.SetDefault("VelDeltaAvg",Vector(0,0,0))
move.SetDefault("VelAvg",Vector(0,0,0))
local velStart

hook.Add("SetupMove",NAME,function (objPl, objMove)
	velStart = objPl:GetVelocity()
end)

hook.Add("Move",NAME,function (objPl, objMove)
end)

hook.Add("FinishMove",NAME,function (objPl, objMove)
	local velFinish = objPl:GetVelocity()
	local velLastAccel = objPl:GetMoveData("LastVelAccel",Vector(0,0,0))
	local velDelta = velFinish - velStart
	local velAccel = velDelta - objPl:GetMoveData("LastVelDelta",Vector(0,0,0))
	local velAvg = objPl:GetMoveData("VelAvg",Vector(0,0,0))
	if (velAccel.x < 0 or velAccel.y < 0) and velStart:Length() > velFinish:Length() then
		--print("hit something")
	end
	objPl:SetMoveData("VelDeltaAvg",(objPl:GetMoveData("VelDeltaAvg",Vector(0,0,0)) + velDelta)*.5)
	objPl:SetMoveData("VelAccelAvg",(objPl:GetMoveData("VelAccelAvg",Vector(0,0,0)) + velAccel)*.5)
	objPl:SetMoveData("VelAvg",(velAvg + velFinish)*.5)
	objPl:SetMoveData("LastVelDelta",velDelta)
	objPl:SetMoveData("LastVelAccel",velAccel)
	objPl:SetMoveData("LastVel",velFinish)
end)