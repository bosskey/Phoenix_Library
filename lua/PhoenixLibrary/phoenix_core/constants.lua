
_C.VEC_ORIGIN = Vector(0,0,0)
_C.VEC_UP = Vector(0,0,1)
_C.VEC_DOWN = Vector(0,0,-1)
_C.VEC_NORM = Vector(1,1,1)

_C.ANG_FORWARD = Angle(0,0,0)
_C.ANG_BACKWARD = Angle(180,180,0)
_C.ANG_UP = Angle(-90,0,0)
_C.ANG_DOWN = Angle(90,0,0)
_C.ANG_RIGHT = Angle(0,90,0)
_C.ANG_LEFT = Angle(0,-90,0)

_C.CH_ENDL = '\n' -- lol
_C.CH_TAB = '\t'
_C.CH_SPACE = ' '

_C.FUNC_TRUE = function () return true end
_C.FUNC_FALSE = function () return false end
_C.FUNC_NIL = function () end

_C.UNIT_FOOT = 16
_C.UNIT_MILE = _C.UNIT_FOOT*5280 -- I think it's 5280...right?
_C.UNIT_INCH = _C.UNIT_FOOT/12
_C.UNIT_YARD = _C.UNIT_FOOT*3

_C.UNIT_METER = _C.UNIT_FOOT*3.2808399 --Meter, Google accurate
_C.UNIT_DECAM = 10*_C.UNIT_METER --Decameter
_C.UNIT_HECTOM = 100*_C.UNIT_METER -- Hectometer
_C.UNIT_KM = 1000*_C.UNIT_METER --Kilometer
_C.UNIT_DECIM = _C.UNIT_METER*.1 --Decimeter
_C.UNIT_CM = _C.UNIT_METER*.01 --Centimeter
_C.UNIT_MM = _C.UNIT_METER*.001 --Millimeter
_C.UNIT_NANOM = _C.UNIT_MM*.000001 --Nanometer

_C.UNIT_MPH = ((1/16)*60)/5280

_C.PI2 = math.pi*2

local tblInverse = {}
for i=1, 100 do
	tblInverse[i] = 1/i
	tblInverse[1/i] = i
end
_C.INVERSE = table.Copy(tblInverse)
tblInverse = nil