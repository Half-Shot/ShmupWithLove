-- player.lua
playerboat = boat:new()

function playerboat:load()
	spriteNormal = love.graphics.newImage("tPlayerBoat/ship_okay.png")
	spriteDead = love.graphics.newImage("tPlayerBoat/ship_destr.png")
	curSpr = spriteNormal
	xvel = 0
	yvel = -50
	x = love.graphics.getWidth( ) / 2
	y = (love.graphics.getHeight() / 5) * 5
end

function playerboat:update(dt)
	y = y + (yvel)*dt
	x = x + (xvel)*dt
	if y <= 700 then
	yvel = 0
	end
end

function playerboat:draw()
	love.graphics.draw(curSpr,x,y)
end
