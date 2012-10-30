ENT.Type = "brush"

function ENT:Initialize()
	--gamemode.Get('base')
	--self:PhysicsInitBox(Vector(-10,-10,-10),Vector(10,10,10))
	self.Entity:SetCollisionBounds(Vector(-10,-10,-10),Vector(10,10,10))
end

function ENT:AcceptInput(strName,objActivator,objCaller)
end

function ENT:KeyValue(key,value)
	if not self.MapInfo then self.MapInfo = {} end
	self.MapInfo[key] = value
end

function ENT:Think()
end

function ENT:PassesTriggerFilters(objEnt)
	return true
end

function ENT:StartTouch(objEnt)
end

function ENT:Touch(objEnt)
end

function ENT:EndTouch(objEnt)
end

function ENT:OnRemove()
	--wtf no
end
