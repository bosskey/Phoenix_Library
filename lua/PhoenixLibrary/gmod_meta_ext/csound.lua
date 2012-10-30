
--[[
local meta = FindMetaTable("CSoundPatch")
local CSounds = {}
local SetPlay, SetPlayEx, SetStop, OldFadeOut = meta.Play, meta.PlayEx, meta.Stop, meta.FadeOut
local OldCreateSound = _G.CreateSound

function CreateSound(objEnt,strSound,bPrecache)
	if bPrecache then
		util.PrecacheSound(strSound)
	end
	local objSound = OldCreateSound(objEnt,strSound)
	CSounds[objSound] = {Playing = false}
	return objSound
end

function meta:Play()
	CSounds[self].Playing = true
	SetPlay(self)
end

function meta:PlayEx(fVolume, fPitch)
	CSounds[self].Playing = true
	SetPlayEx(self,fVolume,fPitch)
end

function meta:Stop()
	CSounds[self].Playing = false
	SetStop(self)
end

function meta:FadeOut(numSeconds)
	timer.Simple(numSeconds,function () CSounds[self].Playing = false end)
	OldFadeOut(numSeconds)
end

function meta:IsPlaying()
	return CSounds[self].Playing == true
end
]]