$ = require 'jquery'
io = require 'socket.io-client'
Mobile = require './mobile/indexMobile'
Desktop = require './desktop/indexDesktop'

require ('./assets/Standard/standard09_66-webfont.woff')
require ('./assets/Standard/standard09_66-webfont.woff2')
require ('./assets/title.png')
require ('./assets/cielobonito.png')
require ('./assets/bottombonito.png')
require ('./assets/bottombonito2.png')
require ('./assets/cielofeo.png')
require ('./assets/nubes_frente.png')
require ('./assets/boton1.png')
require ('./assets/fondo.png')
require ('./assets/fondo.png')
require ('./assets/sprite/json/sprites.png')

if window.location.pathname == '/mobile'
  new Mobile()
if window.location.pathname == '/desktop'
  new Desktop()
