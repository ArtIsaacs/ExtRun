class Rect extends PIXI.Graphics
    constructor: (width, height) ->
        super()
        @width = width
        @height = height
        @color = 0xD67B1E

        @beginFill(@color)
        @drawRect(0, 0, 140, 70)
        @x = window.innerWidth / 2 - 75
        @y = 20
        @alpha = 0.7
        @endFill()


module.exports = Rect