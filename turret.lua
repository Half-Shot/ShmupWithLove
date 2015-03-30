-- turret.lua
require 'projEnemyBasic'
local class = require 'middleclass/middleclass'
Turret = class('Turret',Entity)

function Turret:load()
	self.tGun = love.graphics.newImage("tPlayerBoat/ship_gun_prim.png")
	self.tGunOrigin = Vector:new(7,16)
	self.firerate = 0.5
	self.cooldown = self.firerate
	self.projspeed = 500
	self.damage = 0
end

function Turret:update(dt)
    self.tGunRot = math.atan2(playerboat.y - self.y,playerboat.x - self.x ) - (math.pi / 2)
    if self.cooldown <= 0 then
	self.cooldown = 1/self.firerate
	local proj = ProjectileEnemyBasic:new()
	proj.yvel = math.cos(-self.tGunRot) * self.projspeed
	proj.xvel = math.sin(-self.tGunRot) * self.projspeed
	proj.rot = self.tGunRot
	proj.x = self.x
	proj.y = self.y
	proj.damage = self.damage
	table.insert(projectileList,proj)
	projectileSlot = projectileSlot + 1
    else
        self.cooldown = self.cooldown - dt
    end
end

function Turret:draw()
	love.graphics.draw(self.tGun,self.x,self.y,self.tGunRot,1,1,self.tGunOrigin.x,self.tGunOrigin.y)
end
