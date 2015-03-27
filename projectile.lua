-- projectile.lua
require 'shaders/projbolt'
local class = require 'middleclass/middleclass'
Projectile = class('Projectile',Entity)

function Projectile:load()
    --Projectile has no requirements :)
end

function Projectile:update(dt)
	self.y = self.y + (self.yvel)*dt
	self.x = self.x + (self.xvel)*dt
    --Expensive :(
    for k,v in pairs(hittables) do
        x1 = v.hitbox_tl.x + v.x
        x2 = v.hitbox_br.x + v.x
        y1 = v.hitbox_tl.y + v.y
        y2 = v.hitbox_br.y + v.y
        
        xfits = (self.x >= x1 and self.x <= x2)
        yfits = (self.y >= y1 and self.y <= y2)
        
        if xfits and yfits then
            self.remove = true
            v.health = v.health - self.damage
        end
    end
    self.remove = (self.y < 0 or self.y > love.graphics.getHeight( )) or (self.x < 0 or self.x > love.graphics.getWidth( )) or self.remove
end

function Projectile:draw()
  love.graphics.setShader(sProjBolt)
  love.graphics.setColor(200,60,60)
  love.graphics.draw(blank32,self.x,self.y,self.rot)
  love.graphics.setColor(255,255,255)
  love.graphics.setShader() 
end
