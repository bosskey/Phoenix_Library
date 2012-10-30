
local HUD = {} HUD.__index = HUD

local CurrentHUD, ScreenLock = nil, true
function HUD:GetBlock(strName)
	for _, block in pairs(CurrentHUD) do
		if block.Name == strName then
			return block
		end
	end
end

function HUD:Load()

end

function HUD:Save()
	local strHUDConfig = ""
	for _, block in pairs(CurrentHUD) do
		strHUDConfig = strHUDConfig..block.Name..":"..block.x.." "..block.y.."\n"
	end
	file.Write("PhoenixLibrary/hud/"..GAMEMODE.Name.."_"..self.hud.Name..".txt",strHUDConfig)
end

function HUD:Select() --Sets this HUD as the main hud at the time it is run
	CurrentHUD = self
end

--HUD Block object
local HUDB = {} HUDB.__index = HUDB
HUDB.selected = false
function HUDB:SetPos(numX,numY)
	self.x = numX
	self.y = numY
end

function HUDB:SetSize(numW,numH)
	self.w = numW
	self.h = numH
end
AccessorFuncForce(HUDB,"w","Width","number")
AccessorFuncForce(HUDB,"h","Height","number")
AccessorFuncForce(HUDB,"x","X","number")
AccessorFuncForce(HUDB,"y","Y","number")
AccessorFuncForce(HUDB,"moveable","Moveable","boolean")
AccessorFuncForce(HUDB,"enabled","Enabled","boolean")

function HUD:CreateBlock(strName,funcDraw)
	local objNew = {}
	setmetatable(objNew,HUDB)
	objNew.Name = strName
	objNew.draw = funcDraw
	table.insert(self.blocks,objNew)
	return objNew
end

local HUDS = {}
local MouseStartX, MouseStartY, SelectedBlock = 0, 0, nil

local function GrabBlock(block,x,y)
	block.selected = true
	SelectedBlock = block
	MouseStartX = x
	MouseStartY = y
end

local function UnGrabBlock(block)
	block.selected = false
	SelectedBlock = nil
	block.x = block.x + (gui.MouseX()-MouseStartX)
	block.y = block.y + (gui.MouseY()-MouseStartY)
	CurrentHUD:Save()
end

hook.Add("GUIMousePressed",NAME,function (mc)
	if mc == MOUSE_LEFT and not ScreenLock then
		local x, y = gui.MouseX(), gui.MouseY()
		for _, block in pairs(hud.blocks) do
			if block.enabled and block.moveable and block.x < x and block.y < y and x < block.x+block.w and y < block.y+block.h then
				--start dragging a block
				GrabBlock(block,x,y)
				break
			end
		end
	end
end)

hook.Add("GUIMouseReleased",NAME,function (mc)
	if mc == MOUSE_LEFT and not ScreenLock and SelectedBlock then
		UnGrabBlock(SelectedBlock)
	end
end)

local bOk, valReturn
hook.Add("HUDPaint",NAME,function ()
	if not CurrentHUD then return end
	for _, block in pairs(CurrentHUD.blocks) do
		if not block.errordisable then
			if block.selected then
				bOk, valReturn = pcall(block.draw,block.x+(gui.MouseX()-MouseStartX),block.y+(gui.MouseY()-MouseStartY),block.w,block.h)
			else
				bOk, valReturn = pcall(block.draw,block.x,block.y,block.w,block.h)
			end
			if not bOk then
				ErrorNoHalt("HUDBlock failed to draw : '"..tostring(valReturn).."'\n")
				block.errordisable = true
			end
		end
	end
end)

hook.Add("Initialize",NAME,function ()
	for _, strFilename in pairs(file.Find("PhoenixLibrary/hud/"..GAMEMODE.Name.."_*.txt")) do
		local strFile = file.Read(strFilename)
		if strFile ~= "" then
			for _2, strLine in pairs(string.Explode('\n',strFile)) do
				
			end
		end
	end
end)

--Use this to create the root hud for your entire structure.
function surface.CreateHUD(strName)
	local objNew = {}
	setmetatable(objNew,HUD)
	objNew.Name = FORCE(strName,"Default")
	table.insert(HUDS,objNew)
	if not CurrentHUD then CurrentHUD = objNew end
	return objNew
end
