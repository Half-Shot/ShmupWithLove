local class = require 'middleclass/middleclass'
Animation = class('Animation')
function Animation:initialize(frames,framecount,framerate,starton)
	self.frames = frames
	self.framecount = framecount
	self.framerate = 1 / framerate
	self.frame = starton
	self.time = 0
	self.starton = starton
end

function Animation:getFrame()
	return self.frames[self.frame]
end

