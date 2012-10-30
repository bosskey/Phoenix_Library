AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local myclass = "conveyor_machine"

concommand.Add("conveyor_setspeed",function (objPl,s,tblArgs)
	if objPl:IsAdmin() then
		local conv = objPl:GetEyeTrace().Entity
		if ValidEntity(conv) and conv:GetClass() == myclass then
			conv.Speed = tonumber(tblArgs[1]) or 2
		end
	end
end)

concommand.Add("conveyor_setfriction",function (objPl,s,tblArgs)
	if objPl:IsAdmin() then
		local conv = objPl:GetEyeTrace().Entity
		if ValidEntity(conv) and conv:GetClass() == myclass then
			conv.Friction = tonumber(tblArgs[1]) or .5
		end
	end
end)

function ENT:SpawnFunction( ply, tr )
	if not tr.Hit then return end
	local ent = ents.Create( myclass )
	ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self.Entity:SetModel(Model("models/props_junk/TrashDumpster02b.mdl"))
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	--self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self.Speed = 2000
	self.Friction = .2 --Looks more realistic...simulated accelleration
	self.TouchingObjects = {}
end
local vecOrigin, vecDown = Vector(0,0,0), Vector(0,0,-100)
function ENT:ApplyConveyorPhysics(objEnt, fDelta)
	local objPhys = objEnt:GetPhysicsObject()
	if objPhys:IsValid() then
		local dir = self.Entity:GetForward()
		local velEnt = objEnt:GetVelocity()
		local numMass = objPhys:GetMass()
		local spdBelt = numMass*self.Speed
		local velBelt = dir*spdBelt
		local spdEntOnBelt = dir:DotProduct(velEnt)
		if spdEntOnBelt < spdBelt then
			--local tr = util.TraceEntity({start=objEnt:GetPos(),endpos=objEnt:GetPos()+(self.Entity:GetPos() - objEnt:GetPos()):GetNormal()*100,filter=objEnt},objEnt)
			objPhys:ApplyForceCenter(dir*(spdBelt - spdEntOnBelt)*self.Friction*fDelta)
		end
	end
end

function ENT:StartTouch(objEnt)
	if objEnt:GetClass() ~= myclass and objEnt:GetMoveType() == MOVETYPE_VPHYSICS then --and not objEnt:IsPlayer() and not objEnt:IsNPC() then
		table.insert(self.TouchingObjects,objEnt)
	end
end

function ENT:Touch(objEnt)
end

function ENT:EndTouch(objEnt)
	for k, v in pairs(self.TouchingObjects) do
		if v == objEnt then
			table.remove(self.TouchingObjects,k)
			break
		end
	end
end

function ENT:Think()
	self.LastThink = self.LastThink or CurTime()
	local fDelta = CurTime() - self.LastThink
	self.LastThink = CurTime()
	for k, ent in pairs(self.TouchingObjects) do
		if ValidEntity(ent) then
			self:ApplyConveyorPhysics(ent, fDelta)
		end
	end
	self.Entity:NextThink(CurTime())
	return true
end
