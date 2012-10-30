--ERM I FORGET IF THIS IS A PROBLEM OR I EVEN NEED IT

hook.Add("PlayerUse","EntitySupport",function (objPl, objEnt)
	if not objEnt:GetCanUse() then return false end
end)