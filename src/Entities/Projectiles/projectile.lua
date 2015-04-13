-- projectile.lua
require (RootShadersPath .. 'projbolt')
local class = require 'middleclass/middleclass'
Projectile = class('Projectile',Entity)

function Projectile:initialize()
    self.color = Color:new(0,0,0)
end

function Projectile:update(dt)
	self.y = self.y + (self.yvel)*dt
	self.x = self.x + (self.xvel)*dt
    self.remove = (self.y < 0 or self.y > love.graphics.getHeight( )) or (self.x < 0 or self.x > love.graphics.getWidth( )) or self.remove
end

function Projectile:draw()
  love.graphics.setShader(sProjBolt)
  love.graphics.setColor(self.color.r,self.color.g,self.color.b)
  love.graphics.draw(blank32,self.x,self.y,self.rot)
  love.graphics.setColor(255,255,255)
  love.graphics.setShader() 
end
