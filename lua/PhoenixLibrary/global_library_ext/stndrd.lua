
local tblConv = {"st", "nd", "rd"}

--Because garry is a dumb fuck, he made a function and it doesn't work correctly, so I made this
function STNDRD(numInput)
	if math.floor(numInput) < numInput then return "" end --decimal number, we dont put a standard return
	local numF = numInput*.01-math.floor(numInput*.01)
	if math.floor(numF*10) == 1 then return "th" end --if number's second to last digit is 1 then it will always be th ( [x x x x x 1 x] )
	return tblConv[numF*100] or "th" --determines the last digit ( [x x x x x ?] )
end