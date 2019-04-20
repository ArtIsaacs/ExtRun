$ = require 'jquery'
gsap = require 'gsap'
mathjs = require 'mathjs'
PIXI = require 'pixi.js'
ExDino = require './elements/ExDino'
Rect = require './elements/Rect'
BgImageBonita = './scripts/assets/bottombonito2.png'
BgCieloBonito = './scripts/assets/cielobonito.png'
BgVolcanBonito = './scripts/assets/intro4.png'
BgNubesBonito = './scripts/assets/intro6.png'
BgBosqueBonitoBh = './scripts/assets/intro5.png'
BgBosqueBonitoFr = './scripts/assets/intro7.png'
Terrence = './scripts/assets/Terrence2.jpg'
BgInstrucciones = './scripts/assets/boton1.png'
Backgrounds = require './elements/backgroundDesktop'
Instrucciones = require './elements/Instrucciones'
DinoData = 'http://localhost:3000/scripts/assets/sprites.json'
ShadowData = 'http://localhost:3000/scripts/assets/sombra.json'
EnemyData = 'http://localhost:3000/scripts/assets/enemyjson.json'
Obstacles = require './elements/Obstacles'
Shadow = require './elements/Shadows'

class DesktopApp extends PIXI.Application
  animation:true
  animationNodes:[]
  obstaculos: []
  pause: false
  score: 0
  instrucciones1: 0
  instrucciones2: 0
  instrucciones3: 0

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
    @buildBackgrounds()
    @dino = new ExDino(@, @sheet.spritesheet)
    @sombras = new Shadow(@, @sheet2.spritesheet)
    @dino.width = 351
    @dino.height = 162
    @buildObstacles()
    @animate()
    @buildText()
    @buildInstrucciones()
    @movimiento()

  buildBackgrounds: () =>
    @bgCieloBonito = new Backgrounds(BgCieloBonito)
    @bgCieloBonito.width = 2100
    @bgCieloBonito.height = 780
    @stage.addChild(@bgCieloBonito)
    
    @bgCieloBonito2 = new Backgrounds(BgCieloBonito)
    @bgCieloBonito2.x = 2100
    @bgCieloBonito2.width = 2100
    @bgCieloBonito2.height = 780
    @stage.addChild(@bgCieloBonito2)

    @bgVolcan = new Backgrounds(BgVolcanBonito)
    @bgVolcan.x = 0
    @bgVolcan.y = 140
    @bgVolcan.height = 540
    @bgVolcan.width = 1920
    @stage.addChild(@bgVolcan)

    @bgNubes = new Backgrounds(BgNubesBonito)
    @bgNubes.width = 1610
    @bgNubes.height = 250
    @stage.addChild(@bgNubes)
    
    @bgNubes2 = new Backgrounds(BgNubesBonito)
    @bgNubes2.width = 1610
    @bgNubes2.height = 250
    @bgNubes2.x = 1610
    @stage.addChild(@bgNubes2)

    @bgForestBehind = new Backgrounds(BgBosqueBonitoBh)
    @bgForestBehind.width = 1920
    @bgForestBehind.height = 342
    @bgForestBehind.y = 300
    @stage.addChild(@bgForestBehind)
    
    @bgForestBehind2 = new Backgrounds(BgBosqueBonitoBh)
    @bgForestBehind2.width = 1920
    @bgForestBehind2.height = 342
    @bgForestBehind2.y = 300
    @bgForestBehind2.x = 1920
    @stage.addChild(@bgForestBehind2)

    @bgForestFront = new Backgrounds(BgBosqueBonitoFr)
    @bgForestFront.y = 380
    @bgForestFront.width = 2100
    @bgForestFront.height = 240
    @stage.addChild(@bgForestFront)
    
    @bgForestFront2 = new Backgrounds(BgBosqueBonitoFr)
    @bgForestFront2.y = 380
    @bgForestFront2.width = 2100
    @bgForestFront2.height = 240
    @bgForestFront2.x = 2100
    @stage.addChild(@bgForestFront2)

    @bgPath = new Backgrounds(BgImageBonita)
    @bgPath.y = 440
    @bgPath.height = 318
    @bgPath.width = 2880
    @stage.addChild(@bgPath)
    
    @bgPath2 = new Backgrounds(BgImageBonita)
    @bgPath2.y = 440
    @bgPath2.height = 318
    @bgPath2.width = 2880
    @bgPath2.x = 2880
    @stage.addChild(@bgPath2)

  buildObstacles: () =>
    setInterval =>
      type = mathjs.randomInt(1,3)
      @obstacles = new Obstacles(type, @)
      @stage.addChild(@obstacles)
      @addAnimationNodes(@obstacles)
      @obstaculos.push(@obstacles)
    , 6000
    #if type == 1 && @instrucciones1 < 2
    #  @bgInstrucciones.alpha = 1
    #  @terrence.alpha = 1
    #  @txt2.alpha = 1
    #  @txt2.text = "Este obstaculo es un tronco. \n Para evitar chocar debes saltar con tu celular."
    #  @instrucciones1 = @instrucciones1 + 1
    #
    #if type == 1 && @instrucciones2 < 2
    #  @bgInstrucciones.alpha = 1
    #  @terrence.alpha = 1
    #  @txt2.alpha = 1
    #  @txt2.text = "Este obstaculo es una roca. \n Para evitar chocar debes agacharte con tu celular."
    #  @instrucciones2 = @instrucciones2 + 1
    #
    #if type == 1 && @instrucciones3 < 2
    #  @bgInstrucciones.alpha = 1
    #  @terrence.alpha = 1
    #  @txt2.alpha = 1
    #  @txt2.text = "Este obstaculo es un arbol. \n Para evitar chocar debes agacharte con tu celular."
    #  @instrucciones3 = @instrucciones3 + 1

  buildText: () ->
    textStyle = new PIXI.TextStyle({
      fontFamily: 'Arial'
      fill: 'white'
      fontSize: 26
    })
    @txt = new PIXI.Text("Score \n #{@score}", textStyle)
    @txt.x = window.innerWidth / 2 - @txt.width / 2
    @txt.y = 20
    rect = new Rect(100, 100)
    @stage.addChild(rect)
    @stage.addChild(@txt)

  buildInstrucciones: () =>
    @bgInstrucciones = new Instrucciones(BgInstrucciones)
    @bgInstrucciones.alpha = 0
    @stage.addChild(@bgInstrucciones)
    
    @terrence = new Instrucciones(Terrence)
    @terrence.width = 200
    @terrence.height = 200
    @terrence.x = @bgInstrucciones.x + 70
    @terrence.y = @bgInstrucciones.y + 30
    @terrence.alpha = 0
    @stage.addChild(@terrence)
    
    textStyle = new PIXI.TextStyle({
      fontFamily: 'Arial'
      fill: 'white'
      fontSize: 26
    })
    @txt2 = new PIXI.Text(null, textStyle)
    @txt2.x = @bgInstrucciones.x + 300
    @txt2.y = @bgInstrucciones.y + 40
    @txt2.alpha = 0
    @stage.addChild(@txt2)

  movimiento: (evt) =>
    return if @pause
    @obj = JSON.parse(evt)
    moveY = @obj.y
    moveX = @obj.x
    moveZ = @obj.z

    @bgCieloBonito.x -= 2
    @bgCieloBonito2.x -= 2
    
    @bgNubes.x -= 3.5
    @bgNubes2.x -= 3.5
    
    @bgForestBehind.x -= 4
    @bgForestBehind2.x -= 4
    
    @bgForestFront.x -= 4.5
    @bgForestFront2.x -= 4.5
    
    @bgPath.x -= 5
    @bgPath2.x -= 5
    
    if @bgCieloBonito.x is 0
      @bgCieloBonito2.x = 2100
    if @bgCieloBonito2.x is 0
      @bgCieloBonito.x = 2100
    
    if @bgNubes.x is 0
      @bgNubes2.x = 1610
    if @bgNubes2.x is 0
      @bgNubes.x = 1610
    
    if @bgForestBehind.x is 0
      @bgForestBehind2.x = 1920
    if @bgForestBehind2.x is 0
      @bgForestBehind.x = 1920
    
    if @bgForestFront.x is 0
      @bgForestFront2.x = 2100
    if @bgForestFront2.x is 0
      @bgForestFront.x = 2100

    if @bgPath.x is 0
      @bgPath2.x = 2880
    if @bgPath2.x is 0
      @bgPath.x = 2880
    
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

    @score = @score += 1
    @txt.text = "Score \n #{@score}"

  colisiones: (obj1, arr) =>
    for rect in arr
      if (obj1.x < rect.x + rect.width && obj1.x + obj1.width > rect.x)
          if (obj1.y < rect.y + rect.height && obj1.y + obj1.height > rect.y)
            if obj1.isJumping == false
              console.log "memori xdxd"
              obj1.isDead = true
              obj1.dead()
              @sombras.isDead = true
              @sombras.dead()

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
