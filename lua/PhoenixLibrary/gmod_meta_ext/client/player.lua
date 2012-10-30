local meta = FindMetaTable("Player")

hook.Add("PlayerSwitchedWeapon","GetPhysBeam",function (objPl,objOld,objNew)
	if objNew:GetClass() == "weapon_physgun" then
		for _, objEnt in pairs(ents.GetAll()) do
			if objEnt:GetClass() == "physgun_beam" and objEnt:GetOwner() == objPl then
				objPl.PhysgunBeam = objEnt
				break
			end
		end
	end
end)

function meta:GetPhysBeam()
	if ValidEntity(self.PhysgunBeam) then
		return self.PhysgunBeam
	end
	return NULL
end

function meta:GetWeapon(strClass)
	local tblWeapons = self:GetWeapons()
	for k, v in pairs(tblWeapons) do
		if v:GetClass() == strClass then
			return v
		end
	end
	return NullEntity()
end

function meta:Notify(str,numType,clkLength)
	gamemode.Call("AddNotify",str,numType,clkLength)
end

usermessage.Hook("PhoenixNotify",function (um)
	gamemode.Call("AddNotify",um:ReadString(),um:ReadShort(),um:ReadFloat())
end)

local strSteamID, strIPAddress = "Unknown", "Unknown"
usermessage.Hook("ClientData",function (um)
	strSteamID, strIPAddress = um:ReadString(), um:ReadString()
end)
--[[
function meta:SteamID()	return strSteamID end
function meta:IPAddress() return strIPAddress end
]]
gamemode.Get('base')["PlayerRender"] = function () end
hook.Add("PlayerInitialized","SetupVisibilityEffect",function (objPl)
	if objPl != LocalPlayer() then
		local data = EffectData()
		data:SetEntity(objPl)
		util.Effect("player_visibility",data,true,true)
	end
end)

function meta:InFOV()
	if not self.VisibilityEffect then return false end
	return not (CurTime() - self.VisibilityEffect.LastRender > FrameTime())
end

local upvec = Vector(0,0,100)
function meta:GetCeilPos()
	return self:NearestPoint(self:GetPos() + upvec)
end


--TODO REMOVE
local tblCacheTrace = {}
hook.Add("Think","UpdateVisibilityTraceCache",function ()
	local trace = {start=LocalPlayer():EyePos(),filter={LocalPlayer()}}
	for k, v in pairs(player.GetAll()) do
		if v != LocalPlayer() then
			trace.endpos = v:EyePos()
			trace.filter[2] = v
			tblCacheTrace[v] = not util.TraceLine(trace).Hit
		end
	end
end)
--Maybe network serverside only call of player:Visible(otherPlayer)
function meta:IsVisible()
	return tblCacheTrace[self]
end
