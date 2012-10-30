local debug_getinfo = (GetSafeFunction or function () return debug.getinfo end)('debug.getinfo')
local debug_getupvalue = (GetSafeFunction or function () return debug.getupvalue end)('debug.getupvalue')
function debug.getupvars(func, bNoGetInfo)
	if type(func) == "function" then
		local tblLocals = {}
		if bNoGetInfo then
			for i=1, 200 do
				local valIndex, val = debug_getupvalue(func,i)
				if type(valIndex)=='nil' then break end
				tblLocals[valIndex] = val
			end
		else
			for i=1, (debug_getinfo(func,'u') or {nups=0}).nups do
				local valIndex, val = debug_getupvalue(func,i)
				tblLocals[valIndex] = val
			end
		end
		return tblLocals
	end
end

function debug.getupvar(func,strVar, bNoGetInfo)
	if type(func) == "function" then
		if bNoGetInfo then
			for i=1, 200 do
				local valIndex, val = debug_getupvalue(func,i)
				if strVar == valIndex then return val end
			end
		else
			for i=1, (debug_getinfo(func,'u') or {nups=0}).nups do
				local valIndex, val = debug_getupvalue(func,i)
				if strVar == valIndex then return val end
			end
		end
	end
end

function debug.setupvar(func,strVar,newVal, bNoGetInfo)
	if type(func) == "function" then
		if bNoGetInfo then
			for i=1, 200 do
				if strVar == debug_getupvalue(func,i) then
					debug_setupvalue(func,i,newVal)
					break
				end
			end
		else
			for i=1, (debug_getinfo(func,'u') or {nups=0}).nups do
				if strVar == debug_getupvalue(func,i) then
					debug_setupvalue(func,i,newVal)
					break
				end
			end
		end
	end
end
