
phys.AddMethod("WallDist",function (dir,hitnorm) --Returns a scalar to use on predicted wall perpendicular dist.
	local angDiff = (dir:Angle()):Difference((-1*hitnorm):Angle())
	local vec = vecDirNew:Angle():Right()*math.sin(math.rad(angDiff.y)) + vecDirNew:Angle():Up()*math.sin(math.rad(angDiff.p))
	return vec:Length()
end)