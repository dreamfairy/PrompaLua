require("config")

local GameScene  = class("GameScene", function()
	return display.newScene("GameScene")
end)

local GameLayer = require("scenes.layers.GameLayer")
local HudLayer = require("scenes.layers.HudLayer")

function GameScene:ctor()
    self:addChild(GameLayer:new())
    self:addChild(HudLayer:new())
end

return GameScene