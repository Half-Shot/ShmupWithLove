--ruleset.lua
local class = require 'middleclass/middleclass'
Ruleset = class('Ruleset')

function Ruleset:initialize(declrType,selector)
    self.declrType = declrType
    self.selector = selector
    self.rules = {}
end

Rule = class('Rule')

function Rule:initialize(key,atype,value)
    self.Name = key
    self.Type = atype
    self.Value = value
end

UIColor = class('UIColor')

function UIColor:initialize(R,G,B)
    self.R = R
    self.G = G
    self.B = B
end
