-- turret.lua
require 'projectile'
local class = require 'middleclass/middleclass'
Turret = class('Turret',Entity)

function Turret:load()
	self.tGun = love.graphics.newImage("tPlayerBoat/ship_gun_prim.png")
	self.tGunOrigin = Vector:new(7,16)
end

function Turret:update(dt)
    self.tGunRot = math.atan2(playerboat.y - self.y,playerboat.x - self.x ) - (math.pi / 2)
end

function Turret:draw()
	love.graphics.draw(self.tGun,self.x,self.y,self.tGunRot,1,1,self.tGunOrigin.x,self.tGunOrigin.y)
end
