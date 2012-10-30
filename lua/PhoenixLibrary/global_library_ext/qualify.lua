--[[
	Qualification function creator:
	USE:
	local q = Qualify("prop_physics","prop_physics_multiplayer")
	for k, v in pairs(ents.GetAll()) do
		if q(v:GetClass()) then --This will check
			
		end
	end
]]
local function HandleFunctionCreation(tblQualify)
	return function (...)
		local tblResults = {}
		for _, v in pairs({...}) do
			for __, q in pairs(tblQualify) do
				table.insert(tblResults,rawequal(v,q)) --TODO: Clean up the equality comparison to make it robust
			end
		end
		return unpack(tblResults)
	end
end

function Qualify(...)
	return HandleFunctionCreation({...})
end