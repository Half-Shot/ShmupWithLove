require 'vector'
require 'entity'
require 'animman'
require 'boat'
require 'player'
require 'hud'
require 'water'
require 'enemyboat'
require 'entityman'
require 'color'
require 'shaders/shadowmap'
require 'fonts'
require 'helper'
require 'wavespawner'
require 'menu'
require 'light'
GameVersionString = "ShmupWithLove v0.05"
projectileSlot = 0
projectileList = {}
playerScore = 0
gameState = 'menu'
lights = {}
waterDistort = love.math.newRandomGenerator( )
function love.load()
  --love.graphics.setBackgroundColor(255, 255, 255)
  amanager = AnimationManager:new()
  love.window.setMode(1920,1080)
  love.audio.setVolume(1)
  --Horrible, only way of doing blur.
  reflectionBufferA = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  reflectionBufferB = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  
  water = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  foreGround = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  hudCanvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  
  love.mouse.setVisible(false)
  love.graphics.setBackgroundColor(0,0,0)
  loadWater()
  loadFonts()
  loadMenu()
  loadHUD()
  for i=1,8 do
    lights[i] = Light:new(0,0,0,0)
  end
  check = love.graphics.newImage("tTest/check.jpg")
  --Sunlight
  lights[1].R = 187
  lights[1].G = 237
  lights[1].B = 255
  lights[1].A = 225
  lights[1].x = 1920/2
  lights[1].y = 1080/2
  playerboat = PlayerBoat:new()
  playerboat:load()
  entityManager = EntityManager:new()
  entityManager:Add(playerboat)
  -- Generate blank textures
  blank32 = love.graphics.newImage(love.image.newImageData( 32, 32 ))
  blank64 = love.graphics.newImage(love.image.newImageData( 64, 64 ))
  blank128 = love.graphics.newImage(love.image.newImageData( 128, 128 ))
  blank256 = love.graphics.newImage(love.image.newImageData( 256, 256 ))
  blankMax = love.graphics.newImage(love.image.newImageData( love.graphics.getWidth(), love.graphics.getHeight() ))
  tProjMissilePlayer = love.graphics.newImage("tProjectiles/tMissile.png")
end


function love.update(dt)
  if gameState == 'game' then
    sReflectionLayer:send("distort",dt * 0.2)
    WaveSpawnerUpdate(dt)
    updateWater(dt)
    amanager:update(dt)
    updateHUD(dt)
    entityManager:Update(dt)
    for k in pairs(projectileList) do
      projectileList[k]:update(dt)
      if projectileList[k].remove then
        projectileList[k] = nil
      end
    end
  elseif gameState == 'menu' then
    amanager:update(dt)
    updateWater(dt)
    updateMenu(dt)
  end
end

function love.draw()
  if gameState == 'game' then
    hudCanvas:clear()
    --Draw Water (Not dependant)
    water:clear()
    love.graphics.setCanvas(water)
    drawWater()
    love.graphics.setCanvas()
    
    --Draw Entites (Not Dependant)
    foreGround:clear()
    love.graphics.setCanvas(foreGround)
    entityManager:Draw()
    for k in pairs(projectileList) do
      projectileList[k]:draw()
    end
    love.graphics.setCanvas()
    drawBlur()
    
    sShadowMap:send("ambientLight",{0.75,0.75,0.75,1})
    sShadowMap:send("light_pos",lights[1]:NormalizeXY(),lights[2]:NormalizeXY(),lights[3]:NormalizeXY(),lights[4]:NormalizeXY(),lights[5]:NormalizeXY(),lights[6]:NormalizeXY(),lights[7]:NormalizeXY(),lights[8]:NormalizeXY())
    sShadowMap:send("lights",lights[1]:NormalizeColor(),lights[2]:NormalizeColor(),lights[3]:NormalizeColor(),lights[4]:NormalizeColor(),lights[5]:NormalizeColor(),lights[6]:NormalizeColor(),lights[7]:NormalizeColor(),lights[8]:NormalizeColor())
    love.graphics.setShader(sShadowMap)
    love.graphics.draw(water)
    
    love.graphics.setShader()
    love.graphics.setBlendMode( "additive" )
    love.graphics.draw(reflectionBufferA)
    love.graphics.setBlendMode( "alpha" )
    
    love.graphics.setShader(sShadowMap)
    love.graphics.draw(foreGround)
    love.graphics.setShader()
    
    drawHUD()
  elseif gameState == 'menu' then
    drawWater() -- Background
    drawMenu()
  end
end


function drawBlur()
    reflectionBufferA:clear()
    love.graphics.setCanvas(reflectionBufferA)
    love.graphics.draw(foreGround)
    love.graphics.setShader(sReflectionLayer)
    for i=0,6 do
      reflectionBufferB:clear()
      love.graphics.setCanvas(reflectionBufferB)
      love.graphics.draw(reflectionBufferA)
      reflectionBufferA:clear()
      love.graphics.setCanvas(reflectionBufferA)
      love.graphics.draw(reflectionBufferB)
    end
    love.graphics.setCanvas()
    love.graphics.setShader()
end
