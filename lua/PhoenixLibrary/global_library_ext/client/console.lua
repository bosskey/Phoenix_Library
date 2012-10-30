local NAME = "zconsole_status"
local RENDER_INTERP, PAINT_INTERP = 0, 0
do
	local LastRSE = SysTime()
	hook.Add("RenderScreenspaceEffects",NAME,function () RENDER_INTERP=SysTime()-LastRSE LastRSE=SysTime() end)
end
local LastPaint = SysTime()
hook.Add("HUDPaintBackground",NAME,function () PAINT_INTERP=SysTime()-LastPaint LastPaint=SysTime() end) --This way we call ASAP ...using the background hook

function RenderFrameTime()
	return RENDER_INTERP --SysTime() - LastRSE
end
function PaintFrameTime()
	return PAINT_INTERP--SysTime() - LastPaint
end
function FreshPaintFrameTime()
	return SysTime()-LastPaint
end
function GameInEscape()
	return FrameTime()*2<SysTime()-LastPaint
end
