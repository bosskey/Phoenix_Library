ENT.Base = "base_point"
ENT.Type = "point"
ENT.Hooks = {}

function ENT:Initialize()
	_G.POINT_THINK = self
end

function ENT:AddThink(strName, funcCallback, ...)
	if type(strName) == "string" then
		if type(funcCallback) == "function" then
			self.Hooks[strName] = {func=funcCallback,args=...}
		else
			ErrorNoHalt("PointThink.AddThink '"..strName.."' tried to add a nil function!\n")
		end
	else
		ErrorNoHalt("PointThink.AddThink : tried to add a non-string name!\n")
	end
end

function ENT:RemoveThink(strName)
	if type(strName) == "string" then
		self.Hooks[strName] = nil
	end
end

function ENT:Think()
	for strName, v in pairs(self.Hooks) do
		if type(v.func) == "function" then
			local ok, valReturn = pcall(v.func,v.args)
			if not ok then
				ErrorNoHalt("PointThink Hook '"..strName.."' Failed: "..tostring(valReturn).."\n")
			end
		else
			ErrorNoHalt("PointThink Hook '"..strName.."' tried to call a nil function!\n")
			self.Hooks[strName] = nil
		end
	end
	self.Entity:NextThink(CurTime())
	return true
end
