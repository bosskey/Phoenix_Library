move.RegisterEvent("OnJump")
move.SetDefault("LastJump",0)

hook.Add("SetPlayerAnimation",NAME,function (objPl, numAnim)
	if numAnim == PLAYER_JUMP then
		move.CallEvent("OnJump",objPl)
		objPl:SetMoveAttribute("LastJump",CurTime())
	end
end)