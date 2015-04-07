-- player.lua
require 'projectile'
require 'projPlayer'
require 'shaders/boatreflection'
local class = require 'middleclass/middleclass'
PlayerBoat = class('PlayerBoat',boat)

function PlayerBoat:initialize()
	Entity.initialize(self)
    self.maxhealth = 20
    self.health = self.maxhealth
end

function PlayerBoat:load()
	self.spriteNormal = love.graphics.newImage("tPlayerBoat/ship_okay.png")
	self.spriteDead = love.graphics.newImage("tPlayerBoat/ship_destr.png")
	self.tGun = love.graphics.newImage("tPlayerBoat/ship_gun_prim.png")
	self.tGunOrigin = Vector:new(7,16)
	
	self.GunOneCooldownPeroid = 0.1
	self.GunOneName = "Bsc. Bolt Laser"
	self.GunOneCooldown = 0
	self.GunOneProjSpeed = 400
	self.GunOneProjDamage = 1
	hudWeaponOneText.text = self.GunOneName
	
	self.GunTwoName = "Spread Bomber"
	self.GunTwoCooldownPeroid = 4
	self.GunTwoCooldown = 0
	self.GunTwoProjSpeed = 600
	self.GunTwoProjDamage = 3
	hudWeaponTwoText.text = self.GunTwoName
	
	self.GunThreeName = "Empty Slot"
	self.GunThreeCooldownPeroid = 4
	self.GunThreeCooldown = 0
	hudWeaponThreeText.text = self.GunThreeName
	
	self.GunFourName = "Empty Slot"
	self.GunFourCooldownPeroid = 4
	self.GunFourCooldown = 0
	hudWeaponFourText.text = self.GunFourName
	
	self.attachmentOne = Vector:new(32,60)
	self.curSpr = self.spriteNormal
	self.xvel = 0
	self.yvel = -200
	self.x = love.graphics.getWidth( ) / 2
	self.y = (love.graphics.getHeight() / 5) * 5
    self.hitbox_tl.x = 0
    self.hitbox_tl.y = 0
    self.hitbox_br.x = self.spriteNormal:getWidth()
    self.hitbox_br.y = self.spriteNormal:getHeight()
	lights[7].R = 255
	lights[7].G = 77
	lights[7].B = 77
	
	self.tGunRot = (math.pi)
	tRippleFrames = 5
	tRipple = amanager:loadFrames("tPlayerBoat/ripple/%03.0f.png",tRippleFrames,0)
	amanager:add("plrripple",tRipple,tRippleFrames,30)
end

function PlayerBoat:update(dt)
	--love.audio.setPosition( self.x, self.y, 0 )
	self.y = self.y + (self.yvel)*dt
	self.x = self.x + (self.xvel)*dt
	if self.y <= 700 then
		self.yvel = 0
	end
	
	-- Gun 1
	if self.GunOneCooldown > 0 then
		self.GunOneCooldown = math.max(self.GunOneCooldown - dt,0)
	end
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
	
	-- Gun 2
	if self.GunTwoCooldown > 0 then
		self.GunTwoCooldown = math.max(self.GunTwoCooldown - dt,0)
	end
	if self.GunTwoCooldown <= 0 and love.mouse.isDown("r") then
		self.GunTwoCooldown = self.GunTwoCooldownPeroid
		for i=-5,5 do
			local proj = ProjectileMissilePlayer:new()
			proj.yvel = math.cos(-self.tGunRot + (i*0.1)) * self.GunTwoProjSpeed
			proj.xvel = math.sin(-self.tGunRot + (i*0.1)) * self.GunTwoProjSpeed
			proj.rot = self.tGunRot			proj.x = self.attachmentOne.x + self.x
			proj.y = self.attachmentOne.y + self.y
			proj.damage = self.GunTwoProjDamage
			projectileList[projectileSlot] = proj
			projectileSlot = projectileSlot + 1
		end
	end
	
	--Check for collisons
    for k,v in pairs(entityManager.entitylist) do
        if v:isInstanceOf(EnemyBoat) then
                x = v.hitbox_tl.x + v.x
                y = v.hitbox_tl.y + v.y
                
                xfits = (x > self.x and x < self.x + self.hitbox_br.x)
                yfits = (y > self.y - (self.hitbox_br.y / 2) and y < self.y + (self.hitbox_br.y / 2))
                if xfits and yfits and v.health > 0 and self.hittable then
					self.health = self.health - (v.health / 4) -- Take some damage
					v.health = 0 --Kill it
					v.sinking = true
                end
        end
    end
    	
	--Movement
	if love.keyboard.isDown('a') then
		self.x = self.x - 10
	elseif love.keyboard.isDown('d') then
		self.x = self.x + 10
	end
	
	
	if love.keyboard.isDown('w') then
		self.y = self.y - 3.3
	elseif love.keyboard.isDown('s') then
		self.y = self.y + 3.3
	end
	lights[7].x = self.attachmentOne.x + self.x
	lights[7].y = self.attachmentOne.y + self.y
	
	self.mx, self.my = love.mouse.getPosition( )
	if love.mouse.isDown("m") then
		self.tGunRot = math.atan2(self.my - (self.attachmentOne.y + self.y),self.mx - (self.attachmentOne.x + self.x) ) - (math.pi / 2)
	end
	
	if self.health < 1 then
		gameState = 'gameover'
		goscore.text = playerScore .. "pts"
		godeaths.text = "You destroyed " .. (wsTotalSpawned - wsTotalSurvived) .. " objects"
		if wsTotalSurvived == 0 then
			gosurvivors.text = "There were *no* survivors."
		else
			gosurvivors.text = wsTotalSurvived .. " survived."
		end
		gocombo.text = "Your best hit combo was " .. bestHitCombo
	end
end

function PlayerBoat:draw()
	amanager:draw("plrripple",self.x - 11,self.y)
	love.graphics.draw(self.curSpr,self.x,self.y)
	love.graphics.draw(self.tGun,self.attachmentOne.x + self.x,self.attachmentOne.y + self.y,self.tGunRot,1,1,self.tGunOrigin.x,self.tGunOrigin.y)
end
