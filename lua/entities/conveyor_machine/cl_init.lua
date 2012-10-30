include('shared.lua')

local machine_sound = "outland_03.diesel_engine" -- ambient\machines\diesel_engine_idle1.wav

function ENT:Initialize()
	self.EngineOn = false
end

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:Think()

end