
function ChatMessageAll(strText)
	for _, objPl in pairs(player.GetAll()) do
		objPl:ChatPrint(strText)
	end
end

function PrintMessageAll(numID,strText)
	for _, objPl in pairs(player.GetAll()) do
		objPl:PrintMessage(numID,strText)
	end
end

function PrintMessageAdmins(numID,strText)
	for _, objPl in pairs(player.GetAll()) do
		if objPl:IsAdmin() then
			objPl:PrintMessage(numID,strText)
		end
	end
end

function printx(...)
	local tbl = {...}
	for index, obj in pairs(tbl) do
		tbl[index] = "["..tostring(obj).."]" or "[Unknown]"
	end
	local str = table.concat(tbl,",") or "ERROR"
	print(str)
end