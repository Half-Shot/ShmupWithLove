-- enemyboat.lua
require 'projectile'
require 'turret'
require 'shaders/hiteffect'
local class = require 'middleclass/middleclass'
EnemyBoat = class('EnemyBoat',boat)
boatDeathSound = love.sound.newSoundData( "sHit/boatdeath1.ogg" )
boatHitSound = love.sound.newSoundData( "sHit/metal_interaction1.wav" )
function EnemyBoat:load()
    self.name = "EnemyBoat"
	self.spriteNormal = love.graphics.newImage("tEnemyBoat/ship.png")
	self.spriteDead = love.graphics.newImage("tEnemyBoat/ship_destroyed.png")
    self.curSpr = self.spriteNormal
    self.hitbox_tl.x = 0
    self.hitbox_tl.y = -self.spriteNormal:getHeight()
    self.hitbox_br.x = self.spriteNormal:getWidth()
    self.hitbox_br.y = 0 
    self.evadetime = 0
    self.evadetimeperiod = 1.5
    self.xvel = 90
    self.yvel = 90
    self.turret = Turret:new()
    self.turret:load()
    --Hitmarker
    self.hmmaxtime = 0.8
    self.hmtime = 0
    self.hmtext = 0
    self.hmpos = Vector:new(0)
    self.hmtimetoscale = 0.2
    self.hmscale = 0
    self.maxhealth  = 10
    self.health = self.maxhealth
    self.value = 250
    self.hitSound = love.audio.newSource( boatHitSound, "static" )
    self.deathSound = love.audio.newSource( boatDeathSound, "static" )
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
        self.hittable = false
        self.yvel = 120
        self.xvel = 0
        if self.y > love.graphics.getHeight() then
            self.remove = true
        end
    else
        self.turret.tGunRot = math.atan2(playerboat.y - self.y,playerboat.x - self.x ) - (math.pi / 2)
        self.turret:update(dt)
    end
    if self.hmpos.x > 0 then
        self.hmtime = self.hmtime + dt
        if self.hmtext < 25 then
            self.hmscale = math.min(1,self.hmtime/self.hmtimetoscale)
        else
            self.hmscale = 1
        end
        if self.hmtime > self.hmmaxtime then
            self.hmpos = Vector:new(0)
            self.hmtime = 0
            self.hmtext = 0
        end
    end
    if self.y > love.graphics.getHeight() then
        wsShipsAlive = wsShipsAlive - 1
    end
    self.turret.x = self.x + 25
    self.turret.y = self.y - 50
end

function EnemyBoat:draw()
    if self.hmtime < self.hmtimetoscale and self.hmtime > 0 then
        love.graphics.setShader(sHitEffect)
    end
    
    love.graphics.draw(self.spriteDead,self.x,self.y,0,1,-1)
    love.graphics.setColor(255,255,255,255 * (self.health/self.maxhealth))
	love.graphics.draw(self.spriteNormal,self.x,self.y,0,1,-1)
    love.graphics.setColor(255,255,255,255)
    
    if self.hmtime < self.hmtimetoscale and self.hmtime > 0 then
        love.graphics.setShader()
    end
    self.turret:draw()
    if self.hmpos.x > 0 then
        love.graphics.setNewFont(72)
        love.graphics.print( self.hmtext , self.hmpos.x + self.x , self.hmpos.y + self.hitbox_tl.y + self.y,0,self.hmtext / 25, self.hmscale * (self.hmtext / 25))
    end
end