local meta = FindMetaTable("CRecipientFilter")

function meta:AddTeamPlayers(numTeam)
	for _, objPl in pairs(team.GetPlayers(numTeam)) do
		self:AddPlayer(objPl)
	end
end

function meta:RemoveTeamPlayers(numTeam)
	for _, objPl in pairs(team.GetPlayers(numTeam)) do
		self:RemovePlayer(objPl)
	end
end

function meta:AddAllPlayersExcept(...)
	local tbl = {...}
	for k, v in pairs(player.GetAll()) do
		if not table.HasValue(tbl,v) then
			self:AddPlayer(v)
		end
	end
end

function meta:RemoveAllPlayersExcept(...)
	local tbl = {...}
	for k, v in pairs(player.GetAll()) do
		if not table.HasValue(tbl,v) then
			self:RemovePlayer()
		end
	end
end

function meta:AddPVSEntity(objEnt)
	for k, v in pairs(player.GetAll()) do
		if objEnt:VisibleVec(v:EyePos()) then
			self:AddPlayer(v)
		end
	end
end

function meta:RemovePVSEntity(objEnt)
	for k, v in pairs(player.GetAll()) do
		if objEnt:VisibleVec(v:EyePos()) then
			self:RemovePlayer(v)
		end
	end
end