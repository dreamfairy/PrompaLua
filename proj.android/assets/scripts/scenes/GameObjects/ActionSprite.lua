require("scenes.Define")

local ActionSprite = {}

--actions
local IdleAction
local AttackAction
local WalkAction
local HurtAction
local KnockOutAction

function ActionSprite:extend()
	local o = o or {}
	setmetatable(o,self)
	self.__index = self
	return o
end

function ActionSprite:setIdleAction(data)
	IdleAction = data
end

function ActionSprite:setAttackAction(data)
	AttackAction = data
end

function ActionSprite:setWalkAction(data)
	WalkAction = data
end

function ActionSprite:idle()
  local ActionState = self:getActionState()
	if ActionState ~= ACTION_STATE_IDLE then
		self:stopAllActions()
		self:createIdleAction()
		self:runAction(IdleAction)
		ActionState = ACTION_STATE_IDLE
		self:setActionState(ActionState)
	end
end

function ActionSprite:attack()
  local ActionState = self:getActionState()
	if ActionState ~= ACTION_STATE_ATTACK then
		self:stopAllActions()
		self:createAttackAction()
		self:runAction(AttackAction)
		ActionState = ACTION_STATE_ATTACK
		self:setActionState(ActionState)
	end
end

function ActionSprite:hurtWithDamage(damage)
end

function ActionSprite:knockout()
end

function ActionSprite:walkWithDirection(direction)
  local ActionState = self:getActionState()
  local Velocity = self:getVelocity()
  local WalkSpeed = self:getWalkSpeed()
	if ActionState == ACTION_STATE_IDLE then
		self:stopAllActions()
		self:createWalkAction()
		self:runAction(WalkAction)
		ActionState = ACTION_STATE_WALK
		self:setActionState(ActionState)
	end
	
	if ActionState == ACTION_STATE_WALK then
		Velocity = ccp(direction.x * WalkSpeed, direction.y * WalkSpeed)
		self:setVelocity(Velocity)
		if Velocity.x >= 0 then
			self:setScaleX(1)
		else
			self:setScaleX(-1)
		end
	end
end

function ActionSprite:update(dt)
  local ActionState = self:getActionState()
  local Velocity = self:getVelocity()
	if ActionState == ACTION_STATE_WALK then
		local DesiredPosition = ccpAdd(ccp(self:getPositionX(),self:getPositionY()),ccpMult(Velocity,dt))
		self:setDesiredPosition(DesiredPosition)
	end
end

return ActionSprite