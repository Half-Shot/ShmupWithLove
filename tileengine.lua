--tileengine.lua

tileSizeX = 0
tileSizeY = 0
tilePosition = 0
tileLevel = nil
function setLevel(level,width)
	tileLevel = level
	tileSizeX = love.graphics:getWidth() / width
	tileSizeY = love.graphics:getHeight() / width
	tilePosition
end

function tileUpdate(dt)
	if tileLevel == nil then
		error("No tile level loaded")
	end
end

function tileDraw()
	if tileLevel == nil then
		error("No tile level loaded")
	end
end
