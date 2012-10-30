
gamemode.AddHook = function (...)
	for k, v in pairs({...}) do
		gamemode.Get('base')[v] = function () end
	end
end
