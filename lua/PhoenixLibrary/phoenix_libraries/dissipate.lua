module("dissipate",package.seeall)
local TableLoops, NumberLoops = {}, {}
local ACTIVE = false

local function Activate()
	ACTIVE = true
	local function fA()
		for index, v in pairs(TableLoops) do
			local tIndex, tValue = next(v.table,v.lastIndex)
			local bOk, valReturn = pcall(v.callback,tIndex,tValue)
			if not bOk then
				ErrorNoHalt("DISSIPATE TABLE ERROR:"..tostring(valReturn).."\n")
				TableLoops[k] = nil
			end
			v.lastIndex = tIndex
		end
		for k, v in pairs(NumberLoops) do
			if v.i > v.finish then v.i = v.start end
			local bOk, valReturn = pcall(v.callback,v.i + 0) --make arg a value so it can't be modified to mess up the loop iteration sequence
			if not bOk then
				ErrorNoHalt("DISSIPATE NUMBER ERROR:"..tostring(valReturn).."\n")
				NumberLoops[k] = nil
			end
			v.i = v.i + v.iter
		end
	end
	hook.Add("Think",NAME,fA)
end

function LoopTable(tbl,funcCallback)
	if not ACTIVE then Activate() end
	table.insert(TableLoops,{lastIndex=nil,table=tbl,callback=funcCallback})
end

function LoopNumber(numStart,numEnd,numIter,funcCallback)
	if not ACTIVE then Activate() end
	table.insert(NumberLoops,{start=numStart,finish=numEnd,iter=numIter,callback=funcCallback,i=numStart})
end

