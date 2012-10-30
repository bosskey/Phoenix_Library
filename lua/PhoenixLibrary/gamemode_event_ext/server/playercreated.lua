local Created = {}
gamemode.AddHook("PlayerCreated")
local function fA(objEnt)
	if objEnt:IsPlayer() and not Created[objEnt] then
		Created[objEnt] = true
		gamemode.Call("PlayerCreated",objEnt)
	end
end
hook.Add("OnEntityCreated",NAME,fA)