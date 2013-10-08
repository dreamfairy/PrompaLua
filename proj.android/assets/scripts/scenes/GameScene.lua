require("config")

local GameScene  = class("GameScene", function()
	return display.newScene("GameScene")
end)

local GameLayer = require("scenes.layers.GameLayer").new()
local HudLayer = require("scenes.layers.HudLayer").new()

function GameScene:ctor()
    self:addChild(GameLayer)
    self:addChild(HudLayer)
    
    local DPad =  HudLayer:getDPad()
    DPad:setDelegate(GameLayer:getClass())
    local DPadSize = DPad:getContentSize()
    GameLayer:setTouchDisabledRect(CCRect(
    DPad:getPositionX() - DPadSize.width/2,
    DPad:getPositionY() - DPadSize.height/2,
    DPadSize.width,
    DPadSize.height))
end

return GameScene