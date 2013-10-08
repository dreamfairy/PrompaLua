local Robot = class("Robit", function()
  return display.newSprite("#robot_idle_00.png")
end)

require("scenes.Define")
local Prototype = require("scenes.GameObjects.ActionSprite"):extend(Robot)
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

--actions
local IdleAction
local AttackAction
local WalkAction
local HurtAction
local KnockOutAction

--box
local HitBox
local AttackBox

function Robot:ctor(name)
  WalkSpeed = 80
  HitPoints = 100
  Damage = 10
  CenterToSide = 29
  CenterToBottom = 39
  ActionState = ACTION_STATE_NONE
  self.Name = name
end

function Robot:getClass()
  return Prototype
end

function Robot:getName()
  return self.Name
end

function Robot:createIdleAction()
  local frames = display.newFrames("robot_idle_%02d.png",0,5)
  local animation = display.newAnimation(frames,1/12)
  display.setAnimationCache(ROBOT_IDLE,animation)
  IdleAction = CCRepeatForever:create(CCAnimate:create(animation))
end

function Robot:createAttackAction()
  local frames = display.newFrames("robot_attack_%02d.png",0,5)
  local animation = display.newAnimation(frames,1/24)
  display.setAnimationCache(ROBOT_ATTACK,animation)
  local idelFunc = CCCallFunc:create(function() self:idle() end)
  AttackAction = CCSequence:createWithTwoActions(CCAnimate:create(animation),idelFunc)
end

function Robot:createWalkAction()
  local frames = display.newFrames("robot_walk_%02d.png",0,6)
  local animation = display.newAnimation(frames,1/12)
  display.setAnimationCache(ROBOT_WALK,animation)
  local idelFunc = CCCallFunc:create(function() self:idle() end)
  WalkAction = CCRepeatForever:create(CCAnimate:create(animation))
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

function Robot:getWalkAction()
  return WalkAction
end

function Robot:getAttackAction()
  return AttackAction
end

function Robot:getIdleAction()
  return IdleAction
end

function Robot:getHitBox()
  return HitBox
end

function Robot:getAttackBox()
  return AttackBox
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