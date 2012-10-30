local function GetSuperParent(panel)
	if panel:GetParent() == vgui.GetWorldPanel() then return panel end
	return GetSuperParent(panel:GetParent())
end

local EntryPanelClass = {
	"TextEntry",
	"RadioButton",
	"ToggleButton",
	"InputDialog",
	"CheckButton",
	"Button",
	"DButton",
	"DCheckBox",
	"DTextEntry",
	"DTinyButton"
}
for k, v in pairs(table.Copy(EntryPanelClass)) do
	EntryPanelClass[v] = true
	EntryPanelClass[k] = nil
end

--[[
local oldvguiCreate = vgui.Create
function vgui.Create(strType, objParent, strTargetName)
	if objParent and GetSuperParent(objParent).FormEntryChildren and EntryPanelClass[strType] then
		local objNewPanel = oldvguiCreate(strType,objParent,strTargetName)
		table.insert(GetSuperParent(objParent).FormEntryChildren,objNewPanel)
		return objNewPanel
	end
	return oldvguiCreate(strType,objParent,strTargetName)
end

function Panel:EnableFormTabbing()
	self.FormEntryChildren = self.FormEntryChildren or {}
end

local function GetNextEntry(parent,curPanel)
	local curY = select(2,curPanel:GetPos())
	local tblNextEntries = {}
	for k, v in pairs(parent.FormEntryChildren) do
		if v and select(2,v:GetPos()) > curY then
			table.insert(tblNextEntries,v)
		end
	end
	local lowY, lowP = nil, nil
	for k, v in pairs(tblNextEntries) do
		local y = select(2,v:GetPos())
		if not lowY or y < lowY then
			lowY = y
			lowP = v
		end
	end
	return lowP
end

hook.Add("Think",NAME,function ()
	local pnl = vgui.GetKeyboardFocus()
	if pnl and pnl:GetClassName() == "DTextEntry" and not pnl:GetEnterAllowed() and input.IsKeyDown(KEY_TAB) then
		local parent = GetSuperParent(pnl)
		--Get next derma control to set focus to, buttons/DTextEntry items, anything, first by Y-axis topdown, then by X-axis LtoR
	end
end)

]]