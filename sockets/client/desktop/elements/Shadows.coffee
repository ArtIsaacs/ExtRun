gsap = require 'gsap'

class Shadows 

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
    @y = 654
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

    @animations['SombraIdle'].play()
    @animations['SombraIdle'].alpha = 0.6
    @animations['SombraIdle'].active = true
    @animations['SombraJump'].loop = false
    @animations['SombraDead'].loop = false
    
  changeValue: (newValue) =>
    for key, value of @animations
      if value.active == true
        value.gotoAndStop(0)
        value.alpha = 0
        value.active = false

    @animations[newValue].x = @x
    @animations[newValue].y = @y
    @animations[newValue].alpha = 0.6
    @animations[newValue].active = true
    @animations[newValue].play()

  run: () =>
    if @isDead == false
        @changeValue('SombraRun')
  
  dead: () =>
    @changeValue('SombraDead')
  
  jump: (moveY) =>
    if @isDead == false
        @isJumping = true
        @changeValue('SombraJump')
        gsap.TweenMax.to @animations['SombraJump'], 0.7,
          x: 160
          onComplete: () =>
            @onGround()

  onGround: () =>
    gsap.TweenMax.to @animations['SombraJump'], 0.7,
      x: 150
      onComplete: () =>
        @isJumping = false
        @run()

module.exports = Shadows