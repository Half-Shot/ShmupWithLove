require 'shaders/water'

-- Loading Water
function loadWater()
	tWaterFrames = 16
	tWaterFrameSize = 256
	tWaterScrollSpeed = 0.01
	tWaterScroll = 0
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
  love.graphics.setShader(sWater) --draw something here
  sWater:send("scroll",tWaterScroll)
  for w=0,math.ceil(love.graphics.getWidth( ) / tWaterFrameSize) do
	for h=0,math.ceil(love.graphics.getHeight( ) / tWaterFrameSize) do
		amanager:draw("water",w*tWaterFrameSize,h*tWaterFrameSize)
	end
  end
  love.graphics.setShader()
end
