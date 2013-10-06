require("config")
require("scenes.define")

local GameLayer  = class("GameLayer", function()
	return display.newLayer()
end)

local Delegate = require("scenes.Controller.SimpleDPadDelegate"):extend()
local TileMap
local DisabledRect
local ActorList = {}
local Actors
local ActorsCurrentIndex = 0
local ActorsIndex = function() 
	ActorsCurrentIndex = ActorsCurrentIndex + 1
return  ActorsCurrentIndex
end
local Hero

function GameLayer:ctor()
	Actors = display.newBatchNode(CONFIG_ROLE_SHEET_IMAGE)
	self:addChild(Actors,1)
	self:initTileMap()
	self:initHero();
	
	self.touchLayer = display.newLayer()
	self:addChild(self.touchLayer,2)
	self:setNodeEventEnabled(true)
	
	local updateFunc = function(dt) self:onUpdate(dt) end
	self:scheduleUpdate(updateFunc)
end

function GameLayer:getClass()
	return Delegate
end

function GameLayer:onUpdate(dt)
	Hero:update(dt)
	self:updatePositions()
end

function GameLayer:updatePositions()
	local position = Hero:getDesiredPosition()
	local posX = math.min(TileMap:getMapSize().width * TileMap:getTileSize().width - Hero:getCenterToSides(),
		math.max(Hero:getCenterToSides(), position.x))
		
	local posY = math.min(3 * TileMap:getTileSize().height + Hero:getCenterToBottom(),
		math.max(Hero:getCenterToBottom(), position.y))
	
	Hero:setPosition(posX,posY)
end

function GameLayer:onTouch(event,x,y)
	--CCLuaLog("Click:"..event.." "..x.." "..y)
	if event == "began" then
		if not DisabledRect:containsPoint(ccp(x,y)) then
			Hero:attack()
			return true
		end
	end
end

function GameLayer:onEnter()
	self.touchLayer:addTouchEventListener(function(event,x,y)
		return self:onTouch(event,x,y)
	end)
	self.touchLayer:setTouchEnabled(true)
end

function GameLayer:initHero()
	Hero = require("scenes.GameObjects.Hero"):new()
	Actors:addChild(Hero)
	Hero:setPosition(Hero:getCenterToSides(),80)
	local x, y = Hero:getPosition()
	Hero:setDesiredPosition(ccp(x,y))
	Hero:idle()
	ActorList[ActorsIndex] = Hero
end

function GameLayer:initTileMap()
	TileMap = CCTMXTiledMap:create(CONFIG_TILEMAP_FILE)
	self:addChild(TileMap,0)
end

function GameLayer:setTouchDisabledRect(param)
	DisabledRect = param
end

function Delegate:didChangeDirectionTo(SimpleDPad,Direction) 
	Hero:walkWithDirection(Direction)
end

function Delegate:isHoldingDirection(SimpleDPad,Direction)
	Hero:walkWithDirection(Direction)
end

function Delegate:simpleDPadTouchEnded(SimpleDPad, Direction)
	if Hero:getActionState() == ACTION_STATE_WALK then
		Hero:idle()
	end
end

return GameLayer