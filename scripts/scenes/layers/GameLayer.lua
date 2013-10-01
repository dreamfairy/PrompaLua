local GameLayer  = class("GameLayer", function()
	return display.newScene("GameLayer")
end)

local TileMap
local Actors = {}
local ActorsCurrentIndex = 0
local ActorsIndex = function() 
	ActorsCurrentIndex = ActorsCurrentIndex + 1
return  ActorsCurrentIndex
end
local Hero

function GameLayer:ctor()
	self:initTileMap()
	self:initHero();
end

function GameLayer:initHero()
	Hero = require("scenes.GameObjects.Hero"):new()
	self:addChild(Hero)
	Hero:setPosition(Hero:getCenterToSides(),80)
	Hero:setDesiredPosition(Hero:getPosition())
	Hero:idle()
	Actors[ActorsIndex] = Hero
end

function GameLayer:initTileMap()
	TileMap = CCTMXTiledMap:create(CONFIG_TILEMAP_FILE)
	self:addChild(TileMap)
end

return GameLayer