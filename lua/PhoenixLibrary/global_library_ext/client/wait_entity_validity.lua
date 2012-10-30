local EntityWait = {}

hook.Add("OnEntityCreated",NAME,function (objEnt)
	local numIndex = objEnt:EntIndex()
	local tblData = EntityWait[numIndex]
	if tblData then
		local bOk, valReturn = pcall(tblData.callback,objEnt,tblData.args)
		if not bOk then
			LibError(NAME,"OnEntityValid Callback",valReturn)
		end
		EntityWait[numIndex] = nil
	end
end)

function OnEntityValid(numIndex,funcCallback,...)
	if IsNumber(numIndex) and IsFunction(funcCallback) then
		table.insert(EntityWait,{index=numIndex,callback=funcCallback,args=...})
	end
end
