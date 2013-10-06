local SimleDpadDelegate = {}

function SimleDpadDelegate:extend()
	local o = {}
	setmetatable(o,self)
	self.__index = self
	return o
end

function SimleDpadDelegate:didChangeDirectionTo(SimpleDPad,Direction) 
	CCLuaLog("This function muse be written")
end

function SimleDpadDelegate:isHoldingDirection(SimpleDPad,Direction)
	CCLuaLog("This function muse be written")
end

function SimleDpadDelegate:simpleDPadTouchEnded(SimpleDPad, Direction)
	CCLuaLog("This function muse be written")
end

return SimleDpadDelegate
