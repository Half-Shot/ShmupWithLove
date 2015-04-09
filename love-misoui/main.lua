require 'love-misoui/css'
require 'love-misoui/colors'
require 'love-misoui/control'

--Controls
require 'love-misoui/form'
require 'love-misoui/CLabel'
require 'love-misoui/CClickable'
require 'love-misoui/CButton'
require 'love-misoui/CImage'
require 'love-misoui/CTextbox'

function love.textinput( text )
    CurrentTextInput.text = CurrentTextInput.text .. text
end
