local initconnection = require("debugger")
initconnection('127.0.0.1' , 10000 , 'luaidekey')

require("config")
require("framework.init")

-- define global module
game = {}

function game.startup()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    display.addSpriteFramesWithFile(CONFIG_ROLE_SHEET_FILE,CONFIG_ROLE_SHEET_IMAGE)

    game.enterMainScene()
end

function game.exit()
    CCDirector:sharedDirector():endToLua()
end

function game.enterMainScene()
    display.replaceScene(require("scenes.GameScene").new(), "fade", 0.6, display.COLOR_WHITE)
end
