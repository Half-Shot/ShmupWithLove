require 'vector'
require 'entity'
require 'animman'
require 'boat'
require 'player'
require 'water'
require 'enemyboat'

projectileSlot = 0
projectileList = {}

hittablesSlot = 0
hittables = {}

function love.load()
  amanager = AnimationManager:new()
  love.window.setMode(1920,1080)
  love.mouse.setVisible(false)
  love.graphics.setBackgroundColor(57,137,252)
  loadWater()
  playerboat:load()
  
  -- Generate blank textures
  blank32 = love.graphics.newImage(love.image.newImageData( 32, 32 ))
  blank64 = love.graphics.newImage(love.image.newImageData( 64, 64 ))
  blank128 = love.graphics.newImage(love.image.newImageData( 128, 128 ))
  blank256 = love.graphics.newImage(love.image.newImageData( 256, 256 ))
  for i=0,20 do
    local target = EnemyBoat:new()
    target:load()
    target.x = 80 * (i+1)
    target.y = 50
    hittables[hittablesSlot] = target
    hittablesSlot = hittablesSlot + 1
  end
end


function love.update(dt)
  updateWater(dt)
  amanager:update(dt)
  playerboat:update(dt)
  
	for k in pairs(hittables) do
    hittables[k]:update(dt)
    if hittables[k].remove then
      table.remove(hittables,k)
    end
  end
  
	for k in pairs(projectileList) do
    projectileList[k]:update(dt)
    if projectileList[k].remove then
      table.remove(projectileList,k)
    end
  end
end


function love.draw()
  drawWater()
  --Hud
  --Gun One Cooldown
  love.graphics.setColor(10,10,10)
  love.graphics.rectangle( 'line', love.graphics.getWidth() / 15, (love.graphics.getHeight() / 10) * 9, 200, 30 )
  love.graphics.setColor(150,40,40)
  love.graphics.rectangle( 'fill', (love.graphics.getWidth() / 15) , (love.graphics.getHeight() / 10) * 9, 200 * (playerboat.GunOneCooldown / playerboat.GunOneCooldownPeroid), 30 )
  love.graphics.setColor(255,255,255)
	for k in pairs(hittables) do
    hittables[k]:draw()
  end
  playerboat:draw()
	for k in pairs(projectileList) do
    projectileList[k]:draw()
  end
end
