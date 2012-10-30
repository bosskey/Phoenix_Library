local ToCall = {}

hook.Add("Think",NAME,function ()
	local ToRemove = {}
	for k, v in pairs(table.Copy(ToCall)) do --Because we don't want instant calls while running other tick calls (infinite loop prevention)
		local bOk, valReturn = pcall(v.callback,v.args)
		if not bOk then
			ErrorNoHalt("NextThink failed: '"..tostring(valReturn).."'\n")
		end
		table.insert(ToRemove,k)
	end
	if #ToRemove then
		for _, index in pairs(ToRemove) do
			table.remove(ToCall,index)
		end
	end
end)

function NextThink(funcCall,...)
	if type(funcCall) == "function" then
		table.insert(ToCall,{callback=funcCall,args=...})
	end
end

--Maybe add HUDPaint delineation and other hooks.