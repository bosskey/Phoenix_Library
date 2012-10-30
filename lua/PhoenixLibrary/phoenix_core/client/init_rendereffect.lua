
hook.Add("InitPostEntity","SpawnRenderEffect",function ()
	--print("RENDER EFFECT SPAWNED")
	util.Effect("render_effect",EffectData(),true,true)
end)