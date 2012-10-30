
local bScreenshot = false
local function UnScreenshot()
	bScreenshot = false
end
hook.Add("PlayerBindPress",NAME,function (objPl,strBind,bPressed)
	if not bScreenshot and (string.find(strBind,"screenshot") or string.find(strBind,"jpeg")) then
		bScreenshot = true
		NextThink(UnScreenshot)
	end
end)
function IsScreenShot() return bScreenshot == true end
