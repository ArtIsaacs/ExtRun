gsap = require 'gsap'

class ExDino extends PIXI.Graphics

  velY: 0
  velX: 0
  #base: 580
  #x: 150
  #y: 580
  #width: 351
  #height: 162
  #animationSpeed: 0.3
  isJumping: false
  isRunning: false
  animations: {}
  
  constructor: (app, data) ->
    super()
    @app = app
    @data = data
    @base = 580
    @x = 150
    @y = 580
    @width = 351
    @height = 162
    @animationSpeed = 0.3
    @buildAnimations()
    

  buildAnimations: () =>
    for animation, frames of @data.animations
      @animations[animation] = new PIXI.extras.AnimatedSprite(frames)
      @animations[animation].x = @x
      @animations[animation].y = @y
      @animations[animation].alpha = 0
      @animations[animation].scale.x = 0.5
      @animations[animation].scale.y = 0.5
      @animations[animation].animationSpeed = @animationSpeed
      @animations[animation].active = false 
      @app.stage.addChild(@animations[animation])

    @animations['Idle'].play()
    console.log @animations['Idle']
    console.log @app.stage.children
    @animations['Idle'].alpha = 1
    @animations['Idle'].active = true
    @animations['Jump'].loop = false
    
    #@Dino = new PIXI.extras.AnimatedSprite(@data.animations['Idle'])
    #@Dino.y = 580
    #@Dino.x = 150
    #@Dino.width = 351
    #@Dino.height = 162
    #@Dino. = 0.3
    #@Dino.play()
    #@app.stage.addChild(@Dino)

  changeValue: (newValue) =>
    for key, value of @animations
      if value.active == true
        console.log 'new active', key
        value.gotoAndStop(0)
        value.alpha = 0
        value.active = false

    @animations[newValue].x = @x
    @animations[newValue].y = @y
    @animations[newValue].alpha = 1
    @animations[newValue].active = true
    @animations[newValue].play()


  run: () =>
    @changeValue('Run')
  
  jump: (moveY) =>
    @isJumping = true
    @changeValue('Jump')
    gsap.TweenMax.to @animations['Jump'], 0.5,
      y: 500
      onComplete: () =>
        @onGround()


  onGround: () =>
    gsap.TweenMax.to @animations['Jump'], 0.5,
      y: @base
      onComplete: () =>
        @isJumping = false
        @run()

module.exports = ExDino