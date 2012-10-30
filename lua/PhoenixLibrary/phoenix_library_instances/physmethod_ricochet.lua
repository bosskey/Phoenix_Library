
phys.AddMethod("Ricochet",function (dir,hitnorm)
	return (2*hitnorm*(hitnorm:DotProduct(dir*-1))) + dir
end)