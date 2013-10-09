local Robot = class("Robit", function()
  return display.newSprite("#robot_idle_00.png")
end)

require("scenes.Define")
require("config")
local Prototype = require("scenes.GameObjects.ActionSprite"):extend(Robot)
--Animation Cache
local ROBOT_IDLE = "RobotIdle"
local ROBOT_ATTACK = "RobotAttack"
local ROBOT_WALK = "RobotWalk"
local ROBOT_HURT = "RobotHurt"
local ROBOT_KNOCKOUT = "RobotKnockOut"

--attribute
local WalkSpeed
local Damage

--measurements
local CenterToSide
local CenterToBottom

function Robot:ctor(name)
  WalkSpeed = 80
  self.HurtPoint = 100
  Damage = 10
  CenterToSide = 29
  CenterToBottom = 39
  self.ActionState = ACTION_STATE_NONE
  self.Name = name
  self.NextDecisionTime = 0

  self.HitBox = Prototype.createBoundingBoxWithOrigin(self,ccp(-self:getCenterToSides(), -self:getCenterToBottom()),
    CCSizeMake(self:getCenterToSides() * 2, self:getCenterToBottom() * 2))
  self.AttackBox = Prototype.createBoundingBoxWithOrigin(self,ccp(self:getCenterToSides(), -5), CCSizeMake(25, 20))
end

function Robot:getClass()
  return Prototype
end

function Robot:getName()
  return self.Name
end

function Robot:update(dt)
  Prototype.update(self,dt)
end

function Robot:createIdleAction()
  local frames = display.newFrames("robot_idle_%02d.png",0,5)
  local animation = display.newAnimation(frames,1/12)
  display.setAnimationCache(ROBOT_IDLE,animation)
  self.IdleAction = CCRepeatForever:create(CCAnimate:create(animation))
end

function Robot:createAttackAction()
  local frames = display.newFrames("robot_attack_%02d.png",0,5)
  local animation = display.newAnimation(frames,1/24)
  display.setAnimationCache(ROBOT_ATTACK,animation)
  local idelFunc = CCCallFunc:create(function() self:idle() end)
  self.AttackAction = CCSequence:createWithTwoActions(CCAnimate:create(animation),idelFunc)
end

function Robot:createWalkAction()
  local frames = display.newFrames("robot_walk_%02d.png",0,6)
  local animation = display.newAnimation(frames,1/12)
  display.setAnimationCache(ROBOT_WALK,animation)
  local idelFunc = CCCallFunc:create(function() self:idle() end)
  self.WalkAction = CCRepeatForever:create(CCAnimate:create(animation))
end

function Robot:createHurtAction()
  local frames = display.newFrames("robot_hurt_%02d.png",0,3)
  local animation = display.newAnimation(frames,1/12)
  display.setAnimationCache(ROBOT_HURT,animation)
  local idelFunc = CCCallFunc:create(function() self:idle() end)
  self.HurtAction = CCSequence:createWithTwoActions(CCAnimate:create(animation),idelFunc)
end

function Robot:createKnockOutAction()
  local frames = display.newFrames("robot_knockout_%02d.png",0,5)
  local animation = display.newAnimation(frames,1/12)
  display.setAnimationCache(ROBOT_KNOCKOUT,animation)
  self.KnockOutAction = CCSequence:createWithTwoActions(CCAnimate:create(animation),CCBlink:create(2,10))
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
  return self.DesiredPosition
end

function Robot:setDesiredPosition(param)
  self.DesiredPosition = param
end

function Robot:getActionState()
  return self.ActionState
end

function Robot:setActionState(param)
  self.ActionState = param
end

function Robot:getVelocity()
  return self.Velocity
end

function Robot:setVelocity(param)
  self.Velocity = param
end

function Robot:getWalkAction()
  return self.WalkAction
end

function Robot:getAttackAction()
  return self.AttackAction
end

function Robot:getIdleAction()
  return self.IdleAction
end

function Robot:getHurtAction()
  return self.HurtAction
end

function Robot:getKnockOutAction()
  return self.KnockOutAction
end

function Robot:setHitBox(box)
  self.HitBox = box
end

function Robot:getHitBox()
  return self.HitBox
end

function Robot:setAttackBox(box)
  self.AttackBox = box
end

function Robot:getAttackBox()
  return self.AttackBox
end

function Robot:getHurtPoint()
  return self.HurtPoint
end

function Robot:getDamage()
  return Damage
end

function Robot:setHurtPoint(param)
  self.HurtPoint = param
end

function Robot:getNextDecisionTime()
  return self.NextDecisionTime
end

function Robot:setNextDecisionTime(param)
  self.NextDecisionTime = param
end

function Robot:idle()
  Prototype.idle(self)
end

function Robot:attack()
  Prototype.attack(self)
end

function Robot:playAttackSound()
  audio.playSound(GAME_SFX.HIT1)
end

function Robot:playDeathSound()
  audio.playSound(GAME_SFX.BOT_DEATH)
end

function Robot:hurtWithDamage(damage)
  Prototype.hurtWithDamage(self,damage)
end

function Robot:walkWithDirection(direction)
  Prototype.walkWithDirection(self,direction)
end

return Robot