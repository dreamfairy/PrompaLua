require("scenes.Define")

local ActionSprite = {}

--movement
local Velocity
local DesiredPosition
	
--attribute
local WalkSpeed
local HitPoints
local Damage
local ActionState

--actions
local IdleAction
local AttackAction
local WalkAction
local HurtAction
local KnockOutAction

--measurements
local CenterToSide
local CenterToBottom

function ActionSprite:setAttribute(pWalkSpeed,pHitPoints,pDamage)
	WalkSpeed = pWalkSpeed
	HitPoints = pHitPoints
	Damage = pDamage
end

function ActionSprite:setMeasurements(pCenterToSides,pCenterToBottom)
	CenterToSide = pCenterToSides
	CenterToBottom = pCenterToBottom
end
function ActionSprite:getIdleAction()
	return IdleAction
end

function ActionSprite:extend()
	local o = {}
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
	if ActionState ~= ACTION_STATE_IDLE then
		self:stopAllActions()
		self:createIdleAction()
		self:runAction(IdleAction)
		ActionState = ACTION_STATE_IDLE
	end
end

function ActionSprite:attack()
	if ActionState ~= ACTION_STATE_ATTACK then
		self:stopAllActions()
		self:createAttackAction()
		self:runAction(AttackAction)
		ActionState = ACTION_STATE_ATTACK
	end
end

function ActionSprite:hurtWithDamage(damage)
end

function ActionSprite:knockout()
end

function ActionSprite:walkWithDirection(direction)
	if ActionState == ACTION_STATE_IDLE then
		self:stopAllActions()
		self:createWalkAction()
		self:runAction(WalkAction)
		ActionState = ACTION_STATE_WALK
	end
	
	if ActionState == ACTION_STATE_WALK then
		Velocity = ccp(direction.x * WalkSpeed, direction.y * WalkSpeed)
		if Velocity.x >= 0 then
			self:setScaleX(1)
		else
			self:setScaleX(-1)
		end
	end
end

function ActionSprite:update(dt)
	if ActionState == ACTION_STATE_WALK then
		DesiredPosition = ccpAdd(ccp(self:getPositionX(),self:getPositionY()),ccpMult(Velocity,dt))
	end
end

function ActionSprite:getDesiredPosition()
	return DesiredPosition
end

function ActionSprite:setDesiredPosition(param)
	DesiredPosition = param
end

function ActionSprite:getActionState()
	return ActionState
end

function ActionSprite:getCenterToSides()
	return CenterToSide
end

function ActionSprite:getCenterToBottom()
	return CenterToBottom
end

return ActionSprite