-- include.lua
-- Due to just how many files are required by main.lua alone, each include has been placed in here for easy editing.
class = require 'middleclass/middleclass'
RootCodePath = 'src/'
RootTexturePath = 'textures/'
RootSoundPath = 'sounds/'
RootFontPath = 'fonts/'
RootShadersPath = 'shaders/'

require (RootCodePath .. 'vector')
require (RootCodePath .. 'fonts')
require (RootCodePath .. 'helper')
require (RootCodePath .. 'color')
require (RootCodePath .. 'state')
require (RootCodePath .. 'game')

require (RootCodePath .. 'Animation/animman')

require (RootCodePath .. 'Entities/entdef')

require (RootCodePath .. 'UI/hud')
require (RootCodePath .. 'UI/mainmenu')

require (RootShadersPath .. 'shadowmap')

require (RootCodePath .. 'Logic/wavespawner')

require (RootCodePath .. 'Effects/water')
require (RootCodePath .. 'Effects/light')

require (RootCodePath .. 'Level/level')
require (RootCodePath .. 'Level/leveleditor')
require (RootCodePath .. 'Tile/tileengine')
require (RootCodePath .. 'Tile/tiledefintions')

