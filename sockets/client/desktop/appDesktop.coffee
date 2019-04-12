$ = require 'jquery'
mathjs = require 'mathjs'
PIXI = require 'pixi.js'
ExDino = require './elements/ExDino'
BgImageBonita = './scripts/assets/bottombonito2.png'
BgCieloBonito = './scripts/assets/cielobonito.png'
BgVolcanBonito = './scripts/assets/fondo.png'
BackgroundFront = require './elements/backgroundDesktop'
BackgroundBehind = require './elements/backgroundDesktopBehind'
Cielo = require './elements/cieloDesktop'
DinoData = 'http://localhost:3000/scripts/assets/sprites.json'

class DesktopApp extends PIXI.Application
  animation:true
  animationNodes:[]

  constructor: (config, socket) ->
    super(config)
    #@buildApp()
    @socket = socket
    @socket.on 'send:accelerometer', @movimiento
    # $.getJSON('http://localhost:3000/scripts/assets/sprites.json', @getResponse)
    PIXI.loader.add(DinoData).load(@buildApp)
    @movimiento()
    
  getResponse: (r) =>
    @data = r
    PIXI.loader.add(DinoData).load(@buildApp)
  
  buildApp:=>
    @sheet = PIXI.loader.resources["http://localhost:3000/scripts/assets/sprites.json"]
    $('body').html @view
    @bgCieloBonito = new Cielo(BgCieloBonito)
    @bgVolcan = new BackgroundBehind(BgVolcanBonito)
    @bgImage = new BackgroundFront(BgImageBonita)
    @bgImage2 = new BackgroundFront(BgImageBonita)
    @bgImage2.x = 2880
    @stage.addChild(@bgCieloBonito)
    @stage.addChild(@bgVolcan)
    @stage.addChild(@bgImage)
    @stage.addChild(@bgImage2)
    @dino = new ExDino(@, @sheet.spritesheet)

  movimiento: (evt) =>
    @obj = JSON.parse(evt)
    moveY = @obj.y
    moveX = @obj.x
    moveZ = @obj.z

    @bgImage.x -= 5
    @bgImage2.x -= 5

    if @bgImage.x is 0
      @bgImage2.x = 2880
    if @bgImage2.x is 0
      @bgImage.x = 2880
    
    if moveX >= 9 || moveX <= -9
      @dino.isRunning = true
    else 
      @dino.isRunning = false
    
    if moveY >= 30 && @dino.isJumping == false && @dino.isRunning == false
      @dino.jump()

  addAnimationNodes:(child)=>
    @animationNodes.push child
    null

  animate:=>
    @ticker.add ()=>
      for n in @animationNodes
        n.animate?()

module.exports = DesktopApp
