require("config")
require("scenes.define")

local GameLayer  = class("GameLayer", function()
	return display.newLayer()
end)

local Delegate = require("scenes.Controller.SimpleDPadDelegate"):extend()
local TileMap
local DisabledRect
local Robots = {}
local Actors
local RobotsCurrentIndex = 0
local RobotsIndex = function() 
	RobotsCurrentIndex = RobotsCurrentIndex + 1
return  RobotsCurrentIndex
end
local Hero

function GameLayer:ctor()
	Actors = display.newBatchNode(CONFIG_ROLE_SHEET_IMAGE)
	self:addChild(Actors,1)
	self:initTileMap()
	self:initHero();
	self:initRobots();
	
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
	self:setViewPointCenter(Hero:getPosition());
end

function GameLayer:setViewPointCenter(heroPosX, heroPosY)
  local x = math.max(heroPosX,SCREEN_SIZE.width/2)
  local y = math.max(heroPosY,SCREEN_SIZE.height/2)
  x = math.min(x,(TileMap:getMapSize().width * TileMap:getTileSize().width) - SCREEN_SIZE.width/2)
  y = math.min(y,(TileMap:getMapSize().height * TileMap:getTileSize().height) - SCREEN_SIZE.height/2)
  local actualPosition = ccp(x,y)
  local viewPoint = ccpSub(CENTER,actualPosition)
  self:setPosition(viewPoint)
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
end

function GameLayer:initRobots()
  local robotCount = 50
  for i = 0, robotCount do
    local robot = require("scenes.GameObjects.Robot"):new()
    Actors:addChild(robot)
    Robots[RobotsIndex] = robot
    
    local minX = SCREEN_SIZE.width + robot:getCenterToSides();
    local maxX = TileMap:getMapSize().width * TileMap:getTileSize().width - robot:getCenterToSides();
    local minY = robot:getCenterToBottom();
    local maxY = 3 * TileMap:getTileSize().height + robot:getCenterToBottom();
    robot:setScaleX(-1);
    robot:setPosition(ccp(math.random(minX, maxX), math.random(minY, maxY)));
    robot:setDesiredPosition(ccp(robot:getPositionX(),robot:getPositionY()));
    robot:idle();
  end
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