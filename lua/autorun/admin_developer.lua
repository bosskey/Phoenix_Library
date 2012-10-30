local function IsAuthed(objPl)
	return (objPl.IsListenServerHost and objPl:IsListenServerHost()) or objPl:EntIndex() == 0 or SinglePlayer()
end

local function FindInTable( tab, find, parents, depth )
 	depth = depth or 0 
 	parents = parents or ""
 	if ( depth > 3 ) then return end
 	depth = depth + 1
 	for k, v in pairs ( tab ) do
 		if ( type(k) == "string" ) then
 			if ( k && k:lower():find( find:lower() ) ) then
 				Msg("\t", parents, k, " - (", type(v), " - ", v, ")\n")
 			end
 			// Recurse
 			if ( type(v) == "table" && 
 				k != "_R" && 
 				k != "_E" && 
 				k != "_G" && 
 				k != "_M" && 
 				k != "_LOADED" && 
 				k != "__index" ) then 
 				 
 				local NewParents = parents .. k .. "."; 
 				FindInTable( v, find, NewParents, depth )
 			end
 		end
 	end
 end


local LUA_ENV = {
	["global"] = "_G",
	["meta"] = "_R",
	["enum"] = "_E",
	["constant"] = "_C"
}
local strEnvList = "Valid environments:"
for k, v in pairs(LUA_ENV) do
	strEnvList = strEnvList.." "..k
end

if SERVER then
	concommand.Add("restartlevel",function (objPl)
		if IsAuthed(objPl) then
			game.ConsoleCommand("changelevel "..game.GetMap().."\n")
		end
	end)

	concommand.Add("~lua_runshared",function (objPl,strCmd,tblArgs)
		if IsAuthed(objPl) then
			RunString(tblArgs[1])
		end
	end)

	concommand.Add("lua_runglobal",function (objPl,strCmd,tblArgs) --runs lua on server and all connected players
		if IsAuthed(objPl) then
			local strLua = table.concat(tblArgs," ")
			for k, v in pairs(player.GetAll()) do
				v:SendLua(strLua)
			end
			RunString(strLua)
		end
	end)
	concommand.Add("lua_findenv",function (objPl,strCmd,tblArgs)
		if !IsAuthed(objPl) then return end
		local strEnv, strFind = string.lower(tblArgs[1]), string.lower(tblArgs[2])
		if LUA_ENV[strEnv] then
			objPl:PrintMessage(HUD_PRINTCONSOLE,"Finding in environment '"..strEnv.."' SERVERSIDE:\n")
			FindInTable(_G[LUA_ENV[strEnv]],strFind)
		else
			objPl:PrintMessage(HUD_PRINTCONSOLE,strEnvList.."\n")
		end
	end)
end

if CLIENT then
	concommand.Add("lua_findenv_cl",function (objPl,strCmd,tblArgs)
		if not IsAuthed(objPl) then return end
		local strEnv, strFind = string.lower(tblArgs[1]), string.lower(tblArgs[2])
		if LUA_ENV[strEnv] then
			objPl:PrintMessage(HUD_PRINTCONSOLE,"Finding in environment '"..strEnv.."' SERVERSIDE:\n")
			FindInTable(_G[LUA_ENV[strEnv]],strFind)
		else
			objPl:PrintMessage(HUD_PRINTCONSOLE,strEnvList.."\n")
		end
	end,function (strCmd)
		local t = {}
		for k, v in pairs(LUA_ENV) do
			table.insert(t,strCmd.." "..k.." <string>")
		end
		return t
	end)

	concommand.Add("lua_listents_cl",function (objPl,strCmd,tblArgs)
		if not IsAuthed(objPl) then return end
		for k, v in pairs(ents.GetAll()) do
			if v:IsPlayer() then
				Msg("Player ["..tostring(v:EntIndex()).."]["..v:Name().."]\n")
			elseif v:IsWeapon() then
				Msg("Weapon ["..tostring(v:EntIndex()).."]["..v:GetPrintName().."]\n")
			else
				Msg("Entity ["..tostring(v:EntIndex()).."]["..v:GetClass().."]\n")
			end
		end
	end)
	
	local UTIL_VECTORS, pos = {}
	function AddUtilVector(vec)
		table.insert(UTIL_VECTORS,vec)
	end
	function ClearUtilVectors()
		UTIL_VECTORS = {}
	end
	hook.Add("HUDPaintBackground","admin_developer_utilvectors",function ()
		for k, v in pairs(UTIL_VECTORS) do
			if type(v) == "Vector" then
				pos = v:ToScreen()
				if pos.visible then
					surface.SetDrawColor(255,255,255,255)
					surface.DrawLine(pos.x-5,pos.y,pos.x+5,pos.y)
					surface.DrawLine(pos.x,pos.y-5,pos.x,pos.y+5)
				end
			end
		end
	end)
end