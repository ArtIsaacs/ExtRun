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
ShadowData = 'http://localhost:3000/scripts/assets/sombra.json'
EnemyData = 'http://localhost:3000/scripts/assets/enemyjson.json'
Obstacles = require './elements/Obstacles'
Shadow = require './elements/Shadows'

class DesktopApp extends PIXI.Application
  animation:true
  animationNodes:[]
  obstaculos: []

  constructor: (config, socket) ->
    super(config)
    @socket = socket
    @socket.on 'send:accelerometer', @movimiento
    PIXI.loader.add(DinoData).add(ShadowData).add(EnemyData).load(@buildApp)
    
  getResponse: (r) =>
    @data = r
    PIXI.loader.add(DinoData).load(@buildApp)
  
  buildApp:=>
    @sheet = PIXI.loader.resources["http://localhost:3000/scripts/assets/sprites.json"]
    @sheet2 = PIXI.loader.resources["http://localhost:3000/scripts/assets/sombra.json"]
    @sheet3 = PIXI.loader.resources["http://localhost:3000/scripts/assets/enemyjson.json"]
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
    @sombras = new Shadow(@, @sheet2.spritesheet)
    @dino.width = 351
    @dino.height = 162
    @buildObstacles()
    @animate()

  buildObstacles: () =>
    setInterval =>
      type = mathjs.randomInt(1,3)
      @obstacles = new Obstacles(type, @)
      @stage.addChild(@obstacles)
      @addAnimationNodes(@obstacles)
      @obstaculos.push(@obstacles)
    , 5000
  
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
      @sombras.isRunning = true
    else 
      @dino.isRunning = false
      @sombras.isRunning = false
    
    if moveY >= 30 && @dino.isJumping == false && @dino.isRunning == false
      @dino.jump()
        
    if moveY >= 30 && @sombras.isJumping == false && @sombras.isRunning == false
      @sombras.jump()

  colisiones: (obj1, arr) ->
    for rect in arr
      if (obj1.x < rect.x + rect.width && obj1.x + obj1.width > rect.x)
          if (obj1.y < rect.y + rect.height && obj1.y + obj1.height > rect.y)
            if obj1.isJumping == false
              console.log 'muerto'
          #obj1.isDead = true

  garbageCollector: (item) =>
    animationChild = @animationNodes.indexOf(item)
    if (animationChild > -1)
      @animationNodes.splice(animationChild, 1)
    stageChild = @stage.children.indexOf(item)
    if (stageChild > -1)
      @stage.children.splice(stageChild, 1)

  addAnimationNodes:(child)=>
    @animationNodes.push child
    null

  animate:=>
    @ticker.add ()=>
      @colisiones(@dino, @obstaculos)
      for n in @animationNodes
        n.animate?()

module.exports = DesktopApp
