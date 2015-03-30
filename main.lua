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
require 'shaders/fisheye'
require 'fonts'
require 'helper'
require 'wavespawner'

projectileSlot = 0
projectileList = {}
playerScore = 0
function love.load()
  amanager = AnimationManager:new()
  entityManager = EntityManager:new()
  love.window.setMode(1920,1080)
  love.audio.setVolume(1)
  canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getWidth())
  love.mouse.setVisible(false)
  love.graphics.setBackgroundColor(0,0,0)
  loadWater()
  loadFonts()
  playerboat = PlayerBoat:new()
  playerboat:load()
  entityManager:Add(playerboat)
  -- Generate blank textures
  blank32 = love.graphics.newImage(love.image.newImageData( 32, 32 ))
  blank64 = love.graphics.newImage(love.image.newImageData( 64, 64 ))
  blank128 = love.graphics.newImage(love.image.newImageData( 128, 128 ))
  blank256 = love.graphics.newImage(love.image.newImageData( 256, 256 ))
end


function love.update(dt)
  WaveSpawnerUpdate(dt)
  updateWater(dt)
  amanager:update(dt)
  entityManager:Update(dt)
	for k in pairs(projectileList) do
    projectileList[k]:update(dt)
    if projectileList[k].remove then
      projectileList[k] = nil
    end
  end
end


function love.draw()
  canvas:clear()
  love.graphics.setCanvas(canvas)
  drawWater()
  entityManager:Draw()
  --Hud
  drawHUD()
	for k in pairs(projectileList) do
    projectileList[k]:draw()
  end
  love.graphics.setCanvas()
  love.graphics.setShader(sFisheye)
  love.graphics.draw(canvas)
  love.graphics.setShader()
end
