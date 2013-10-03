local SimpleDPad  = class("SimpleDPad", function()
	return display.newSprite("pd_dpad.png")
end)

local Radius
local Direction
local IsHeld
local Delegate

function SimpleDPad:ctor()
	local updateFunc = function(dt) self:onUpdate(dt) end
	IsHeld = false
	Direction = CCPointZero
	self:scheduleUpdate(updateFunc)
	self:setNodeEventEnabled(true)
	
	self.touchLayer = display.newLayer()
	self:addChild(self.touchLayer)
end

function SimpleDPad:updateDirectionForTouchLocation(location)
	local radians = ccpToAngle(ccpSub(location,ccp(self:getPositionX(),self:getPositionY())))
	local degrees = -1 * math.deg(radians)
	
	if degrees <= 22.5 and degrees >= -22.5 then
		--right
		Direction = ccp(1.0,0.0)
	elseif degrees > 22.5 and degrees < 67.5 then
		--bottom right
	 	Direction = ccp(1.0,-1.0)
	 elseif degrees >= 67.5 and degrees <= 112.5 then
	 	--bottom
	 	Direction = ccp(0.0,-1.0)
	elseif degrees  > 112.5 and degrees < 157.5 then
		--bottom left
		Direction = ccp(-1.0,-1.0)
	elseif degrees >= 157.5 or degrees <= -157.5 then
		--left
		Direction = ccp(-1.0,0.0)
	elseif degrees < -22.5 and degrees > -67.5 then
		--top right
		Direction = ccp(1.0,1.0)
	elseif degrees <= -67.5 and degrees >= -112.5 then
		--top
		Direction = ccp(0.0,1.0)
	elseif degrees < -112.5 and  degrees > -157.5 then
		--top left
		Direction = ccp(-1.0,1.0)
	end
	
	Delegate:didChangeDirectionTo(self,Direction)
end

function SimpleDPad:onEnter()
	self.touchLayer:addTouchEventListener(function(event,x,y)
	return self:onTouch(event,x,y)
	end)
	self.touchLayer:setTouchEnabled(true)
end

function SimpleDPad:onExit()
	self.touchLayer:removeTouchEventListener()
	self:setTouchEnabled(false)
end

function SimpleDPad:onUpdate(dt)
	--CCLuaLog(dt)
	if IsHeld == true then
		Delegate:isHoldingDirection(self,Direction)
		end
end

function SimpleDPad:setRadius(value)
	Radius = value;
end

function SimpleDPad:setDelegate(value)
	Delegate = value
end

function SimpleDPad:onTouch(event,x,y)
	local location = ccp(x,y)
	if event == "began" then
		local distanceSQ = ccpDistanceSQ(location, ccp(self:getPositionX(),self:getPositionY()))
		if distanceSQ <= Radius * Radius then
			self:updateDirectionForTouchLocation(location)
			IsHeld = true
			return true
			end
		return false
	end
	
	if event == "moved" then
		self:updateDirectionForTouchLocation(location)
	end
	
	if event == "ended" then
		location = CCPointZero
		IsHeld = false
		Delegate:simpleDPadTouchEnded(self)
	end
end

return SimpleDPad