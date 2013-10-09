local GameScene  = class("GameScene", function()
	return display.newScene("GameScene")
end)

require("config")
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
    
    audio.playEffect(GAME_SFX.BGM,true)
end

return GameScene