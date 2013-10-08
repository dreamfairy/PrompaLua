require("scenes.Define")

local Hero  = class("Hero", function()
	return display.newSprite("#hero_idle_00.png")
end)

local Prototype = require("scenes.GameObjects.ActionSprite"):extend(Hero)
--Animation Cache
local HERO_IDLE = "heroIdle"
local HERO_ATTACK ="heroAttack"
local HERO_WALK = "heroWalk"

--movement
local Velocity
local DesiredPosition
  
--attribute
local WalkSpeed
local HitPoints
local Damage
local ActionState

--measurements
local CenterToSide
local CenterToBottom

--actions
local IdleAction
local AttackAction
local WalkAction
local HurtAction
local KnockOutAction

--box
local HitBox
local AttackBox

function Hero:ctor(name)
  WalkSpeed = 80
  HitPoints = 100
  Damage = 20
  CenterToSide = 29
  CenterToBottom = 39
  self.Name = name
end

function Hero:getName()
  return self.Name
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
	IdleAction = CCRepeatForever:create(CCAnimate:create(animation))
end

function Hero:createAttackAction()
	local frames = display.newFrames("hero_attack_00_%02d.png",0,3)
	local animation = display.newAnimation(frames,1/24)
	display.setAnimationCache(HERO_ATTACK,animation)
	local idelFunc = CCCallFunc:create(function() self:idle() end)
	AttackAction = CCSequence:createWithTwoActions(CCAnimate:create(animation),idelFunc)
end

function Hero:createWalkAction()
	local frames = display.newFrames("hero_walk_%02d.png",0,8)
	local animation = display.newAnimation(frames,1/12)
	display.setAnimationCache(HERO_WALK,animation)
	local idelFunc = CCCallFunc:create(function() self:idle() end)
	WalkAction = CCRepeatForever:create(CCAnimate:create(animation))
end

function Hero:getWalkSpeed()
  return WalkSpeed
end

function Hero:getCenterToSides()
	return CenterToSide
end

function Hero:getCenterToBottom()
	return CenterToBottom
end

function Hero:getDesiredPosition()
	return DesiredPosition
end

function Hero:setDesiredPosition(param)
	DesiredPosition = param
end

function Hero:getActionState()
	return ActionState
end

function Hero:setActionState(param)
  ActionState = param
end

function Hero:getVelocity()
  return Velocity
end

function Hero:setVelocity(param)
  Velocity = param
end

function Hero:getWalkAction()
  return WalkAction
end

function Hero:getAttackAction()
  return AttackAction
end

function Hero:getIdleAction()
  return IdleAction
end

function Hero:getHitBox()
  return HitBox
end

function Hero:getAttackBox()
  return AttackBox
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