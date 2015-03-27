require 'water'
require 'entity'
require 'boat'
require 'player'
require 'shaders/water'
require 'animman'

function love.load()
  amanager = AnimationManager:new()
  love.window.setMode(1920,1080)
  love.graphics.setBackgroundColor(57,137,252)
  loadWater()
  playerboat:load()
end

function love.update(dt)
  updateWater(dt)
  amanager:update(dt)
  playerboat:update(dt)
end


function love.draw()
  drawWater()
  playerboat:draw()
end
