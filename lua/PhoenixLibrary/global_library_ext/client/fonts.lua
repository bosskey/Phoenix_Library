--[[
local allow_aa = CreateClientConVar("font_allow_antialias",1,true)
local Fonts = {
	AllowAA = GetConVarNumber("font_allow_antialias") == 1
}

function AllowAntiAliasFonts(b)
	if b ~= Fonts.AllowAA then
		Fonts.AllowAA = b
		RunConsoleCommand("font_allow_antialias",ToConVarBool(b))
	end
end

local CreateFont = surface.CreateFont
local FONT = {}
FONT.__index = FONT

function FONT:Apply()
	CreateFont(self.BaseFont,self.Size,self.Weight,self.AA,self.Italic,self.Name)
end

function FONT:SetBaseFont(str)
	self.BaseFont = str
end
function FONT:SetSize(num)
	self.Size = math.min(128,num)
end
function FONT:SetBold(b)
	if b then
		self.Weight = 700
	else
		self.Weight = 400
	end
end
function FONT:SetWeight(var)
	if type(var) == "bool" then
		if var then
			self.Weight = 700
		else
			self.Weight = 400
		end
	else
		self.Weight = var
	end
end
function FONT:SetAA(b)
	self.AA = (b == true and allow_aa:GetBool())
end
FONT.SetAntiAlias = FONT.SetAA
function FONT:SetItalic(b)
	self.Italic = b == true
end
function FONT:GetBaseFont()
	return self.BaseFont
end
function FONT:GetSize()
	return self.Size
end
function FONT:IsBold()
	return self.Weight == 600
end
function FONT:IsItalic()
	return self.Italic == true
end
function FONT:IsAA()
	return self.AA == true
end
FONT.IsAntiAlias = FONT.IsAA
function FONT:GetWeight()
	return self.Weight
end

surface.CreateFont = function (strBaseFont,numSize,varWeight,bAntiAlias,bItalic,strFontName)
	if not Fonts[strFontName] then
		local objNew = {}
		setmetatable(objNew,FONT)
		objNew:SetBaseFont(strBaseFont)
		objNew:SetSize(numSize)
		objNew:SetWeight(varWeight)
		objNew:SetAA(bAntiAlias)
		objNew:SetItalic(bItalic)
		objNew.Name = strFontName
		objNew:Apply()
		Fonts[strFontName] = objNew
		return objNew
	end
	local objFont = Fonts[strFontName]
	objFont:SetBaseFont(strBaseFont)
	objFont:SetSize(numSize)
	objFont:SetWeight(varWeight)
	objFont:SetAA(bAntiAlias)
	objFont:SetItalic(bItalic)
	objFont:Apply()
	return objFont
end

surface.GetFont = function (strFontName)
	return Fonts[strFontName]
end

]]