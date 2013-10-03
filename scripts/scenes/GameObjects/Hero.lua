require("scenes.Define")

local Hero  = class("Hero", function()
	return display.newSprite("#hero_idle_00.png")
end)

--Animation Cache
local HERO_IDLE = "heroIdle"
local HERO_ATTACK ="heroAttack"
local HERO_WALK = "heroWalk"

--Prop
local CenterToSide = 29
local CenterToBottom = 39
local HitPoints = 100
local Damage = 20
local WalkSpeed = 80
local ActionState
local Velocity
local DesiredPosition

--Actions
local IdleAction
local AttackAction
local WalkAction
local HurtAction
local KnockOutAction

function Hero:ctor()
	
end

function Hero:update(dt)
	if ActionState == ACTION_STATE_WALK then
		DesiredPosition = ccpAdd(ccp(self:getPositionX(),self:getPositionY()),ccpMult(Velocity,dt))
	end
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

function Hero:idle()
	if ActionState ~= ACTION_STATE_IDLE then
		self:stopAllActions()
		self:createIdleAction()
		self:runAction(IdleAction)
		ActionState = ACTION_STATE_IDLE
	end
end

function Hero:attack()
	if ActionState ~= ACTION_STATE_ATTACK then
		self:stopAllActions()
		self:createAttackAction()
		self:runAction(AttackAction)
		ActionState = ACTION_STATE_ATTACK
	end
end

function Hero:walkWithDirection(direction)
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
return Hero