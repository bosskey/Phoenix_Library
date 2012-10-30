
file.FindEx = function (strDirectory,...)
	strDirectory = string.FormatPath(strDirectory)
	local tbl = {}
	for _, strExt in pairs({...}) do
		tbl = table.Add(tbl,file.Find(strDirectory..string.FormatFileExtension(strExt)))
	end
	return tbl
end
