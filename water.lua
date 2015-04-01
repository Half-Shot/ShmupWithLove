require 'shaders/water'

-- Loading Water
function loadWater()
  tWaterFrames = 16
  tWaterFrameSize = 256
  tWaterScrollSpeed = 0.01
  tWaterScroll = 0
  tBgWater = love.graphics.newImage("tWater/waterbg.png")
  tWater = amanager:loadFrames("tWater/caust_%03.0f.png",tWaterFrames,1)
  amanager:add("water",tWater,tWaterFrames,15)
end

function updateWater(dt)
  if tWaterScroll < 1 then
	tWaterScroll = tWaterScroll + tWaterScrollSpeed
  else
    tWaterScroll = 0
  end
end

function drawWater()
  for w=0,math.ceil(love.graphics.getWidth( ) / tWaterFrameSize) do
    for h=0,math.ceil(love.graphics.getHeight( ) / tWaterFrameSize) do
      love.graphics.draw(tBgWater,w*tWaterFrameSize,h*tWaterFrameSize)
      love.graphics.setShader(sWater)
      sWater:send("scroll",tWaterScroll)
      amanager:draw("water",w*tWaterFrameSize,h*tWaterFrameSize)
      love.graphics.setShader()
    end
  end
end
