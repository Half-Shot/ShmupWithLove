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
tilecolEdgeLeft = 0
tilecolEdgeRight = 0
tilecolEdgeTop = 0
tilecolEdgeBottom = 0

function setLevel(level)
    tileLevel = level
    tileTotalWidth = table.getn(level[1])
    tileLevelLength = table.getn(level)-1
    tileSizeX = love.graphics:getWidth() / tileTotalWidth
    tileSizeY = love.graphics:getHeight() / tileTotalWidth
    tileTotalHeight  = love.graphics:getHeight() / tileSizeY
    tilePosition = 0
    tileRow = 3
    
    --Spawn starting ents
    for r=1,tileTotalWidth do
	for c=1,tileTotalWidth do
	    if tileLevel[r][c][2] ~= 0 then
		spawnEntByPointer(tileLevel[r][c][2],tileSizeX*c,love.graphics:getHeight()-r*tileSizeY)
	    end
	end
    end
    
end

function tileCheckCollision(v)
    --Find Relavent tiles
    x1 = v.hitbox_tl.x + v.x
    x2 = v.hitbox_br.x + v.x
    y1 = v.hitbox_tl.y + v.y
    y2 = v.hitbox_br.y + v.y

    tilecolEdgeLeft = math.ceil((x1 / tileSizeX)-0.5)
    tilecolEdgeRight = math.floor((x2 / tileSizeX)+0.5)
    tilecolEdgeTop = tileTotalHeight - math.floor((y1 / tileSizeY)+0.5) + tileRow
    tilecolEdgeBottom = tileTotalHeight - math.ceil((y2 / tileSizeY)-0.5) + tileRow
    
    tilecolEdgeLeft=math.clamp(1,tilecolEdgeLeft,tileTotalWidth)
    tilecolEdgeRight=math.clamp(1,tilecolEdgeRight,tileTotalWidth)
    tilecolEdgeTop=math.clamp(1+tileRow,tilecolEdgeTop,tileTotalWidth+tileRow)
    tilecolEdgeBottom=math.clamp(1+tileRow,tilecolEdgeBottom,tileTotalWidth+tileRow)
        
	if tileLevel == nil then
		return false
	end
    for row=tilecolEdgeBottom,tilecolEdgeTop do
        for col=tilecolEdgeLeft,tilecolEdgeRight do
            if tileLevel[row][col][1] ~= 0 then
                return true
            end
        end 
    end
    return false
end

function tileUpdate(dt)
    if tileLevel == nil then
	    error("No tile level loaded")
    end
    tilePosition = tilePosition + ((tileSpeed*tileSizeY)*dt)
    if tilePosition > tileSizeY then
        tileRow = tileRow + 1
        tilePosition = 0
	for i,tile in pairs(tileLevel[tileRow+tileTotalHeight]) do
	    if tile[2] ~= 0 then
		--Spawn the ent.
		spawnEntByPointer(tile[2],tileSizeX*i,0-tileBuffer*tileSizeY)
	    end
	end
    end
end

function tileDraw()
    local scaleX = 0
    local scaleY = 0
	if tileLevel == nil then
		error("No tile level loaded")
	end
    love.graphics.setColor(255,255,255,255)
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
		if tile[2] == 90 or tile[2] == 270 then
		    scaleX = tileSizeY / tileImg:getHeight()
		    scaleY = tileSizeX / tileImg:getWidth()
		else
		    scaleX = tileSizeX / tileImg:getWidth()
		    scaleY = tileSizeY / tileImg:getHeight()
		end
                love.graphics.draw(tileImg,x + tileSizeX/2,y + tilePosition  + tileSizeY/2,math.rad(tile[2]),scaleX,scaleY,tileImg:getWidth()/2,tileImg:getHeight()/2)
            end
        end
    end
end
