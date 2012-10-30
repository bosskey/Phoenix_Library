file.ExistsInLua = function (strDirectory,bAddonLuaFile)
	if bAddonLuaFile then
		return file.Exists("../lua/"..strDirectory)
	end
	return file.Exists("../lua_temp/"..strDirectory)
end

file.FindDirInLua = function (strDirectory,bAddonLuaFolder)
	if bAddonLuaFolder then
		return file.FindDir("../lua/"..strDirectory)
	end
	return file.FindDir("../lua_temp/"..strDirectory)
end

file.IsDirInLua = function (strDirectory,bAddonLuaFolder)
	if bAddonLuaFolder then
		return file.IsDir("../lua/"..strDirectory)
	end
	return file.IsDir("../lua_temp/"..strDirectory)
end