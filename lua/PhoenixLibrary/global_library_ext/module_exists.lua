
function modulecheck(str,bAlert)
	local bExists = file.Exists("../lua/includes/modules/"..tostring(str)..".dll")
	if not bExists and bAlert then
		if CLIENT then
			LocalPlayer():ChatPrint("Missing required module '"..tostring(str).."' contact an administrator or refer to your MOTD for instructions to get it.")
		elseif SERVER then
			ErrorNoHalt("Missing required module '"..tostring(str).."' contact an administrator for instructions on how to get the module!\n")
		end
	end
	return bExists
end
--make modulecheck popup a vgui alert if bAlert is true so that the client can go install it manually