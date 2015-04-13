--entdef.lua

require (RootCodePath .. 'Entities/entity')
require (RootCodePath .. 'Entities/entityman')
require (RootCodePath .. 'Entities/Boat/boat')
require (RootCodePath .. 'Entities/Boat/player')
require (RootCodePath .. 'Entities/Boat/enemyboat')
require (RootCodePath .. 'Entities/Powerups/powerup')

--Entity Definition File
EntityDefinition = {}
EntityDefinition[1] = EnemyBoat    
EntityDefinition[2] = Turret
EntityDefinition[3] = Powerup
