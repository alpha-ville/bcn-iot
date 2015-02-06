AbstractView = require '../AbstractView'
Circle       = require '../shapes/Circle'
Triangle     = require '../shapes/Triangle'
Square       = require '../shapes/Square'

class InteractiveCanvas extends AbstractView

    template : 'interactive-element'

    init : ->
        PIXI.dontSayHello = true
        @w = window.innerWidth
        @h = window.innerHeight

        @stage = new PIXI.Stage()
        # @renderer = new PIXI.CanvasRenderer @w, @h,
        @renderer = PIXI.autoDetectRecommendedRenderer @w, @h,
            antialias : true
            transparent : true
            # resolution : window.devicePixelRatio

        @$el.append @renderer.view

        @bindEvents()
        @addShapes()
        @update()
        null

    addShapes : =>
        a = new Circle 30, 30
        t = new Triangle 30, 30
        s = new Square 30, 30

        @stage.addChild a.sprite
        @stage.addChild t.sprite
        @stage.addChild s.sprite

        a.move 300, 200
        t.move 150, 300
        s.move 200, 400

        null

    update : =>
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
        @w = window.innerWidth
        @h = window.innerHeight

        @$el.css
            'max-height' : @h
            'overflow' : 'hidden'

        @renderer.resize @w, @h
        null


module.exports = InteractiveCanvas
