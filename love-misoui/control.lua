--Control.lua
local class = require 'middleclass/middleclass'
MUIControl = class('Control')

function MUIControl:initialize(parent,id)
    self.shoulddraw = true
    self.shouldupdate = true
    self.id = id
    self.class = ""
    self.type = "NOTYPE"
    self.parent = parent
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.bgColor = UIColor:new(225,10,225)
    self.fgColor = UIColor:new(255,255,255)
    self.opacity = 255
end

function MUIControl:getWidth()
    return self.width
end

function MUIControl:getHeight()
    return self.height
end

function MUIControl:ApplyRule(rule)
    print("Rule " .. rule.Name .. " could not be applied to " .. self.id .. " because the control does not use it.")
end

function MUIControl:ApplyRules(ruleset)
    for _,item in pairs(ruleset.rules) do
        if item.Name == "opacity" then
            if item.Type == muiRuleType[2] then
                self.opacity = item.Value
            elseif item.Type == muiRuleType[4] then
                self.opacity = item.Value*255
            end
        elseif item.Name == "background-color" then
            self.bgColor.R = item.Value.R      
            self.bgColor.G = item.Value.G    
            self.bgColor.B = item.Value.B    
        elseif item.Name == "color" then
            self.fgColor.R = item.Value.R      
            self.fgColor.G = item.Value.G    
            self.fgColor.B = item.Value.B    
        elseif item.Name == "top" then
            if item.Type == muiRuleType[2] or item.Type == muiRuleType[3] then
                self.y = item.Value
            elseif item.Type == muiRuleType[4] then
                self.y = item.Value * self.parent:getHeight()
            end 
        elseif item.Name == "left" then
            if item.Type == muiRuleType[2] or item.Type == muiRuleType[3] then
                self.x = item.Value
            elseif item.Type == muiRuleType[4] then
                self.x = item.Value * self.parent:getWidth()
            end
        elseif item.Name == "right" then
            if item.Type == muiRuleType[2] or item.Type == muiRuleType[3] then
                self.x = self.parent:getWidth() - item.Value
            elseif item.Type == muiRuleType[4] then
                self.x = self.parent:getWidth() - (item.Value * self.parent:getWidth())
            end
        elseif item.Name == "bottom" then
            if item.Type == muiRuleType[2] or item.Type == muiRuleType[3] then
                self.y = self.parent:getHeight() - item.Value
            elseif item.Type == muiRuleType[4] then
                self.y = self.parent:getHeight() - (item.Value * self.parent:getHeight())
            end
        elseif item.Name == "width" then
            if item.Type == muiRuleType[2] or item.Type == muiRuleType[3] then
                self.width = item.Value
            elseif item.Type == muiRuleType[4] then
                self.width = item.Value * self.parent:getWidth()
            end
        elseif item.Name == "height" then
            if item.Type == muiRuleType[2] or item.Type == muiRuleType[3] then
                self.height = item.Value
            elseif item.Type == muiRuleType[4] then
                self.height = item.Value * self.parent:getHeight()
            end
        else
            self:ApplyRule(item)
        end
    end
end

function MUIControl:Update(dt)

end

function MUIControl:Draw()
    --Fallback drawing method
    love.graphics.setColor(self.bgColor.R,self.bgColor.G,self.bgColor.B,self.opacity)
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
    love.graphics.setColor(255,255,255)
end
