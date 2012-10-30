
if 1==1 then return end --Lets not load this yet

module("physics",package.seeall)
local PhysObjects = {}
local PHYS = {
	MetaName = "LuaPhysicsObject",
	Pos = VEC_ORIGIN,
	Angle = Angle(0,0,0),
	Velocity = VEC_ORIGIN,
	AngleVelocity = Angle(0,0,0)
}
PHYS.__index = PHYS
AccessorFuncForce(PHYS,"Pos","Pos","Vector")
AccessorFuncForce(PHYS,"Angle","Angle","Angle")
AccessorFuncForce(PHYS,"Velocity","Velocity","Vector")
AccessorFuncForce(PHYS,"AngleVelocity","AngleVelocity","Angle")
AccessorFuncForce(PHYS,"Mass","Mass","number")
AccessorFuncForce(PHYS,"BuoyancyRatio","BouyancyRatio","number")

function PHYS:AddAngleVelocity(angVel) self.AngleVelocity = self.AngleVelocity + FORCE(angVel,Angle(0,0,0)) end
function PHYS:AddVelocity(vecVel) self.Velocity = self.Velocity + FORCE(vecVel,VEC_ORIGIN) end
function PHYS:ApplyForceCenter(vecVel) self.Velocity = self.Velocity + FORCE(VecVel,VEC_ORIGIN) end
function PHYS:ApplyForceOffset(vecVel,vecOffset)
	local vecVelAdd

	self.Velocity = self.Velocity + vecVelAdd
end
function PHYS:EnableCollisions(bOn) self.CollisionsOn = FORCE(bOn,true) end
function PHYS:EnableDrag(bOn) self.DragOn = FORCE(bOn,true) end
function PHYS:EnableGravity(bOn) self.GravityOn = FORCE(bOn,true) end
function PHYS:EnableMotion(bOn) self.MotionOn = FORCE(bOn,true) end

function PHYS:GetDamping() return self.LinearDamping, self.RotationalDamping end
function PHYS:SetDamping(numLinear,numRotational)
	self.LinearDamping, self.RotationalDamping = FORCE(numLinear,self.LinearDamping), FORCE(numRotational,self.RotationalDamping)
end
function PHYS:GetVertexPosition(numIndex)
	local vertex = self.Vertices[numIndex]
	if not vertex then ErrorNoHalt("Physics - invalid vertex index\n") return nil end
	return vertex.Pos, vertex.Ang
end
local Feature = {}
function AddInteractive(strName,funcSetup)

end
function PHYS:EnableInteractive(strFeature,...)
	local funcSetup = Feature[strFeature]
	if type(funcSetup) == "function" then
		
	end
end

function Create(tblVertices)
	if type(tblVertices) == "table" then
		local objNew = {MetaName="LuaPhysicsObject"}
		setmetatable(objNew,PHYS)
		objNew.Vertices = tblVertices
		objNew.LastThink = CurTime()
		objNew.Index = table.insert(PhysObjects,objNew)
		return objNew
	end
end

local function CheckVertex(vecPos)
	local tr = util.TraceLine({start=vecPos,endpos=vecPos+VEC_UP})
	if tr.HitWorld then
		
	end
	--Do all objects check (via trace or some more optimized check)
end

local vecUP = Vector(0,0,1)
local function fA()
	for _, v in pairs(PhysObjects) do
		local tDelta = CurTime() - v.LastThink
		v.LastThink = CurTime()
		
		local newPos = v.Pos + v.Velocity*tDelta
		local newAng = v.Angle + v.AngleVelocity*tDelta
		for _2, vertex in pairs(v.Vertices) do
			local pos = newPos + vertex.Pos
			pos:Rotate(newAng) --Roughly just like LocalToWorld on local vertices point offsets with angle private to object
			
		end		
		local newVel = v.Velocity - vecUP*-512.5*tDelta - v.Velocity*v.LinearDamping
		local newAngleVel = v.AngleVelocity --*(1-v.RotationalDamping)
		
	end
end
hook.Add("Think",NAME,fA)
