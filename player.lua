-- player.lua
require 'projectile'
require 'projPlayer'
local class = require 'middleclass/middleclass'
PlayerBoat = class('PlayerBoat',boat)

function PlayerBoat:load()
	self.spriteNormal = love.graphics.newImage("tPlayerBoat/ship_okay.png")
	self.spriteDead = love.graphics.newImage("tPlayerBoat/ship_destr.png")
	self.tCross = love.graphics.newImage("tCrosshair/cross.png")
	self.tCrossHit = love.graphics.newImage("tCrosshair/cross-hit.png")
	self.tGun = love.graphics.newImage("tPlayerBoat/ship_gun_prim.png")
	self.tGunOrigin = Vector:new(7,16)
	self.GunOneCooldownPeroid = 0.1
	self.GunOneCooldown = 0
	self.GunOneProjSpeed = 400
	self.GunOneProjDamage = 1
	self.attachmentOne = Vector:new(32,60)
	self.curcross = self.tCross
	self.crossScale = 0.15
	self.curSpr = self.spriteNormal
	self.xvel = 0
	self.yvel = -50
	self.x = love.graphics.getWidth( ) / 2
	self.y = (love.graphics.getHeight() / 5) * 5
    self.hitbox_tl.x = 0
    self.hitbox_tl.y = 0
    self.hitbox_br.x = self.spriteNormal:getWidth()
    self.hitbox_br.y = self.spriteNormal:getHeight()
	
	tRippleFrames = 5
	tRipple = amanager:loadFrames("tPlayerBoat/ripple/%03.0f.png",tRippleFrames,0)
	amanager:add("plrripple",tRipple,tRippleFrames,30)
end

function PlayerBoat:update(dt)
	--love.audio.setPosition( self.x, self.y, 0 )
	self.y = self.y + (self.yvel)*dt
	self.x = self.x + (self.xvel)*dt
	if self.y <= 900 then
		self.yvel = 0
	end
	-- Gun 1
	if self.GunOneCooldown <= 0 and love.mouse.isDown("l") then
		self.GunOneCooldown = self.GunOneCooldownPeroid
		local proj = ProjectilePlayer:new()
		proj.yvel = math.cos(-self.tGunRot) * self.GunOneProjSpeed
		proj.xvel = math.sin(-self.tGunRot) * self.GunOneProjSpeed
		proj.rot = self.tGunRot
		proj.x = self.attachmentOne.x + self.x
		proj.y = self.attachmentOne.y + self.y
		proj.damage = self.GunOneProjDamage
		projectileList[projectileSlot] = proj
		projectileSlot = projectileSlot + 1
		
	end
	if self.GunOneCooldown > 0 then
		self.GunOneCooldown = math.max(self.GunOneCooldown - dt,0)
	end
	
	--Movement
	if love.keyboard.isDown('a') then
		self.x = self.x - 5
	elseif love.keyboard.isDown('d') then
		self.x = self.x + 5
	end
	
	
	if love.keyboard.isDown('w') then
		self.y = self.y - 3.3
	elseif love.keyboard.isDown('s') then
		self.y = self.y + 3.3
	end
	
	self.mx, self.my = love.mouse.getPosition( )
	self.tGunRot = math.atan2(self.my - (self.attachmentOne.y + self.y),self.mx - (self.attachmentOne.x + self.x) ) - (math.pi / 2)
end

function PlayerBoat:draw()
	amanager:draw("plrripple",self.x - 11,self.y)
	love.graphics.draw(self.curSpr,self.x,self.y)
	love.graphics.draw(self.tGun,self.attachmentOne.x + self.x,self.attachmentOne.y + self.y,self.tGunRot,1,1,self.tGunOrigin.x,self.tGunOrigin.y)
	love.graphics.draw(self.curcross,self.mx - (self.curcross:getWidth( ) * self.crossScale / 2) ,self.my - (self.curcross:getHeight( )  * self.crossScale / 2),0,self.crossScale,self.crossScale)
end
