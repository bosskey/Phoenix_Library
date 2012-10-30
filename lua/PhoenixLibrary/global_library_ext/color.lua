--Working on overriding all libraries that garry makes to use this and making all those functions deconstruct this object to make ...

--TODO: complete this.
local COLOR = {MetaName = "Color"}
COLOR.__index = COLOR
function COLOR:__newindex(key,val)
	if type(val) == "number" and (key == 'r' or key == 'g' or key == 'b' or key == 'a') then
		rawset(self,key,math.Clamp(math.floor(val),0,255))
	end
end
function COLOR:__tostring()
	return self.r..' '..self.g..' '..self.b..' '..self.a
end

function COLOR:SetColor(r,g,b,a)
	rawset(self,'r',math.Clamp(math.floor(r),0,255))
	rawset(self,'g',math.Clamp(math.floor(g),0,255))
	rawset(self,'b',math.Clamp(math.floor(b),0,255))
	rawset(self,'a',math.Clamp(math.floor(a),0,255))
end

function COLOR:GetRed() return self.r end
function COLOR:GetGreen() return self.g end
function COLOR:GetBlue() return self.b end
function COLOR:GetAlpha() return self.a end
function COLOR:SetRed(n) rawset(self,'r',math.Clamp(math.floor(n),0,255)) end
function COLOR:SetGreen(n) rawset(self,'g',math.Clamp(math.floor(n),0,255)) end
function COLOR:SetBlue(n) rawset(self,'b',math.Clamp(math.floor(n),0,255)) end
function COLOR:SetAlpha(n) rawset(self,'a',math.Clamp(math.floor(n),0,255)) end

function COLOR:GetHSV() return ColorToHSV({r=self.r,g=self.g,b=self.b,a=self.a}) end
local fScale = 1/255
function COLOR:GetNormal() return {r=self.r*fScale,g=self.g*fScale,b=self.b*fScale,a=self.b*fScale} end
function COLOR:Unpack() return self.r, self.g, self.b, self.a end

function ColorX(numR,numG,numB,numA)
	numA = numA or 255
	local objNew = {MetaName="Color"}
	setmetatable(objNew,COLOR)
	objNew:SetColor(numR,numG,numB,numA)
	return objNew
end

/*
function HSVToColorX(...)

end
*/