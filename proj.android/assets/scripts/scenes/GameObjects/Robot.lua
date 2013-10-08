require("scenes.Define")

local Robot = class("Robit", function()
  return display.newSprite("#robot_idle_00.png")
end)

local Prototype = require("scenes.GameObjects.ActionSprite"):extend(Hero)
--Animation Cache
local ROBOT_IDLE = "RobotIdle"
local ROBOT_ATTACK = "RobotAttack"
local ROBOT_WALK = "RobotWalk"

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

function Robot:ctor()
  WalkSpeed = 80
  HitPoints = 100
  Damage = 10
  CenterToSide = 29
  CenterToBottom = 39
end

function Robot:createIdleAction()
  local frames = display.newFrames("robot_idle_%02d.png",0,5)
  local animation = display.newAnimation(frames,1/12)
  display.setAnimationCache(ROBOT_IDLE,animation)
  Prototype:setIdleAction(CCRepeatForever:create(CCAnimate:create(animation)))
end

function Robot:createAttackAction()
  local frames = display.newFrames("robot_attack_%02d.png",0,5)
  local animation = display.newAnimation(frames,1/24)
  display.setAnimationCache(ROBOT_ATTACK,animation)
  local idelFunc = CCCallFunc:create(function() self:idle() end)
  Prototype:setAttackAction(CCSequence:createWithTwoActions(CCAnimate:create(animation),idelFunc))
end

function Robot:createWalkAction()
  local frames = display.newFrames("robot_walk_%02d.png",0,6)
  local animation = display.newAnimation(frames,1/12)
  display.setAnimationCache(ROBOT_WALK,animation)
  local idelFunc = CCCallFunc:create(function() self:idle() end)
  Prototype:setWalkAction(CCRepeatForever:create(CCAnimate:create(animation)))
end

function Robot:getWalkSpeed()
  return WalkSpeed
end

function Robot:getCenterToSides()
  return CenterToSide
end

function Robot:getCenterToBottom()
  return CenterToBottom
end

function Robot:getDesiredPosition()
  return DesiredPosition
end

function Robot:setDesiredPosition(param)
  DesiredPosition = param
end

function Robot:getActionState()
  return ActionState
end

function Robot:setActionState(param)
  ActionState = param
end

function Robot:getVelocity()
  return Velocity
end

function Robot:setVelocity(param)
  Velocity = param
end

function Robot:idle()
  Prototype.idle(self)
end

function Robot:attack()
  Prototype.attack(self)
end

function Robot:walkWithDirection(direction)
  Prototype.walkWithDirection(self,direction)
end

return Robot