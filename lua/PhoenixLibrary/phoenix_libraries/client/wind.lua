--[[
module("wind",package.seeall)
local Wind = {}
local WindZones = {}

function AddWindZone(vecPos,numRadius,angDir,angVariation,numVel,numVelVariation)
	table.insert(WindZones,{pos=vecPos,radius=numRadius,ang=angDir,angVar=angVariation,vel=numVel,velVar=numVelVariation}})
end

function CreateGust(vecPos,numRadius

function GetVelocity(vecPos)
	
	
	
	return Wind.ang*Wind.vel
end
]]