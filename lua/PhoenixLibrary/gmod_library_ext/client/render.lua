
if not render then return end
local matRender = "pp/fb"
--local texRender = GetRenderTarget("RenderExtended",ScrW(),ScrH())
local tblCam = {x=0,y=0} --A little optimization
render.GetViewRender = function (vecOrigin,angDir,numW,numH)
	numW = numW or ScrW()
	numH = numH or ScrH()
	if IsVector(vecOrigin) and type(angDir) == "Angle" then
		local texRender = Texture()
		local rtOld = render.GetRenderTarget()
		render.SetRenderTarget(texRender)
		render.Clear(0,0,0,255)
		tblCam.origin = vecOrigin
		tblCam.angles = angDir
		tblCam.w = numW
		tblCam.h = numH
		render.RenderView(tblCam)
		render.SetRenderTarget(rtOld)
		matRender:SetMaterialTexture("$basetexture",texRender)
		matRender:SetMaterialInt("$alpha",255)
	end
end

local n = 1
render.GetScreenShot = function ()
	local texRT = GetRenderTarget("ScreenShot_"..tostring(n),ScrW(),ScrH(),false)
	n = n + 1
	render.CopyRenderTargetToTexture(texRT)
	return texRT
end
