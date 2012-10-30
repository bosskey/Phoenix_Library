

module("spawns",package.seeall)
local Spawns = {}
local PlayerData = {}

function AddTeam(numTeam,tblSpawnPoints)
	Spawns[numTeam] = tblSpawnPoints
end

hook.Add("PlayerSelectSpawn",NAME,function (objPl)
	PlayerData[objPl] = objSpawn
end)