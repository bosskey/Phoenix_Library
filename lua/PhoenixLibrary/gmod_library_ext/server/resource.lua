resource.AddFolder = function(strDirectory,...)
	strDirectory = string.FormatPath(strDirectory)
	for _, strDir in pairs(file.FindDir("../"..strDirectory.."*.")) do
		if strDir ~= ".svn" then
			resource.AddFolder(strDirectory..strDir,...)
		end
	end
	for _, strFile in pairs(file.FindEx("../"..strDirectory,...)) do
		resource.AddSingleFile(strDirectory..strFile)
	end
end

local mounts = {
	["materials/"]={"vtf","vmt"},
	["models/"]={"mdl","dx90.vtx","dx80.vtx","sw.vtx","phy","vvd"},
	["sound/"]={"mp3","wav","ogg"},
	["scripts/"]={"txt"},
	["resource/fonts/"]={"ttf"},
	["shaders/"]={"vcs"},
	["maps/"]={},
	['data/']={'txt'},
	['settings/']={'txt'},
	
}

resource.AddAll = function (strFolderSuffix) //Careful about this, it'll add all content to the download list
	if strFolderSuffix then
		strFolderSuffix = string.FormatPath(strFolderSuffix)
		for k, v in pairs(mounts) do
			resource.AddFolder(string.FormatPath(k)..strFolderSuffix,unpack(v))
		end
	else
		for k, v in pairs(mounts) do
			resource.AddFolder(string.FormatPath(k),unpack(v))
		end
	end
	ErrorNoHalt("Loaded All Resources\n")
end

local function AddContentAliasFolder(strGamemode,strDir, strSub)
	for _, strFolder in pairs(file.FindDir("../gamemodes/"..strGamemode.."/content/"..strDir..strSub.."*.")) do
		if strFolder ~= ".svn" then
			AddContentAliasFolder(strGamemode,strDir,strSub..strFolder.."/")
		end
	end
	local files
	if mounts[strDir] then
		files = file.FindEx("../gamemodes/"..strGamemode.."/content/"..strDir..strSub,unpack(mounts[strDir]))
	else
		files = file.Find("../gamemodes/"..strGamemode.."/content/"..strDir..strSub.."*.*")
	end
	for _, strFile in pairs(files) do
		resource.AddSingleFile(strDir..strSub..strFile)
		--print("AddedFile ".."../"..strDir..strSub..strFile)
	end
end

resource.AddGamemodeContent = function (strGamemode, tblExclude)
	tblExclude = tblExclude or {}
	if not file.IsDir("../gamemodes/"..strGamemode.."/content/") then ErrorNoHalt("Attempt to add non-existant gamemode content folder for "..strGamemode.."\n") return end
	for _, strDir in pairs(file.FindDir("../gamemodes/"..strGamemode.."/content/*.")) do
		if strDir ~= ".svn" and not table.HasValue(tblExclude,strDir) then
			AddContentAliasFolder(strGamemode,strDir.."/","")
		end
	end
end
