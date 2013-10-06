require("scenes.Define")

local Hero  = class("Hero", function()
	return display.newSprite("#hero_idle_00.png")
end)

local Prototype = require("scenes.GameObjects.ActionSprite"):extend(Hero)
--Animation Cache
local HERO_IDLE = "heroIdle"
local HERO_ATTACK ="heroAttack"
local HERO_WALK = "heroWalk"

function Hero:ctor()
	Prototype:setMeasurements(29,39)
	Prototype:setAttribute(80,100,20)
end

function Hero:getClass()
	return Prototype
end

function Hero:update(dt)
	Prototype.update(self,dt)
end

function Hero:createIdleAction()
	local frames = display.newFrames("hero_idle_%02d.png",0,6)
	local animation = display.newAnimation(frames,1/12)
	display.setAnimationCache(HERO_IDLE,animation)
	Prototype:setIdleAction(CCRepeatForever:create(CCAnimate:create(animation)))
end

function Hero:createAttackAction()
	local frames = display.newFrames("hero_attack_00_%02d.png",0,3)
	local animation = display.newAnimation(frames,1/24)
	display.setAnimationCache(HERO_ATTACK,animation)
	local idelFunc = CCCallFunc:create(function() self:idle() end)
	Prototype:setAttackAction(CCSequence:createWithTwoActions(CCAnimate:create(animation),idelFunc))
end

function Hero:createWalkAction()
	local frames = display.newFrames("hero_walk_%02d.png",0,8)
	local animation = display.newAnimation(frames,1/12)
	display.setAnimationCache(HERO_WALK,animation)
	local idelFunc = CCCallFunc:create(function() self:idle() end)
	Prototype:setWalkAction(CCRepeatForever:create(CCAnimate:create(animation)))
end

function Hero:getCenterToSides()
	return Prototype:getCenterToSides()
end

function Hero:getCenterToBottom()
	return Prototype:getCenterToBottom()
end

function Hero:getDesiredPosition()
	return Prototype:getDesiredPosition()
end

function Hero:setDesiredPosition(param)
	Prototype:setDesiredPosition(param)
end

function Hero:getActionState()
	return Prototype:getActionState()
end

function Hero:idle()
	Prototype.idle(self)
end

function Hero:attack()
	Prototype.attack(self)
end

function Hero:walkWithDirection(direction)
	Prototype.walkWithDirection(self,direction)
end
return Hero