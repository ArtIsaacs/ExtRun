class backgroundDesktop extends PIXI.Sprite.fromImage
    constructor: (img) ->
        super(img)
        @width = 800
        @height = 300
        @x = window.innerWidth / 2 - @width / 2
        @y = 100

module.exports = backgroundDesktop