local meta = FindMetaTable("Player")

hook.Add("PlayerInitialSpawn","META_PLAYER",function (objPl)
	objPl.Keys = {}
	--[[for _, v in pairs({IN_ALT1,IN_ALT2,IN_ATTACK,IN_ATTACK2,IN_BACK,IN_BULLRUSH,IN_CANCEL,IN_DUCK,IN_FORWARD,IN_GRENADE1,IN_GRENADE2,IN_JUMP,IN_LEFT,IN_MOVELEFT,IN_MOVERIGHT,IN_RELOAD,IN_RIGHT,IN_RUN,IN_SCORE,IN_SPEED,IN_USE,IN_WALK,IN_WEAPON1,IN_WEAPON2,IN_ZOOM}) do
		objPl.Keys[v] = {lastPress = 0,lastRelease = 0,lastDownLength = 0}
	end]]
	umsg.Start("ClientData",objPl)
		umsg.String(objPl:SteamID())
		umsg.String(objPl:IPAddress())
	umsg.End()
end)

hook.Add("KeyPress","META_PLAYER",function (objPl, numKey)
	if not objPl.Keys[numKey] then objPl.Keys[numKey] = {lastPress = 0,lastRelease = 0,lastDownLength = 0} end
	objPl.Keys[numKey].lastPress = CurTime()
end)

hook.Add("KeyRelease","META_PLAYER",function (objPl, numKey)
	objPl.Keys[numKey].lastRelease = CurTime()
	objPl.Keys[numKey].lastDownLength = CurTime() - objPl.Keys[numKey].lastPress
end)

function meta:KeyLastPressed(numKey)
	return self.Keys[numKey].lastPress
end

function meta:KeyLastReleased(numKey)
	return self.Keys[numKey].lastRelease
end

function meta:KeyLastDownLength(numKey)
	return self.Keys[numKey].lastDownLength
end

umsg.PoolString("PhoenixNotify")
function meta:Notify(str,numType,clkLength)
	umsg.Start("PhoenixNotify",self)
		umsg.String(str)
		umsg.Short(numType)
		umsg.Float(clkLength)
	umsg.End()
end