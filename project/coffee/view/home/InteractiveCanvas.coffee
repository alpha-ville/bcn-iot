AbstractView = require '../AbstractView'
Circle       = require '../shapes/Circle'
Triangle     = require '../shapes/Triangle'
Square       = require '../shapes/Square'

class InteractiveCanvas extends AbstractView

    template : 'interactive-element'
    shapes   : null

    init : =>

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

        objs =
            "circle"   : Circle
            "triangle" : Triangle
            "square"   : Square

        @B().objects.each (data) =>
            o = new objs[data.get('data_type').toLowerCase()](data)
            o.move _.random(@w), _.random(@h)
            @shapes.push( o )
            @stage.addChild o.sprite

        middle = new Circle null, 120 / window.devicePixelRatio
        middle.move @w/2, @h/2
        @stage.addChild middle.sprite
        middle.animate()

        null

    update : =>
        for shape in @shapes
            shape.update()

            # behavior on bounds
            if ( shape.sprite.x > @w + shape.w )
                shape.sprite.x = 0 - shape.w
                shape.sprite.y = Math.random() * @h
            else if ( shape.sprite.x < 0 - shape.w )
                shape.sprite.x = @w + shape.w
                shape.sprite.y = Math.random() * @h

            if ( shape.sprite.y > @h + shape.h )
                shape.sprite.y = 0 - shape.h
                shape.sprite.x = Math.random() * @w
            else if ( shape.sprite.y < 0 - shape.h )
                shape.sprite.y = @h + shape.h
                shape.sprite.x = Math.random() * @w

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
