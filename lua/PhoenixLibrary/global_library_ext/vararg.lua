
function VarArgTableForce(...)
	local tbl
	if type((...)) == "table" then --Gets first arg from it, if it is a table
		tbl = (...)
	else
		tbl = {...}
	end
	return tbl
end

function Replicate(num,data)
	if type(num) == "number" and num > 1 then
		local tbl = {data}
		for i=2, num do
			table.insert(tbl,data)
		end
		return unpack(tbl)
	else
		return data
	end
end

function ReplicateToTable(num,data)
	if type(num) == "number" and num > 1 then
		local tbl = {data}
		for i=2, num do
			table.insert(tbl,data)
		end
		return tbl
	else
		return {data}
	end
end

function selectn(id,...)
	return ({...})[id]
end