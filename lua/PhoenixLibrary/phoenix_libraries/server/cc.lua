--[[
local CC = {
	Vars = {},
	Commands = {}
}

module("cc",package.seeall)

concommand.Add("findcc_vars",function (objPl,strCmd,tblArgs)
	if #tblArgs == 1 then
		local strOutput = ""
		local strSearch = tblArgs[1]
		for strCmd, tblData in pairs(CC.Vars) do
			if string.find(strCmd,strSearch) or string.find(tblData.desc,strSearch) then
				strOutput = strOutput.."\""..strCmd.."\" = \""..tostring(tblData.val).."\nCC_Var "..tblData.type.."\n"
			end
		end
		if strOutput ~= "" then
			objPl:PrintMessage(2,strOutput)
		else
			objPl:PrintMessage(2,"findcc_vars: unable to find any matches to "..strSearch)
		end
	end
end)
concommand.Add("findcc_cmds",function (objPl,strCmd,tblArgs)
	
end)
]]