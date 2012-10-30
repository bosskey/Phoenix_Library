

function SendEmitSound(rf,objEnt,strSound, numVol, numPitch)
	if numPitch then
		umsg.Start("EmitSound3",rf)
			umsg.Entity(objEnt)
			umsg.String(strSound)
			umsg.Float(numVol)
			umsg.Float(numPitch)
		umsg.End()
	elseif numVol then
		umsg.Start("EmitSound2",rf)
			umsg.Entity(objEnt)
			umsg.String(strSound)
			umsg.Float(numVol)
		umsg.End()
	else
		umsg.Start("EmitSound",rf)
			umsg.Entity(objEnt)
			umsg.String(strSound)
		umsg.End()
	end
end

function SendWorldSound(rf,vecPos,strSound, numVol, numPitch)
	if numPitch then
		umsg.Start("WorldSound3",rf)
			umsg.String(strSound)
			umsg.Vector(vecPos)
			umsg.Short(numVol)
			umsg.Short(numPitch)
		umsg.End()
	elseif numVol then
		umsg.Start("WorldSound2",rf)
			umsg.String(strSound)
			umsg.Vector(vecPos)
			umsg.Short(numVol)
		umsg.End()
	else
		umsg.Start("WorldSound",rf)
			umsg.String(strSound)
			umsg.Vector(vecPos)
		umsg.End()
	end
end