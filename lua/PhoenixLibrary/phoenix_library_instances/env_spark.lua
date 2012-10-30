if SERVER then
	local function Spark(vecOrigin,vecDir,numScale)
		local effectData = EffectData()
		effectData:SetOrigin(vecOrigin)
		effectData:SetNormal(vecDir)
		effectData:SetScale(numScale)
		util.Effect("Spark",effectData)
		env.IGNITE_TRACE(vecOrigin,vecDir*numScale*2)
	end
	local tblData = {"Ignitor"}
	env.RegisterEvent(NAME,tblData,Spark)

else
	
end