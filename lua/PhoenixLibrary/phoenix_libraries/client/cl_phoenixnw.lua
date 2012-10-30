local NW = {
	Shared = {
		Angle={},Bool={},Char={},Entity={},Float={},Int={},String={},Vector={},VectorNormal={}
	},
	Team = {
		Angle={},Bool={},Char={},Entity={},Float={},Int={},String={},Vector={},VectorNormal={}
	},
	MyTeam = 0
}
hook.Add("InitPostEntity",NAME,function ()
	--LocalPlayer():ConCommand("~initnetworking\n")
	NW.MyTeam = LocalPlayer():Team()
end)

hook.Add("Think",NAME,function ()
	local numTeam = CL:Team()
	if numTeam ~= NW.MyTeam then
		NW.Team = {Angle={},Bool={},Char={},Entity={},Float={},Int={},String={},Vector={},VectorNormal={}}
		NW.MyTeam = numTeam
	end
end)

if type(team) == "table" then
	function GetTeamSharedInt(strIndex,varVal)
		return NW.Team.Int[strIndex] or varVal or 0
	end
	function GetTeamSharedFloat(strIndex,varVal)
		return NW.Team.Float[strIndex] or varVal or 0.0
	end
	function GetTeamSharedBool(strIndex,varVal)
		return NW.Team.Bool[strIndex] or varVal or false
	end
	function GetTeamSharedVector(strIndex,varVal)
		return NW.Team.Vector[strIndex] or varVal or Vector(0,0,0)
	end
	function GetTeamSharedVectorNormal(strIndex,varVal)
		return NW.Team.VectorNormal[strIndex] or varVal or Vector(0,0,0)
	end
	function GetTeamSharedEntity(strIndex,varVal)
		return NW.Team.Entity[strIndex] or varVal or NULL
	end
	function GetTeamSharedChar(strIndex,varVal)
		return NW.Team.Char[strIndex] or varVal or ''
	end
	function GetTeamSharedString(strIndex,varVal)
		return NW.Team.String[strIndex] or varVal or ""
	end
end

usermessage.Hook("SetTeamSharedInt",function (um)
	NW.Team.Int[um:ReadString()] = um:ReadLong()
end)

usermessage.Hook("SetTeamSharedFloat",function (um)
	NW.Team.Float[um:ReadString()] = um:ReadFloat()
end)

usermessage.Hook("SetTeamSharedBool",function (um)
	NW.Team.Bool[um:ReadString()] = um:ReadBool()
end)

usermessage.Hook("SetTeamSharedVector",function (um)
	NW.Team.Bool[um:ReadString()] = um:ReadVector()
end)

usermessage.Hook("SetTeamSharedVectorNormal",function (um)
	NW.Team.Bool[um:ReadString()] = um:ReadVectorNormal()
end)

usermessage.Hook("SetTeamSharedAngle",function (um)
	NW.Team.Bool[um:ReadString()] = um:ReadAngle()
end)

usermessage.Hook("SetTeamSharedEntity",function (um)
	NW.Team.Bool[um:ReadString()] = um:ReadEntity()
end)

usermessage.Hook("SetTeamSharedChar",function (um)
	NW.Team.Bool[um:ReadString()] = um:ReadChar()
end)

usermessage.Hook("SetTeamSharedString",function (um)
	NW.Team.Bool[um:ReadString()] = um:ReadString()
end)

usermessage.Hook("SendTeamSharedBools",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetTeamSharedBool",um)
	end
end)

usermessage.Hook("SendTeamSharedInts",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetTeamSharedInt",um)
	end
end)

usermessage.Hook("SendTeamSharedFloats",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetTeamSharedFloat",um)
	end
end)

usermessage.Hook("SendTeamSharedChars",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetTeamSharedChar",um)
	end
end)

usermessage.Hook("SendTeamSharedAngles",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetTeamSharedAngle",um)
	end
end)

usermessage.Hook("SendTeamSharedEntities",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetTeamSharedEntity",um)
	end
end)

usermessage.Hook("SendTeamSharedVectors",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetTeamSharedVector",um)
	end
end)

usermessage.Hook("SendTeamSharedVectorNormals",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetTeamSharedVectorNormal",um)
	end
end)

usermessage.Hook("SendTeamSharedStrings",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetTeamSharedString",um)
	end
end)

	function GetPlayerSharedInt(strIndex,varVal)
		return NW.Shared.Int[strIndex] or varVal or 0
	end
	function GetPlayerSharedFloat(strIndex,varVal)
		return NW.Shared.Float[strIndex] or varVal or 0.0
	end
	function GetPlayerSharedBool(strIndex,varVal)
		return NW.Shared.Bool[strIndex] or varVal or false
	end
	function GetPlayerSharedVector(strIndex,varVal)
		return NW.Shared.Vector[strIndex] or varVal or Vector(0,0,0)
	end
	function GetPlayerSharedVectorNormal(strIndex,varVal)
		return NW.Shared.VectorNormal[strIndex] or varVal or Vector(0,0,0)
	end
	function GetPlayerSharedEntity(strIndex,varVal)
		return NW.Shared.Entity[strIndex] or varVal or NULL
	end
	function GetPlayerSharedChar(strIndex,varVal)
		return NW.Shared.Char[strIndex] or varVal or ''
	end
	function GetPlayerSharedString(strIndex,varVal)
		return NW.Shared.String[strIndex] or varVal or ""
	end


usermessage.Hook("SetPlayerSharedInt",function (um)
	NW.Shared.Int[um:ReadString()] = um:ReadLong()
end)

usermessage.Hook("SetPlayerSharedFloat",function (um)
	NW.Shared.Float[um:ReadString()] = um:ReadFloat()
end)

usermessage.Hook("SetPlayerSharedBool",function (um)
	NW.Shared.Bool[um:ReadString()] = um:ReadBool()
end)

usermessage.Hook("SetPlayerSharedVector",function (um)
	NW.Shared.Bool[um:ReadString()] = um:ReadVector()
end)

usermessage.Hook("SetPlayerSharedVectorNormal",function (um)
	NW.Shared.Bool[um:ReadString()] = um:ReadVectorNormal()
end)

usermessage.Hook("SetPlayerSharedAngle",function (um)
	NW.Shared.Bool[um:ReadString()] = um:ReadAngle()
end)

usermessage.Hook("SetPlayerSharedEntity",function (um)
	NW.Shared.Bool[um:ReadString()] = um:ReadEntity()
end)

usermessage.Hook("SetPlayerSharedChar",function (um)
	NW.Shared.Bool[um:ReadString()] = um:ReadChar()
end)


usermessage.Hook("SetPlayerSharedString",function (um)
	NW.Shared.Bool[um:ReadString()] = um:ReadString()
end)

usermessage.Hook("SendPlayerSharedBools",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetPlayerSharedBool",um)
	end
end)

usermessage.Hook("SendPlayerSharedInts",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetPlayerSharedInt",um)
	end
end)

usermessage.Hook("SendPlayerSharedFloats",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetPlayerSharedFloat",um)
	end
end)

usermessage.Hook("SendPlayerSharedChars",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetPlayerSharedChar",um)
	end
end)

usermessage.Hook("SendPlayerSharedAngles",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetPlayerSharedAngle",um)
	end
end)

usermessage.Hook("SendPlayerSharedEntities",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetPlayerSharedEntity",um)
	end
end)

usermessage.Hook("SendPlayerSharedVectors",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetPlayerSharedVector",um)
	end
end)

usermessage.Hook("SendPlayerSharedVectorNormals",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetPlayerSharedVectorNormal",um)
	end
end)

usermessage.Hook("SendPlayerSharedStrings",function (um)
	local num = um:ReadShort()
	for i=1, num do
		usermessage.IncomingMessage("SetPlayerSharedString",um)
	end
end)
