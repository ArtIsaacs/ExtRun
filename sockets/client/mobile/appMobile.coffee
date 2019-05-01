PIXI = require 'pixi.js'
$ = require 'jquery'
video = './scripts/assets/black.mp4'
NoSleep = require 'nosleep.js'

class MobileApp extends PIXI.Application
  animation:true
  animationNodes:[]

  constructor: (config, socket) ->
    super(config)
    @socket = socket
    window.onLoad = @onLoad()
  
  onLoad: () =>
    console.log 1
    window.addEventListener 'devicemotion', @onDeviceMotion
    $('body').html @view
    nosleep = new NoSleep()
    nosleep.enable()

  
  onDeviceMotion: (evt) =>
    obj = {
      x:evt.accelerationIncludingGravity.x
      y:evt.accelerationIncludingGravity.y
      z:evt.accelerationIncludingGravity.z
    }
    @socket.emit "send:accelerometer", JSON.stringify(obj, null, 2)

  addAnimationNodes:(child)=>
    @animationNodes.push child
    null

  animate:=>
    @ticker.add ()=>
      for n in @animationNodes
        n.animate?()
module.exports = MobileApp
