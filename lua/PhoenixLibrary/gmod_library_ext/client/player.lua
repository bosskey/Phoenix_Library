--[[
hook.Add("Think",NAME,function ()
	for _, objPl in pairs(player.GetAll()) do
		if objPl ~= CL then
			for _2, tblData in pairs(objPl.Attachments) do
				local pos, ang = objPl:GetBonePosition(tblData.bone)
				tblData.ent:SetPos(pos
			end
		end
	end
end)
]]
--[[
player.SetAttachment = function (objPl,strBone,strModel,vecOffset,angOffset)
	if objPl.Attachments[strAttach] then
		objPl.Attachments[strAttach].ent:SetModel(strModel)
		objPl.Attachments[strAttach].vecoffset = vecOffset
		objPl.Attachments[strAttach].angoffset = angOffset
	else
		local objEnt = ents.Create("prop_physics")
		objEnt:SetOwner(objPl)
		objPl.Attachments[strAttach] = {player=objPl,ent=objEnt,bone=}
	end
end

usermessage.Hook("SetPlayerAttachment",function (um)
	local objPl = um:ReadEntity()
	local strAttach = um:ReadString()
	local strModel = um:ReadString()
	player.SetAttachment(objPl,strAttach,strModel)
end)
]]
