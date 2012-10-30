hook.Add("RenderScreenspaceEffects",NAME,function ()
	local objWep = CL:GetActiveWeapon()
	if ValidEntity(objWep) then
		local func = objWep.Render
		if type(func) == "function" then
			local isOk, valReturn = pcall(func,objWep)
			if isOk then
				if valReturn ~= nil then
					--return valReturn
				end
			else
				ErrorNoHalt(objWep:GetClass()..".Render : '"..tostring(valReturn).."'\n")
			end
		end
	end
end)

hook.Add("CreateMove",NAME,function (cmd)
	local objWep = CL:GetActiveWeapon()
	if ValidEntity(objWep) then
		local func = objWep.CreateMove
		if type(func) == "function" then
			local isOk, valReturn = pcall(func,objWep,cmd)
			if isOk then
				if valReturn ~= nil then
					return valReturn
				end
			else
				ErrorNoHalt(objWep:GetClass()..".CreateMove : '"..tostring(valReturn).."'\n")
			end
		end
	end
end)