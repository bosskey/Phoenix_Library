
--Returns [trace shortest, number distance]
function GetShortestTrace(...)
	local shortTrace = nil
	local shortDist = nil
	local shortIndex = nil
	for k, tr in pairs({...}) do
		local dist = tr.StartPos:Distance(tr.HitPos)
		if not shortDist or dist < shortDist then
			shortTrace = tr
			shortDist = dist
			shortIndex = k
		end
	end
	return shortTrace, shortDist, shortIndex
end
