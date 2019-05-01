class ObstaclesAnimations 

  animations: {}
  
  constructor: (type, app, data) ->
    @type = type
    @app = app
    @data = data
    @base = 520
    @x = window.innerWidth + 100
    @y = 520
    @animationSpeed = 0.3
    @buildAnimations()
    @build()
    @animate()
    
  buildAnimations: () =>
    for animation, frames of @data.animations
      @animations[animation] = new PIXI.extras.AnimatedSprite(frames)
      @animations[animation].x = @x
      @animations[animation].y = @y
      @animations[animation].alpha = 0
      @animations[animation].scale.x = 0.4
      @animations[animation].scale.y = 0.4
      @animations[animation].animationSpeed = @animationSpeed
      @animations[animation].active = false 
      @app.stage.addChild(@animations[animation])

    @animations['crack'].loop = false
    @animations['log'].loop = false
    @animations['tree'].loop = false
    

  changeValue: (newValue) =>
    for key, value of @animations
      if value.active == true
        value.gotoAndStop(0)
        value.alpha = 0
        value.active = false

    @animations[newValue].x = @x
    @animations[newValue].y = @y
    @animations[newValue].alpha = 1
    @animations[newValue].active = true
    @animations[newValue].play()

    @actualBoss = @animations[newValue]
    @app.ticker.add ()=> @animate()

  build: () =>
    console.log @type
    switch @type
        when 1
            @changeValue('log')
        when 2
            @changeValue('crack')
            @animations.y = @y + 30

  animate: () =>
    return if @app.pause == true
    @app.colisiones(@app.dino, @actualBoss)
    if @actualBoss.x <= 0
        @app.garbageCollector(@)
    @actualBoss.x -= 9

module.exports = ObstaclesAnimations
