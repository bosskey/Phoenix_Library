

--Support for multiple value comparisons, instead of local var = func(data) return var == val1 or var == val2 or var == val3
--It would be return eqOR(func(data), val1, val2, val3)
function eqOR(var,...)
	for _, val in pairs({...}) do
		if var == val then
			return true
		end
	end
	return false
end
function eqAND(var,...)
	for _, val in pairs({...}) do
		if var == val then
			return true
		end
	end
	return false
end

--EqualX, equal variable types and values
function eq(a,b) return type(a) == type(b) and a == b end

--This is a way of dynamically allowing FORCED or statements that will consider the first argument invalid for the return value if it is not the same type as alt, very useful for internal stuff in phoenix
-- that is why I made this in the core autorun folder
--EX: num = FORCE(num, 0,num>=0)
function FORCE(var,alt, exp)
	if type(var) == type(alt) and exp ~= false then return var end
	return alt
end

function swap(a,b) a, b = b, a end

--Substitute the third arg in the return value if the first arg(variable) is equal to the unwanted variable value in the second argument
function sub(var,valUnwanted,valSubstitute)
	if eqx(var,valUnwanted) then return valSubstitute end
	return var
end

--True if only one of the two is 
function xor(a,b) return not eq(a,b) end

--Requires only one boolean value to be true, if more than one, it is considered a total false value, if all are false, its false
function iff(...) --Means if and only if
	local bValidated = false
	for _, v in pairs({...}) do
		if v then
			if bValidated then
				return false
			end
			bValidated = true
		end
	end
	return
end
