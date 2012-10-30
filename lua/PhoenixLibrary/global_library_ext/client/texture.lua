
local matBase = CreateMaterial("BaseTexture","UnlitGeneric",{["$nodecal"]=1})
local tblNewMat = {} --["$vertexcolor"]=1, ["$vertexalpha"]=1 }
--local rtBase = GetRenderTarget("BaseRenderTarget",ScrW(),ScrH(),false)

function Texture(strName)
	if type(strName) == "string" then
		local matNew = strName
		local strTex = matBase:GetMaterialString( "$basetexture" )
		if strTex then
			tblNewMat["$basetexture"] = strTex
			matNew = CreateMaterial("Textured_"..strName,"UnlitGeneric",tblNewMat)
		end
		return matNew:GetMaterialTexture("$basetexture")
	else
		
		return matBase:GetMaterialTexture("$basetexture")
	end
end
--[[
local texBase = GetRenderTarget("BaseTexture",ScrW(),ScrH())
function Texture2(strMat)
	if type(strMat) ~= "string" then
		strMat = "vgui/white"
	end
	local rtOld = render.GetRenderTarget()
	render.SetRenderTarget(texBase)
	render.Clear(0,0,0,255)
	render.SetMaterial(Material(strMat))
	render.SetViewPort(0,0,ScrW(),ScrH())
	render.DrawScreenQuad()
	render.SetRenderTarget(rtOld)
	local tex = Texture()
	render.CopyTexture(texBase,tex)
	return tex
end

function Texture2Material(tex)
	if type(tex) ~= "ITexture" then
		print("OMFG NOT AN ITEXTURE")
		tex = Texture()
	end
	local tbl = {}
	local mat = CreateMaterial(tex:GetName(),"UnlitGeneric",tbl)
	mat:SetMaterialTexture("$basetexture",tex)
	mat:SetMaterialInt("$alpha",255)
	return mat
end
]]

