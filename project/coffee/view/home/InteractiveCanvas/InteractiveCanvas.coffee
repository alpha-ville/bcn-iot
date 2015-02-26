AbstractView    = require '../../AbstractView'
Scene           = require('./Scene.coffee');
CentralButton   = require('./shapes/CentralButton.coffee');
Circle          = require './shapes/Circle'
Triangle        = require './shapes/Triangle'
Square          = require('./shapes/Square.coffee');
NumUtil         = require('../../../utils/NumUtil.coffee');
NodeShape       = require('./shapes/NodeShape.coffee');
HelpButton = require('./shapes/HelpButton.coffee');
HomeTootip = require('../../components/HomeTootip.coffee');

class InteractiveCanvas extends AbstractView

    template : 'interactive-element'

    shapes   : null
    selectedShapes: null

    circles : null
    triangles: null
    squares : null
    gardenNodes: null

    smallCircles: null
    smallTriangle: null
    smallSquares: null
    smallShapes: null


    linesObj: null
    linesAlphaScale: 0

    scene: null

    deltaTime: 0
    lastTime: Date.now()

    absorbedShapes: null
    openOverlayTimer: null

    tooltip: null


    init : =>
        PIXI.dontSayHello = true
        @w = window.innerWidth
        @h = window.innerHeight

        @scene = new Scene({
            container: @$el[0]
        })

        @initTooltip()

        @shapes = []
        @selectedShapes = []
        @circles = []
        @triangles = []
        @squares = []
        @gardenNodes = []
        @triangleAndSquares = []

        @absorbedShapes = []

        @bindEvents()



        @addLines()
        @addDecorations()

        @addShapes()

        @addHelpButton()

        # @addGardenNodes()

        @update()

        null


    initTooltip: ->
        @tooltip = new HomeTootip()

        @$el[0].appendChild @tooltip.el

        null


    addHelpButton: ->
        @helpButton = new HelpButton( null, 50, @scene )
        @helpButton.behavior = 'basic'
        @helpButton.move _.random(@w), _.random(@h)
        @scene.addChild( @helpButton.sprite )

        null


    addDecorations: ->

        @smallShapes = []

        @smallCircles = []
        for i in [ 0 ... 50 ]
            size = _.random( 8, 40 )
            # size = 500
            circle = new Circle( null, size, @scene, .2 )
            circle.move _.random(@w), _.random(@h)
            circle.behavior = 'basic'
            circle.vel[0] *= .3
            circle.vel[1] *= .3

            @smallCircles.push( circle )
            @scene.addChild( circle.sprite )

        @smallTriangles = []
        for i in [ 0 ... 100 ]
            size = _.random( 8, 40 )
            triangle = new Triangle( null, size, @scene, .001 )
            triangle.move _.random(@w), _.random(@h)
            triangle.behavior = 'basic'
            triangle.vel[0] *= .3
            triangle.vel[1] *= .3
            @smallTriangles.push( triangle )
            @smallShapes.push( triangle )
            @scene.addChild( triangle.sprite )

        @smallSquares = []
        for i in [ 0 ... 100 ]
            size = _.random( 8, 40 )
            square = new Square( null, size, @scene, .001 )
            square.move _.random(@w), _.random(@h)
            square.behavior = 'basic'
            square.vel[0] *= .3
            square.vel[1] *= .3
            @smallSquares.push( square )
            @smallShapes.push( square )
            @scene.addChild( square.sprite )

        null

    addGardenNodes: ->
        for i in [ 0 ... 100 ]
            size = _.random( 50, 200 )
            node = new NodeShape( null, size, @scene )
            node.move _.random(@w), _.random(@h)
            node.behavior = 'basic'
            @gardenNodes.push( node )
            @scene.addChild( node.sprite )

        null

    addShapes : =>
        @centralButton = new CentralButton null, 240, @scene
        @centralButton.move @w/2, @h/2
        @scene.addChild @centralButton.sprite
        # @centralButton.animate()

        objs =
            "circle"   : Circle
            "triangle" : Triangle
            "square"   : Square

        size = 100

        ###

        the filtered data for you
        @TODO william look at this

        ###

        param = (@B().getQueryVariable 'group') or 'home'
        filteredCategories = @B().categories.where group : param

        console.log @B()

        # circles
        for i in [ 0 ... filteredCategories.length ]
            data = filteredCategories[i]
            object = new Circle(data, size, @scene)
            object.sprite.alpha = .8
            object.move _.random(@w), _.random(@h)
            object.isPulsating = true
            object.vel[0] *= 1 +  Math.random()
            object.vel[1] *= 1 +  Math.random()
            @shapes.push( object )
            @circles.push( object )
            @scene.addChild object.sprite

        for j in [ 0 ... @B().purposes.models.length ]
            data = @B().purposes.models[j]
            object = new Triangle(data, size, @scene)
            object.sprite.alpha = .1
            object.move _.random(@w), _.random(@h)
            @shapes.push( object )
            @triangles.push( object )
            @triangleAndSquares.push(object)
            @scene.addChild object.sprite

        for k in [ 0 ... @B().dataSources.models.length ]
            data = @B().dataSources.models[k]
            object = new Square(data, size - 8, @scene)
            object.sprite.alpha = .1
            object.move _.random(@w), _.random(@h)
            @shapes.push( object )
            @squares.push( object )
            @triangleAndSquares.push(object)
            @scene.addChild object.sprite


        null


    update : =>
        @deltaTime = Date.now() - @lastTime
        @lastTime = Date.now()

        @updateLines()

        for c in @smallCircles
            c.update()

        for t in @smallTriangles
            t.update()

        for s in @smallSquares
            s.update()

        for shape in @shapes
            shape.update()

        @centralButton.update()
        @helpButton.update()

        @render()

        requestAnimFrame @update

        null

    addLines: =>
        @linesObj = new PIXI.Graphics()

        @scene.addChild @linesObj

        null

    updateLines: ->
        @linesObj.clear()

        for shape in @triangleAndSquares

            nearestCircle = @getNearestCircle( shape, @circles, .8 )

            if nearestCircle

                dist = NumUtil.distanceBetweenPoints nearestCircle.sprite.position, shape.sprite.position

                if dist < 400 and nearestCircle and shape.sprite.alpha > .1
                    if shape.isOrbiting then lineWidth = 2 else lineWidth = .4
                    @linesObj.lineStyle( lineWidth, 0x000000, NumUtil.map(dist, 0, 400, .8, 0) )
                    @linesObj.moveTo( nearestCircle.sprite.position.x, nearestCircle.sprite.position.y );
                    @linesObj.lineTo( shape.sprite.x , shape.sprite.y);

        for shape in @smallShapes

            nearestCircle = @getNearestCircle( shape, @smallCircles, 0 )
            dist = NumUtil.distanceBetweenPoints nearestCircle.sprite.position, shape.sprite.position

            if dist < 100 and nearestCircle
                @linesObj.lineStyle( .6, 0x000000, NumUtil.map(dist, 0, 100, .2, 0) )
                @linesObj.moveTo( nearestCircle.sprite.position.x, nearestCircle.sprite.position.y );
                @linesObj.lineTo( shape.sprite.x , shape.sprite.y);


        null


    getNearestCircle: ( shape, circles, constrainAlpha ) ->
        distance = 5000
        nearestCircle = null

        for circle in circles
            tempDist = NumUtil.distanceBetweenPoints circle.sprite.position, shape.sprite.position
            if tempDist < distance and shape.type != 'circle' and !circle.isDisable
                distance = tempDist
                nearestCircle = circle


        return nearestCircle


    render : =>
        @scene.render()

        null

    bindEvents : =>
        #temporary
        window.addEventListener('keyup', @onKeyup)
        window.addEventListener('resize', @onResize)

        @B().appView.on @B().appView.EVENT_UPDATE_DIMENSIONS, @setDims

        Backbone.Events.on( 'circleSelected', @onCircleSelected )
        Backbone.Events.on( 'circleUnselected', @onCircleUnselected )
        Backbone.Events.on( 'shapeSelected', @onShapeSelected )
        Backbone.Events.on( 'shapeUnselected', @onShapeUnselected )
        Backbone.Events.on( 'shapeGotAbsorbed', @onShapeGotAbsorbed )
        Backbone.Events.on( 'hideHomeTooltip', @tooltip.hide )
        Backbone.Events.on( 'showHomeTooltip', @tooltip.show )

        # @$window.on 'resize orientationchange', @onResize

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


    onResize: () =>
        @w = window.innerWidth
        @h = window.innerHeight

        @centralButton.move( @w / 2, @h / 2 )

        if @currentSelectedCircle
            @currentSelectedCircle.move( @w / 2, @h / 2 )

        @scene.resize()

        null


    onKeyup: ( evt ) =>
        if evt.keyCode != 32 then return

        null


    onCircleSelected: ( circle ) =>
        @currentSelectedCircle = circle

        for c in @circles
            c.isDisable = true
            c.isPulsating = false
            if c.id != circle.id then c.disable()

        @currentSelectedCircle.isDisable = false
        @currentSelectedCircle.goToCenterAndScaleUp()

        for shape in @triangleAndSquares
            shape.sprite.alpha = .1

        @activeShapes = []
        copySquares = @squares.slice()
        copyTriangles = @triangles.slice()

        rand1 = Math.floor Math.random() * copySquares.length
        rand2 = rand1
        rand2 = Math.floor Math.random() * copySquares.length while rand2 == rand1
        @activeShapes.push( copySquares[rand1] )
        @activeShapes.push( copySquares[rand2] )

        rand1 = Math.floor Math.random() * copyTriangles.length
        rand2 = rand1
        rand2 = Math.floor Math.random() * copyTriangles.length while rand2 == rand1
        @activeShapes.push( copyTriangles[rand1] )
        @activeShapes.push( copyTriangles[rand2] )



        for shape in @activeShapes
            if shape.type == 'triangle' then shape.fadeTo( .6 ) else shape.fadeTo( .8 )
            shape.isPulsating = true
            shape.canOrbit = true

        null


    onCircleUnselected: ( circle ) =>
        @centralButton.stop()

        for c in @circles
            c.isDisable = false
            c.isPulsating = true
            if c.id != circle.id then c.undisable()

        for shape in @activeShapes
            shape.isPulsating = false

        @activeShapes = []

        circle.goBackAndScaleDown()

        for shape in @shapes
            if shape.type == 'triangle' then shape.fadeTo( .1 ) else shape.fadeTo( .1 )
            shape.canOrbit = false
            shape.isOrbiting = false
            shape.behavior = 'basic'
            shape.spring = .007
            shape.vel = [ .5 * (( Math.random() * 2 ) - 1), .5 * (( Math.random() * 2 ) - 1) ]
            shape.sprite.scale.x = shape.sprite.scale.y = 1
            shape.attractionRadius = _.random(190, 210)
            if shape.type == 'circle'
                shape.vel[0] *= 1 +  Math.random()
                shape.vel[1] *= 1 +  Math.random()


        @selectedShapes = []


        null


    onShapeSelected: ( shape ) =>
        @selectedShapes.push( shape )

        shape.isPulsating = false
        shape.sprite.alpha = 1
        shape.sprite.scale.x = shape.sprite.scale.y = 1

        @centralButton.animate()

        if @selectedShapes.length == @activeShapes.length
            
            if @absorptionTimer then clearInterval( @absorptionTimer )

            @absorptionTimer = setTimeout =>
                for shape in @selectedShapes
                    shape.getAbsorbed()
            , 300



        null


    onShapeUnselected: ( shape ) =>

        null


    onShapeGotAbsorbed: ( shape ) =>
        TweenMax.to( @currentSelectedCircle.sprite.scale, .1, { x: @currentSelectedCircle.sprite.scale.x + .5, y: @currentSelectedCircle.sprite.scale.y + .5 } )

        @absorbedShapes.push( shape )

        if @absorbedShapes.length == @activeShapes.length
            @tooltip.hide()
            category = @currentSelectedCircle.config.get('category_name')
            @B().openOverlayContent 'door_locks'

            if @openOverlayTimer then clearInterval( @openOverlayTimer )

            @openOverlayTimer = setTimeout =>
                @absorbedShapes = []
                @onCircleUnselected @currentSelectedCircle
            , 300


        null

module.exports = InteractiveCanvas
