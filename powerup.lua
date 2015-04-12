--powerup.lua
Powerup = class('Powerup',Entity)
Powerup.static.name = "Powerup"
function Powerup:initialize()
  self.x = 0
  self.y = 0
  self.xvel = 0
  self.yvel = 80
  self.scalex = 0.25
  self.scaley = 0.25
  self.remove = false
  self.target = nil
  self.sprite = tPUPCrate
end

function Powerup:load()
end

function Powerup:update(dt)
    self.x = self.x + dt*self.xvel
    self.y = self.y + dt*self.yvel
    
    local v = self.target
    local x1 = v.hitbox_tl.x + v.x
    local x2 = v.hitbox_br.x + v.x
    local y1 = v.hitbox_tl.y + v.y
    local y2 = v.hitbox_br.y + v.y
    
    local xfits = (self.x >= x1 and self.x <= x2)
    local yfits = (self.y >= y1 and self.y <= y2)
    if xfits and yfits then
        self:AddEffect()
        self.remove = true
    end
    
end

function Powerup:AddEffect(target)
    print("Powerup has no defined effect.")
end

function Powerup:draw()
    love.graphics.draw(self.sprite,self.x,self.y,0,self.scalex,self.scaley)
end


FixPowerup = class('FixPowerup',Powerup)
function FixPowerup:load()
    self.sprite = tPUPFixCrate
end

function FixPowerup:AddEffect()
    self.target.health = math.min(self.target.health + (self.target.maxhealth / 4),self.target.maxhealth)
end
