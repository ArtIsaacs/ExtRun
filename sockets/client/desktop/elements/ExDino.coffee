gsap = require 'gsap'

class ExDino 

  velY: 0
  velX: 0
  isJumping: false
  isRunning: false
  isDead: false
  animations: {}
  
  constructor: (app, data) ->
    @app = app
    @data = data
    @base = 520
    @x = 150
    @y = 500
    @animationSpeed = 0.3
    @buildAnimations()
    

  buildAnimations: () =>
    for animation, frames of @data.animations
      @animations[animation] = new PIXI.extras.AnimatedSprite(frames)
      @animations[animation].x = @x
      @animations[animation].y = @y
      @animations[animation].alpha = 0
      @animations[animation].scale.x = 0.6
      @animations[animation].scale.y = 0.6
      @animations[animation].animationSpeed = @animationSpeed
      @animations[animation].active = false 
      @app.stage.addChild(@animations[animation])

    @animations['Run'].play()
    @animations['Run'].alpha = 1
    @animations['Run'].active = true
    @animations['Jump'].loop = false
    @animations['Dead'].loop = false
    

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


  run: () =>
    if @isDead == false
      @changeValue('Run')
    else
      @dead()
  
  dead: () =>
    @changeValue('Dead')
    #@app.pause = true
  
  jump: (moveY) =>
    if @isDead == false
      @isJumping = true
      @changeValue('Jump')
      gsap.TweenMax.to @animations['Jump'], 0.7,
        y: 350
        x: 200
        onComplete: () =>
          @onGround()
    else
      @dead()


  onGround: () =>
    gsap.TweenMax.to @animations['Jump'], 0.7,
      y: @base
      x: 150
      onComplete: () =>
        @isJumping = false
        @run()

module.exports = ExDino