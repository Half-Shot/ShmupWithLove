--CTextbox.lua
require 'love-misoui/control'
local class = require 'middleclass/middleclass'
CTextbox = class('CTextbox',CClickable)

function CTextbox:initialize(parent,id,font,defaulttext)
    CClickable.initialize(self, parent,id)
    self.font = font
    self.fontsize = 12
    self.text = defaulttext
    self.bgColor = UIColor:new(255,255,255)
    self.fgColor = UIColor:new(0,0,0)
    self.borderColor = UIColor:new(0,0,0)
    self.blinky = false
    self.blinkfrequency = 4
    self.blinktime = 0
    self.curpos = 0
    self.backspacedelay = 0
    self.backspacethres = 0.1
end

function CTextbox:ApplyRule(rule)
    if rule.Name == "content" then
        self.text = rule.Value
    elseif rule.Name == "font-family" then
        self.fontfamily = rule.Value
    elseif rule.Name == "font-size" then
        self.fontsize = rule.Value
    elseif rule.Name == "border-color" then
        self.borderColor = rule.Value
    else
        CClickable.ApplyRule(self,rule)
    end
end

function CTextbox:ApplyRules(ruleset)
    CClickable.ApplyRules(self,ruleset)
    if self.font == nil then
        if self.fontfamily then
            self.font = love.graphics.newFont(self.fontfamily, self.fontsize)
        else
            self.font = love.graphics.newFont(self.fontfamily, self.fontsize)
        end
    end
end

function CTextbox:defocused()
    love.keyboard.setTextInput(false)
    love.keyboard.setKeyRepeat(false)
end

function CTextbox:focused()
    love.keyboard.setTextInput(true)
    love.keyboard.setKeyRepeat(true)
    CurrentTextInput = self
end

function CTextbox:Update(dt)
    CClickable.Update(self,dt)
    if self.clicked then
        self.parent:RequestFocus(self)
    end
    if self.hasFocus then
        if love.keyboard.isDown('backspace') then
            self.backspacedelay = self.backspacedelay + dt
            if self.backspacedelay > self.backspacethres then
                self.backspacedelay = self.backspacedelay - self.backspacethres
                self.text = string.sub(self.text, 1,string.len(self.text)-1)
            end
        end
        self.curpos = self.font:getWidth( self.text ) + 3
        self.blinktime = self.blinktime + dt
        if self.blinktime > 1 / self.blinkfrequency then
            self.blinky = (self.blinky == false)
            self.blinktime = 0
        end
    end
end

function CTextbox:Draw()
    love.graphics.setColor(self.bgColor.R,self.bgColor.G,self.bgColor.B,self.opacity)
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
    love.graphics.setColor(self.borderColor.R,self.borderColor.G,self.borderColor.B,self.opacity)
    love.graphics.rectangle('line',self.x,self.y,self.width,self.height)
    if self.blinky then
        love.graphics.rectangle('fill',self.x + self.curpos,self.y+2,2,self.height-4)
    end
    love.graphics.setColor(self.fgColor.R,self.fgColor.G,self.fgColor.B,self.opacity)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text,self.x+3,self.y+3)
end
