local GM = gamemode.Get("base")
function GM:ChatEvent(numType,numIndex,strName,strText)
end

function GM:PlayerDisconnected(strPlayerName,strReason)
	print(strPlayerName.." reason: '"..strReason.."'")
end

local MsgType = {
	["chat"] = 1,
	["joinleave"] = 2,
	["none"] = 3
}

local num = 0
local function fA(numIndex,strName,strText,strType)
	if strType == "joinleave" then
		num = string.find(strText," left the game ")
		if num then
			gamemode.Call("PlayerDisconnected",strName,string.sub(strText,num + 16,string.len(strText) - 1))
		end
	end
end
hook.Add("ChatText",NAME,fA)