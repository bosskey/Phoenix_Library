
local function OnScreen(pos)
	return pos.x <= ScrW() and pos.x >= 0 and pos.y <= ScrH() and pos.y >= 0
end

local Pos = CreateMetaTable("position")

function Pos:GetScreenClamp()
	return Position(math.Clamp(self.x,0,ScrW()),math.Clamp(self.y,0,ScrH()))
end

function Pos:ScreenClamp()
	self.x = math.Clamp(self.x,0,ScrW())
	self.y = math.Clamp(self.y,0,ScrH())
	self.visible = true
end

function Pos:GetX()	return self.x end
function Pos:GetY()	return self.y end
function Pos:GetCoordinates() return self.x, self.y end
Pos.GetCoord = Pos.GetCoordinates

function Pos:SetX(numX)
	self.x = math.Clamp(math.Round(numX),0,ScrW())
end

function Pos:SetY(numY)
	self.y = math.Clamp(math.Round(numY),0,ScrH())
end

function Pos:SetCoordinates(numX,numY)
	self.x = math.Clamp(math.Round(numX),0,ScrW())
	self.y = math.Clamp(math.Round(numY),0,ScrH())
end
Pos.SetCoord = Pos.SetCoordinates

function Position(numX,numY)
	local numX = numX or 0
	local numY = numY or 0
	local newPos = {}
	setmetatable(newPos,Pos)
	newPos.x = math.Clamp(math.Round(numX),0,ScrW())
	newPos.y = math.Clamp(math.Round(numY),0,ScrH())
	return newPos
end

function Pos:__tostring() return tostring(self.x).." "..tostring(self.y) end
function Pos:__concat(obj)
	local strType = typex(obj)
	if strType == "string" then
		return tostring(self.x).." "..tostring(self.y)..obj
	elseif strType == "number" then
		return tostring(self.x).." "..tostring(self.y)..tostring(obj)
    elseif strType == "position" then
		return tostring(self.x).." "..tostring(self.y)..tostring(obj)
	else
		local h = getbinhandler(self,obj,"__concat")
        if h then
			return h(self, obj)
        end
	end
	error("Cannot concatenate a position and a(n) "..typex(obj),2)
end

function Pos:__add(pos)	return Position(self.x + pos:GetX(),self.y + pos:GetY()) end
function Pos:__sub(pos)	return Position(self.x - pos:GetX(),self.y - pos:GetY()) end
function Pos:__eq(pos) return self.x == pos:GetX() and self.y == pos:GetY() end
function Pos:__pow(num)	return Position(math.pow(self.x,num),math.pow(self.y,num)) end
function Pos:__lt(pos) return self.x < pos:GetX() and self.y < pos:GetY() end
function Pos:__le(pos) return self.x <= pos:GetX() and self.y <= pos:GetY() end 
function Pos:__mul(v)
	if type(v) == "number" then
		return Position(self.x * v,self.y * v)
	elseif typex(v) == "position" then
		return Position(self.x * v:GetX(),self.y * v:GetY())
	end
	error("Cannot concatenate a position and a(n) "..typex(obj),2)
end
function Pos:__div(v)
	local strType = type(v)
	if type(v) == "number" then
		return Position(self.x / v,self.y / v)
	elseif typex(v) == "position" then
		return Position(self.x / v:GetX(),self.y / v:GetY())
	end
	error("Cannot concatenate a position and a(n) "..typex(obj),2)
end
