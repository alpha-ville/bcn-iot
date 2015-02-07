AbstractView = require '../AbstractView'
Circle       = require '../shapes/Circle'
Triangle     = require '../shapes/Triangle'
Square       = require '../shapes/Square'

class InteractiveCanvas extends AbstractView

    template : 'interactive-element'

    shapes: null

    init : ->
        PIXI.dontSayHello = true
        @w = window.innerWidth / window.devicePixelRatio
        @h = window.innerHeight / window.devicePixelRatio

        @shapes = []

        @stage = new PIXI.Stage()
        # @renderer = new PIXI.CanvasRenderer @w, @h,
        @renderer = PIXI.autoDetectRecommendedRenderer @w, @h,
            antialias : true
            transparent : true
            resolution : window.devicePixelRatio

        @$el.append @renderer.view

        @bindEvents()
        @addShapes()
        @update()
        null

    addShapes : =>
        max = 100

        objs = [Circle, Triangle, Square]
        range = _.shuffle(_.range(max))

        for i in range
            o = new objs[i%(objs.length)]
            o.move _.random(@w), _.random(@h)
            @shapes.push( o )
            @stage.addChild o.sprite

        middle = new Circle 120 / window.devicePixelRatio
        middle.move @w/2, @h/2
        @stage.addChild middle.sprite
        middle.animate()

        null

    update : =>
        for shape in @shapes
            shape.update()

            # bounds
            if ( shape.sprite.x > @w ) 
                shape.sprite.x = @w
                shape.vel.x *= -1
            else if ( shape.sprite.x < 0 ) 
                shape.sprite.x = 0
                shape.vel.x *= -1

            if ( shape.sprite.y > @h )
                shape.sprite.y = @h
                shape.vel.y *= -1
            else if ( shape.sprite.y < 0 )
                shape.sprite.y = 0
                shape.vel.y *= -1

        @render()
        requestAnimFrame @update
        null

    render : =>
        @renderer.render @stage
        null

    bindEvents : =>
        @B().appView.on @B().appView.EVENT_UPDATE_DIMENSIONS, @setDims
        null

    setDims : (renderer=false)=>
        return unless @renderer
        @w = window.innerWidth / window.devicePixelRatio
        @h = window.innerHeight / window.devicePixelRatio

        @$el.css
            'max-height' : @h
            'overflow' : 'hidden'

        @renderer.resize @w, @h
        null


module.exports = InteractiveCanvas
