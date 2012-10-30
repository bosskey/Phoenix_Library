
function LerpCurve(f,a,b) --Took out height, so you can just do this LerpCurve(.2,.5)*height
	return a + (b-a)*math.asin(math.acos(2*f-1))
end
