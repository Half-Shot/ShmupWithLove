require (RootShadersPath .. 'water')

-- Loading Water
function loadWater()
  tWaterFrames = 16
  tWaterFrameSize = 256
  tWaterScrollSpeedx = 0.00
  tWaterScrollx = 0
  tWaterScrollSpeedy = 0.05
  tWaterScrolly = 0
  tBgWater = love.graphics.newImage(RootTexturePath .. "tWater/waterbg.png")
  tWater = amanager:loadFrames(RootTexturePath .. "tWater/caust_%03.0f.png",tWaterFrames,1)
  amanager:add("water",tWater,tWaterFrames,30)
end

function updateWater(dt)

  tWaterScrollSpeedy = tileSpeed * 0.01

  if tWaterScrollx < 1 then
	tWaterScrollx = tWaterScrollx + tWaterScrollSpeedx
  else
    tWaterScrollx = 0
  end
  
  if tWaterScrolly < 1 then
	tWaterScrolly = tWaterScrolly + tWaterScrollSpeedy
  else
    tWaterScrolly = 0
  end
end

function drawWater()
  for w=0,math.ceil(love.graphics.getWidth( ) / tWaterFrameSize) do
    for h=0,math.ceil(love.graphics.getHeight( ) / tWaterFrameSize) do
      love.graphics.draw(tBgWater,w*tWaterFrameSize,h*tWaterFrameSize)
      love.graphics.setShader(sWater)
      sWater:send("scrollx",tWaterScrollx)
      sWater:send("scrolly",tWaterScrolly)
      amanager:draw("water",w*tWaterFrameSize,h*tWaterFrameSize)
      love.graphics.setShader()
    end
  end
end
