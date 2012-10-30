--[[
	The uses of this table are very limited, but it shouldn't have any problems storing anything.
	
	_F[2][4][6][22].Hello.I.s.d.e.f.g.r.w.q.d.x.d.f.g[1].q = 1
	print(_F[2][4][6][22].Hello.I.s.d.e.f.g.r.w.q.d.x.d.f.g[1].q)  OUTPUT : 1
]]

local Storage = {}

_F = {MetaName="FluidStorageTable"}
function _F:__index(key)
	if Storage[key] == nil then	Storage[key] = {} end --take a look at this, maybe broken?
	return Storage[key]
end
function _F:__newindex(key,val)
	Storage[key] = val
end
function _F:__tostring()
	return table.ToString(Storage)
end
setmetatable(_F,_F)