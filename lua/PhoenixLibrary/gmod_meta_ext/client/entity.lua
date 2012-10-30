local meta = FindMetaTable("Entity")

function meta:InView()
	local ang = CL:GetAngles():Difference(((self:GetPos() - CL:GetPos()):GetNormal()):Angle())
	return math.abs(ang.p) + math.abs(ang.y) <= CL:GetFOV()
end

--I know it's hacky but it ends up like this: 10 lines of code + 100% accurate or 500+ lines and not even accurate, not going into details
local oldDrawModel = meta.DrawModel
function meta:DrawModel()
	self.LastDraw = CurTime()
	oldDrawModel(self)
end

function meta:IsVisible()
	self.LastDraw = self.LastDraw or CurTime()
	return CurTime() - self.LastDraw <= FrameTime()
end
