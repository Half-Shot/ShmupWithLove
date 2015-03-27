--Animation Manager
require 'anim'
local class = require 'middleclass/middleclass'
AnimationManager = class('AnimationManager')

function AnimationManager:initialize()
	animations = {}
end

function AnimationManager:update(dt)
	for i=0,table.getn(animations)-1 do
	  local a = animations[i]
	  a.time = a.time + dt
	  if (a.time > a.framerate) then
		a.time = 0
		a.frame = a.frame  + 1
		if (a.frame == a.framecount) then
		  a.frame = 0
		end
	  end
	end
end

function AnimationManager:draw(name,x,y)
	local anim = animations[0]
	love.graphics.draw(anim:getFrame(),x,y)
end

function AnimationManager:add(name,frames,count,framerate)
	print(name)
	local animation = Animation:new(frames,count,framerate,0)
	animations[0] = animation
end

function AnimationManager:rem(name)
	table.remove(animations,name)
end
