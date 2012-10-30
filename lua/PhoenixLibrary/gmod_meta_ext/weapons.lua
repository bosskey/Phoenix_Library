hook.Add("KeyPress",NAME,function (objPl,numKey)
	local objWep = objPl:GetActiveWeapon()
	if ValidEntity(objWep) then
		local func = objWep.KeyPress
		if type(func) == "function" then
			local isOk, valReturn = pcall(func,objWep,numKey)
			if not isOk then
				ErrorNoHalt(objWep:GetClass()..".KeyPress : '"..tostring(valReturn).."'\n")
			end
		end
	end
end)

hook.Add("KeyRelease",NAME,function (objPl,numKey)
	local objWep = objPl:GetActiveWeapon()
	if ValidEntity(objWep) then
		local func = objWep.KeyRelease
		if type(func) == "function" then
			local isOk, valReturn = pcall(func,objWep,numKey)
			if not isOk then
				ErrorNoHalt(objWep:GetClass()..".KeyRelease : '"..tostring(valReturn).."'\n")
			end
		end
	end
end)

hook.Add("SetupMove",NAME,function (objPl,objMove)
	local objWep = objPl:GetActiveWeapon()
	if ValidEntity(objWep) then
		local func = objWep.SetupMove
		if type(func) == "function" then
			local isOk, valReturn = pcall(func,objWep,objMove)
			if not isOk then
				ErrorNoHalt(objWep:GetClass()..".SetupMove : '"..tostring(valReturn).."'\n")
			end
		end
	end
end)

hook.Add("Move",NAME,function (objPl,objMove)
	local objWep = objPl:GetActiveWeapon()
	if ValidEntity(objWep) then
		local func = objWep.Move
		if type(func) == "function" then
			local isOk, valReturn = pcall(func,objWep,objMove)
			if isOk then
				if valReturn ~= nil then
					return valReturn
				end
			else
				ErrorNoHalt(objWep:GetClass()..".Move : '"..tostring(valReturn).."'\n")
			end
		end
	end
end)

hook.Add("FinishMove",NAME,function (objPl,objMove)
	local objWep = objPl:GetActiveWeapon()
	if ValidEntity(objWep) then
		local func = objWep.FinishMove
		if type(func) == "function" then
			local isOk, valReturn = pcall(func,objWep,objMove)
			if not isOk then
				ErrorNoHalt(objWep:GetClass()..".FinishMove : '"..tostring(valReturn).."'\n")
			end
		end
	end
end)
