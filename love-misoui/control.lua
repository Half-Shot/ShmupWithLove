--Control.lua
local class = require 'middleclass/middleclass'
MUIControl = class('Control')

function MUIControl:initialize(parent)
    self.shoulddraw = true
    self.shouldupdate = true
    self.id = ""
    self.class = ""
    self.parent = parent
end
