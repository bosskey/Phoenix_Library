gamemode.AddHook("PlayerInitialSpawn")
local tblPlayers = {}
local function fA(objEnt)
	if ValidEntity(objEnt) and objEnt:IsPlayer() and not tblPlayers[objEnt] then
		gamemode.Call("PlayerInitialSpawn",objEnt)
		tblPlayers[objEnt] = true
	end
end
hook.Add("OnEntityCreated",NAME,fA)