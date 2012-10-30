--if LocalPlayer then return end
Msg("===[ Starting Phoenix Libraries *Derma ]===\n")
local function LoadDermaMods()
	local num = 0
	for _, strName in pairs(file.FindInLua("PhoenixLibrary/derma_control_mods/*.lua")) do
		local fstr = string.gsub(strName,".lua",'')
		NAME = "derma_control_mods."..fstr..".derma"
		local tblPanel = _G[fstr]
		if tblPanel then
			PANEL = tblPanel
			include('PhoenixLibrary/derma_control_mods/'..strName)
			local pnlNew = table.Copy(PANEL)
			vgui.Register(fstr,pnlNew,PANEL.Derma.BaseClass)
			_G[fstr] = pnlNew
			num = num + 1
		elseif not LocalPlayer then --this means we are running it in the console environment
			print("Attempt to load invalid Derma control '"..fstr.."'")
		end
	end
	Msg("===[ Derma Control mods: ("..num..") ]===\n")
end
--load all Derma additions in PhoenixLib
local function LoadDermaAdditions() --These additions must handle themselves internally, this loader doesn't do the work for it.
	local num = 0
	for _, strName in pairs(file.FindInLua("PhoenixLibrary/phoenix_derma_controls/*.lua")) do
		NAME = "phoenix_derma_controls."..string.gsub(strName,".lua",'')..".derma"
		include('PhoenixLibrary/phoenix_derma_controls/'..strName)
		num = num + 1
	end
	Msg("===[ Phoenix Derma Controls added: ("..num..") ]===\n")
end
LoadDermaMods()
LoadDermaAdditions()
NAME = nil
PANEL = nil
Msg("===[ Phoenix Libraries *Derma Loaded ]===\n")

--FIX Lua: appending shit
function table.Print(tbl,nr,done)
	tbl = tbl or {}
	done = done or {}
	nr = nr or 0
	local maxlen = 0
	for k,_ in pairs(tbl) do
		if tostring(k):len() > maxlen then
			maxlen = tostring(k):len()
		end
	end
	--print(maxlen)
		
	for key,value in pairs(tbl) do
		if type (value) == "table" and not done[value] then
			done[value] = true
			print(string.rep("\t",nr)..tostring(key)..":")
			table.Print(value,nr + 1,done)
		else
			local keylen = tostring(key):len()
			local add = math.floor((maxlen - keylen)) --/7
			print(string.rep("\t",nr)..tostring(key)..string.rep(" ",add).." = "..tostring(value))
		end
	end
end

PrintTable = table.Print
