/*
	Info:
	- Planned to be clientside only
	- Teleporting the water object will make it compress into a 1x1x1 cube and then it will decompress rapidly via traces
*/

module("water",package.seeall)
local WaterObjects = {}
local WATER = {MetaName="Water",Points = {}}
WATER.__index = WATER

function WATER:ApplyForceCenter(vecVelocity)
	--No idea...
end
function WATER:ApplyForceOffset(vecOffset,vecVelocity)
	
end
function WATER:SetPos(vecPos)
	self.Pos = FORCE(vecPos,VEC_ORIGIN)
end
function WATER:GetPos() return self.Pos end
function WATER:SetViscosity(numViscosity)
	self.Viscosity = FORCE(numViscosity,1)
end
function WATER:GetViscosity() return self.Viscosity end
function WATER:SetVolume(numVolume)
	self.Volume = FORCE(numVolume,1)
end
function WATER:GetVolume() return self.Volume end

function Create(vecPos,numViscosity,numVolume)
	local objNew = {}
	setmetatable(objNew,WATER)
	objNew.Pos = FORCE(vecPos,VEC_ORIGIN)
	objNew.Viscosity = FORCE(numViscosity,1)
	objNew.Volume = FORCE(numVolume,1)
	table.insert(WaterObjects,objNew)
	return objNew
end