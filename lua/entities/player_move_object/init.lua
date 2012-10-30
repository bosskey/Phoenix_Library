ENT.Type = "anim"

function ENT:Initialize()
end

function ENT:SetPlayer(objPl)
	self.Player = objPl
	local min = objPl:OBBMins() or Vector(-16,-16,0)
	local max = objPl:OBBMaxs() or Vector(16,16,72)
	local padding = Vector(.1,.1,0)
	self.Entity:PhysicsInitBox(min,max)
	self.Entity:SetCollisionBounds(min - padding,max + padding)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	--self.Entity:SetMoveCollide(MOVECOLLIDE_FLY_DEFAULT)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Entity:SetTrigger(true)
	self.Entity:SetPos(objPl:GetPos())
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	--objPl:SetFriction(22) --lolwut
end

function ENT:Think()
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() and phys:IsAsleep() then
		phys:Wake()
	end
	if ValidEntity(self.Player) then
		self.Entity:SetAngles(self.Player:GetAngles())
		self.Entity:SetPos(self.Player:GetPos())
		self.Entity:SetVelocity(self.Player:GetVelocity())
	end
	self.Entity:NextThink(CurTime())
	return true
end

function ENT:PhysicsCollide(data, physObj)
	if ValidEntity(self.Player) then
		move.CallEvent("OnCollide",self.Player,data)
		--print(tostring(data.HitEntity).." hi")
	end
end

function ENT:StartTouch(objEnt)
	if ValidEntity(self.Player) and objEnt ~= self.Player then
		move.CallEvent("StartTouch",self.Player,objEnt)
		--print(objEnt:GetClass().." ooh you touch my tralala.")
	end
end

function ENT:Touch(objEnt)
end

function ENT:EndTouch(objEnt)
	if ValidEntity(self.Player) and objEnt ~= self.Player then
		move.CallEvent("EndTouch",self.Player,objEnt)
		--print(objEnt:GetClass().." you touch my ding ding dong.")
	end
end

function ENT:KeyValue(key,value)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_NEVER
end