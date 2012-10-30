
local function AddCSLuaFolderX(strDirectory,tblExclude)
	strDirectory = string.FormatPath(strDirectory)
	tblExclude = tblExclude or {}
	for _, strDir in pairs(file.FindDirInLua(strDirectory.."*.")) do
		if strDir ~= ".svn" then
			AddCSLuaFolderX(strDirectory..strDir..'/',tblExclude)
		end
	end
	for _, strFile in pairs(file.FindInLua(strDirectory.."*.lua")) do
		if not table.HasValue(tblExclude,strFile) then
			AddCSLuaFile(strDirectory..strFile)
		end
	end
end

function AddCSLuaFolder(strDirectory,dataExclude)
	strDirectory = string.FormatPath(strDirectory)
	local tblExclude = {}
	if IsString(dataExclude) then
		tblExclude[1] = dataExclude
	elseif IsTable(dataExclude) then
		tblExclude = dataExclude
	end
	AddCSLuaFolderX(strDirectory,tblExclude)
end