file.ExistsInLua = function (strDirectory)
	return file.Exists("../lua/"..strDirectory)
end

file.FindDirInLua = function (strDirectory)
	return file.FindDir("../lua/"..strDirectory)
end

file.IsDirInLua = function (strDirectory)
	return file.IsDir("../lua/"..strDirectory)
end