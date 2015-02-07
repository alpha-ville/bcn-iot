AbstractView = require '../AbstractView'
Circle       = require '../shapes/Circle'
Triangle     = require '../shapes/Triangle'
Square       = require '../shapes/Square'
MiddleCircle = require '../shapes/MiddleCircle'

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

        max = 100

        objs = [Circle, Triangle, Square]
        range = _.shuffle(_.range(max))

        for i in range
            o = new objs[i%(objs.length)]
            o.move _.random(@w), _.random(@h)
            @stage.addChild o.sprite

        middle = new MiddleCircle
        middle.move @w/2, @h/2
        @stage.addChild middle.sprite

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
