---Animation Manager

require (RootCodePath .. 'Animation/anim')

local class = require 'middleclass/middleclass'
AnimationManager = class('AnimationManager')

function AnimationManager:initialize()
	self.animations = {}
end

function AnimationManager:update(dt)
	for k in pairs(self.animations) do
	  local a = self.animations[k]
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
	local anim = self.animations[name]
	love.graphics.draw(anim:getFrame(),x,y)
end

function AnimationManager:loadFrames(string,framecount,startsat)
	t = {}
	for i=0,framecount-1 do
		fName = string.format(string,i+startsat)
		t[i] = love.graphics.newImage(fName)
	end
	return t
end

function AnimationManager:add(name,frames,count,framerate)
	local animation = Animation:new(frames,count,framerate,0)
	self.animations[name] = animation
end

function AnimationManager:rem(name)
	table.remove(self.animations,name)
end
