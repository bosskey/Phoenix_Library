
local function includeFolderX(strDirectory,tblExclude)
	strDirectory = string.FormatPath(strDirectory)
	tblExclude = tblExclude or {}
	for _, strDir in pairs(file.FindDirInLua(strDirectory.."*.")) do
		if strDir ~= ".svn" then
			includeFolderX(strDirectory..strDir..'/',tblExclude)
		end
	end
	for _, strFile in pairs(file.FindInLua(strDirectory.."*.lua")) do
		if not table.HasValue(tblExclude,strFile) then
			include(strDirectory..strFile)
		end
	end
end

function includeFolder(strDirectory,dataExclude)
	strDirectory = string.FormatPath(strDirectory)
	local tblExclude = {}
	if type(dataExclude) == "string" then
		tblExclude[1] = dataExclude
	elseif type(dataExclude) == "table" then
		tblExclude = dataExclude
	end
	includeFolderX(strDirectory,tblExclude)
end