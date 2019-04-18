class Obstacles extends PIXI.Graphics
    
    constructor: (type, app) ->
        super()
        @type = type
        @app = app
        @build()


    build: () =>
        console.log @type
        switch @type
            when 1
                @beginFill(0xff0000)
                @drawRect(0, 0, 30, 30)
                @y = 620
                @x = 900
                @endFill()
            when 2
                @beginFill(0x00ff00)
                @drawRect(0, 0, 30, 30)
                @y = 620
                @x = 900
                @endFill()
            when 3
                @beginFill(0x0000ff)
                @drawRect(0, 0, 30, 30)
                @y = 620
                @x = 900
                @endFill()

    animate: () =>
        if @x <= 0
            @app.garbageCollector(@)
            console.log "estoy borrandolos"
        @x -= 5

module.exports = Obstacles