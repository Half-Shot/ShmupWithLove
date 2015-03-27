-- enemyboat.lua
require 'projectile'
require 'turret'
local class = require 'middleclass/middleclass'
EnemyBoat = class('EnemyBoat',boat)

function EnemyBoat:load()
	self.spriteNormal = love.graphics.newImage("tEnemyBoat/ship.png")
	self.spriteDead = love.graphics.newImage("tEnemyBoat/ship_destroyed.png")
    self.curSpr = self.spriteNormal
    self.hitbox_tl.x = 0
    self.hitbox_tl.y = 0
    self.hitbox_br.x = self.spriteNormal:getWidth()
    self.hitbox_br.y = self.spriteNormal:getHeight()
    self.evadetime = 0
    self.evadetimeperiod = 1.5
    --self.xvel = 90
    self.turret = Turret:new()
    self.turret:load()
end

function EnemyBoat:update(dt)
    self.y = self.y + self.yvel * dt
    self.x = self.x + self.xvel * dt 
    --Simple AI
    if self.evadetime > self.evadetimeperiod then
        self.xvel = -self.xvel
        self.evadetime = 0
    end
    self.evadetime = self.evadetime + dt
    if self.health <= 0 then
        self.curSpr = self.spriteDead
        self.yvel = 120
        self.xvel = 0
        if self.y > love.graphics.getHeight() then
            self.remove = true
            self.remove = true
        end
    else
        self.turret:update(dt)
    end
    self.turret.x = self.x + 25
    self.turret.y = self.y + 50
end

function EnemyBoat:draw()
	love.graphics.draw(self.curSpr,self.x,self.y)
    self.turret:draw()
end
