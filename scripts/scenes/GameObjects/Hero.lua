local Hero  = class("Hero", function()
	return display.newSprite("#hero_idle_00.png")
end)

local HERO_IDLE = "heroIdle"
local CenterToSide = 29
local CenterToBottom = 39
local HitPoints = 100
local Damage = 20
local WalkSpeed = 80

function Hero:ctor()
	--idle
	local frames = display.newFrames("hero_idle_%02d.png",0,6)
	local animation = display.newAnimation(frames,1/12)
	display.setAnimationCache(HERO_IDLE,animation)
end

function Hero:getCenterToSides()
	return CenterToSide
end

function Hero:setDesiredPosition(param)
end

function Hero:idle()
	self:playAnimationForever(display.getAnimationCache(HERO_IDLE))
end


return Hero