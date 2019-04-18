$ = require 'jquery'
io = require 'socket.io-client'
Mobile = require './mobile/indexMobile'
Desktop = require './desktop/indexDesktop'

require ('./assets/Standard/standard09_66-webfont.woff')
require ('./assets/Standard/standard09_66-webfont.woff2')
require ('./assets/images/title.png')
require ('./assets/images/cielobonito.png')
require ('./assets/images/bottombonito.png')
require ('./assets/images/bottombonito2.png')
require ('./assets/images/cielofeo.png')
require ('./assets/images/nubes_frente.png')
require ('./assets/images/boton1.png')
require ('./assets/images/fondo.png')
require ('./assets/images/fondo.png')
require ('./assets/sprite/json/sprites.png')
require ('./assets/sprite/sombrajson/sombra.png')
require ('./assets/sprite/enemyjson/enemyjson.png')
require ('./assets/black.mp4')

if window.location.pathname == '/mobile'
  new Mobile()
if window.location.pathname == '/desktop'
  new Desktop()
