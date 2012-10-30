umsg.PoolString("PlayerAttachment.Player")
umsg.PoolString("PlayerAttachment.Remove")
umsg.PoolString("PlayerAttachment.Angles")
umsg.PoolString("PlayerAttachment.Pos")
local Attachments = {}

local ATTACH = CreateMetaTable("attachment")
function ATTACH:SetPlayer(objPl)
	self.Player = objPl
	umsg.Start("PlayerAttachment.Player",0)
		umsg.Short(self.Index)
	umsg.End()
end
function ATTACH:SetPos(vec)
	self.Pos = vec
	umsg.Start("PlayerAttachment.Pos",0)
		umsg.Short(self.Index)
		umsg.Vector(vec)
	umsg.End()
end
function ATTACH:SetAngles(ang)
	self.Angle = ang
	umsg.Start("PlayerAttachment.Angles",0)
		umsg.Short(self.Index)
		umsg.Vector(ang)
	umsg.End()
end
function ATTACH:Remove()
	umsg.Start("PlayerAttachment.Remove",0)
		umsg.Short(self.Index)
	umsg.End()
	Attachments[self.Index] = nil
end

hook.Add("PlayerInitialSpawn",NAME,function (objPl)
	
end)

player.CreateAttachment = function (strModel)
	local objNew = {}
	setmetatable(objNew,ATTACH)
	objNew.Model = strModel
	objNew.Index = #Attachments + 1
	Attachments[objNew.Index] = objNew
	umsg.Start("PlayerAttachment.Create",0)
		umsg.Short(objNew.Index)
		umsg.String(objNew.Model)
	umsg.End()
	return objNew
end
