--[[
	local tblTest = {
		[{"string","number","player"}] = function (strName,numID,objPl) end,
		[{"string","table"}] = function (strName,tbl) end,
		[{"string","number"}] = function (strName,num) end
	}
	
	local tblOptimized = {
		["string"] = {
			["number"] = {
				["player"] = funcCallback,
				["nil"] = funcCallback
			},
			["table"] = funcCallback
		}
	}
	
	how it gets the function:
	tblOptimized["string"]["number"]["player"](str,num,pl, ...) --accumulated/dissipated table accessing ofcourse (or it would probably error)
]]

function Overload(tblSetup,funcDefault_or_bNoDefault)
	local tblOverload = {}
	for tblParams, funcCallback in pairs(tblSetup) do
		local tblCurrent = tblOverload
		for i=1, #tblParams do
			local strType = tblParams[i]
			tblCurrent[strType] = tblCurrent[strType] or {}
			tblCurrent = tblCurrent[strType]
		end
		tblCurrent["nil"] = funcCallback
	end
	if type(funcDefault_or_bNoDefault) == "function" then
		return function (...)
			local tblParams, tblLast, numParam = {...}, tblOverload, 1
			while true do
				local strType = type(tblParams[numParam])
				local vNext = tblLast[strType]
				if type(vNext) == "function" then
					local bOk, valReturn = pcall(vNext,...)
					if not bOk then
						error(valReturn,2)
					end
					return valReturn
				elseif type(vNext) == "table" then
					tblLast = tblLast[strType]
					numParam = numParam + 1
				else
					local bOk, valReturn = pcall(funcDefault_or_bNoDefault,...)
					if not bOk then
						error(valReturn,2)
					end
					return valReturn
				end
			end
		end
	elseif type(funcDefault_or_bNoDefault) == "boolean" and funcDefault_or_bNoDefault then
		return function (...)
			local tblParams, tblLast, numParam = {...}, tblOverload, 1
			while true do
				local strType = type(tblParams[numParam])
				local vNext = tblLast[strType]
				if type(vNext) == "function" then
					local bOk, valReturn = pcall(vNext,...)
					if not bOk then
						error(valReturn,2)
					end
					return valReturn
				elseif type(vNext) == "table" then
					tblLast = tblLast[strType]
					numParam = numParam + 1
				else
					local bOk, valReturn = pcall(tblLast["nil"],...)
					if not bOk then
						error(valReturn,2)
					end
					return valReturn
				end
			end
		end
	end
	return function (...)
		local tblParams, tblLast, numParam = {...}, tblOverload, 1
		while true do
			local strType = type(tblParams[numParam])
			local vNext = tblLast[strType]
			if type(vNext) == "function" then
				local bOk, valReturn = pcall(vNext,...)
				if not bOk then
					error(valReturn,2)
				end
				return valReturn
			elseif type(vNext) == "table" then
				tblLast = tblLast[strType]
				numParam = numParam + 1
			else
				return nil
			end
		end
	end
end
