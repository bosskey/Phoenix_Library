move.RegisterEvent("OnLand")

hook.Add("Think",NAME,function ()
	for k, v in pairs(player.GetAll()) do
		if v.Grounded and not v:OnGround() then
			v.Grounded = false
		elseif not v.Grounded and v:OnGround() then
			move.CallEvent("OnLand",v)
			v.Grounded = true
		end
	end
end)