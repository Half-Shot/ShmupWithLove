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
require 'love-misoui/main'
require 'menu'
require 'light'

projectileSlot = 0
projectileList = {}
playerScore = 0
gameState = 'game'
lights = {}
function love.load()
  --love.graphics.setBackgroundColor(255, 255, 255)
  amanager = AnimationManager:new()
  love.window.setMode(1920,1080)
  love.audio.setVolume(1)
  canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
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
  lights[1].R = 255
  lights[1].G = 237
  lights[1].B = 187
  lights[1].A = 255*1.2
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
end


function love.update(dt)
  if gameState == 'game' then
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
  end
end


function love.draw()
  if gameState == 'game' then
    canvas:clear()
    love.graphics.setCanvas(canvas)
    love.graphics.draw(blankMax)
    drawWater()
    entityManager:Draw()
    for k in pairs(projectileList) do
      projectileList[k]:draw()
    end
    love.graphics.setCanvas()
    love.graphics.setShader(sShadowMap)
    sShadowMap:send("ambientLight",{0.33,0.33,0.33,0.33})
    sShadowMap:send("light_pos",lights[1]:NormalizeXY(),lights[2]:NormalizeXY(),lights[3]:NormalizeXY(),lights[4]:NormalizeXY(),lights[5]:NormalizeXY(),lights[6]:NormalizeXY(),lights[7]:NormalizeXY(),lights[8]:NormalizeXY())
    sShadowMap:send("lights",lights[1]:NormalizeColor(),lights[2]:NormalizeColor(),lights[3]:NormalizeColor(),lights[4]:NormalizeColor(),lights[5]:NormalizeColor(),lights[6]:NormalizeColor(),lights[7]:NormalizeColor(),lights[8]:NormalizeColor())
    love.graphics.draw(canvas)
    love.graphics.setShader()
    drawHUD()
  end
end
