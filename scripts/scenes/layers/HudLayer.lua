local HudLayer  = class("HudLayer", function()
	return display.newLayer()
end)

local DPad
function HudLayer:ctor()
	DPad = require("scenes.Controller.SimpleDPad").new()
	DPad:setRadius(64)
	DPad:setPosition(64,64)
	DPad:setOpacity(100)
	self:addChild(DPad)
end

function HudLayer:getDPad()
	return DPad
end

return HudLayer