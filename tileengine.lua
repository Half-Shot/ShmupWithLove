--tileengine.lua
tileSizeX = 0
tileSizeY = 0
tilePosition = 0
tileTotalWidth = 0
tileTotalHeight = 0
tileSpeed = 1 --per second
tileRow = 3
tileBuffer=2
selectedLevel = nil
function setLevel(level)--name,author,rows
	tileLevel = level
    tileTotalWidth = table.getn(level[1])
    tileLevelLength = table.getn(level)-1
	tileSizeX = love.graphics:getWidth() / tileTotalWidth
	tileSizeY = love.graphics:getHeight() / tileTotalWidth
    tileTotalHeight  = love.graphics:getHeight() / tileSizeY
	tilePosition = 0
    tileRow = 3
end

function tileUpdate(dt)
	if tileLevel == nil then
		error("No tile level loaded")
	end
    tilePosition = tilePosition + ((tileSpeed*tileSizeY)*dt)
    if tilePosition > tileSizeY then
        tileRow = tileRow + 1
        tilePosition = 0
    end
end

function tileDraw()
	if tileLevel == nil then
		error("No tile level loaded")
	end
    for r=tileRow-tileBuffer,tileTotalHeight+tileRow+tileBuffer do
        for c=1,tileTotalWidth do
            local tile = tileLevel[r][c]
            local x = (c-1)*tileSizeX
            local y = (tileTotalHeight-r+tileRow-tileBuffer)*tileSizeY
            tileImg = tileset[tile[1]]
            if tileImg == nil then
                tileImg = check
            end
            if tile[1] ~= 0 then
                love.graphics.draw(tileImg,x,y + tilePosition,0,tileSizeX / tileImg:getWidth(),tileSizeY / tileImg:getHeight())
            end
        end
    end
end
