
function CharTableToString(tbl)
	local str = ""
	for r=1, #tbl do
		for c=1, table.getn(tbl[r]) do
			str = str..tbl[r][c]
		end
		str = str..'\n'
	end
	return str
end
