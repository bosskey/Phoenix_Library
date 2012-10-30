
--Still working on some functions to put in here for the overall base...callbacks and the such

function OBJ:SetPos(vec) self.Entity:SetPos(vec) end
function OBJ:SetAngles(ang) self.Entity:SetAngles(ang) end
function OBJ:GetPos() return self.Entity:GetPos() end
function OBJ:GetAngles() return self.Entity:GetAngles() end
function OBJ:SetModel(mdl) self.Entity:SetModel(mdl) end
function OBJ:GetModel() return self.Entity:GetModel() end
function OBJ:Remove()
	self:OnRemove() --to give a chance to remove all players from the seats etc
	self.Entity:Remove()
	scripted_vehicles.Remove(self.Index)
	
end

function OBJ:Initialize()
	
end
