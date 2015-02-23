AbstractView    = require '../../AbstractView'
Scene           = require('./Scene.coffee');
CentralButton   = require('./shapes/CentralButton.coffee');
Circle          = require './shapes/Circle'
Triangle        = require './shapes/Triangle'
Square          = require('./shapes/Square.coffee');
NumUtil         = require('../../../utils/NumUtil.coffee');
NodeShape       = require('./shapes/NodeShape.coffee');
 
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


    init : =>

        PIXI.dontSayHello = true
        @w = window.innerWidth
        @h = window.innerHeight

        @scene = new Scene({
            container: @$el[0]
        })

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

        # @addGardenNodes()

        @update()

        null


    addDecorations: ->

        @smallShapes = []

        @smallCircles = []
        for i in [ 0 ... 50 ]
            size = _.random( 8, 25 )
            circle = new Circle( null, size, @scene, .2 )
            circle.move _.random(@w), _.random(@h)
            circle.behavior = 'basic'
            circle.vel[0] *= .3
            circle.vel[1] *= .3
            @smallCircles.push( circle )
            @scene.addChild( circle.sprite )

        @smallTriangles = []
        for i in [ 0 ... 100 ]
            size = _.random( 8, 25 )
            triangle = new Triangle( null, size, @scene, .01 )
            triangle.move _.random(@w), _.random(@h)
            triangle.behavior = 'basic'
            triangle.vel[0] *= .3
            triangle.vel[1] *= .3
            @smallTriangles.push( triangle )
            @smallShapes.push( triangle )  
            @scene.addChild( triangle.sprite )

        @smallSquares = []
        for i in [ 0 ... 100 ]
            size = _.random( 8, 25 )
            square = new Square( null, size, @scene, .01 )
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

        size = 120

        # circles
        for i in [ 0 ... 4 ]
            data = @B().categories.models[i]
            object = new Circle(data, size, @scene)
            object.sprite.alpha = .8
            # object.animate()
            object.move _.random(@w), _.random(@h)
            @shapes.push( object )
            @circles.push( object )
            @scene.addChild object.sprite

        for j in [ 0 ... @B().purposes.models.length ]
            data = @B().purposes.models[j]
            object = new Triangle(data, size, @scene)
            object.sprite.alpha = .8
            # object.animate()
            object.move _.random(@w), _.random(@h)
            @shapes.push( object )
            @triangles.push( object )
            @triangleAndSquares.push(object)
            @scene.addChild object.sprite

        for k in [ 0 ... @B().dataSources.models.length ]
            data = @B().dataSources.models[k]
            object = new Square(data, size, @scene)
            object.sprite.alpha = .8
            # object.animate()
            object.move _.random(@w), _.random(@h)
            @shapes.push( object )
            @squares.push( object )
            @triangleAndSquares.push(object)
            @scene.addChild object.sprite

        #  # triangles
        # @B().purposes.each (data) =>
        #     object = new Triangle(data, size, @scene)
        #     object.move _.random(@w), _.random(@h)
        #     object.sprite.alpha = .7
        #     @shapes.push( object )
        #     @triangles.push( object )
        #     @scene.addChild object.sprite

         # square
        # @B().dataSources.each (data) =>
        #     object = new Square(data, size, @scene)
        #     object.move _.random(@w), _.random(@h)
        #     object.sprite.alpha = .8
        #     @shapes.push( object )
        #     @squares.push( object )
        #     @scene.addChild object.sprite
        


        null

    update : =>
        @deltaTime = Date.now() - @lastTime
        @lastTime = Date.now()

        @updateLines()

        # for node in @gardenNodes
        #     node.update()

        for c in @smallCircles
            c.update()

        for t in @smallTriangles
            t.update()

        for s in @smallSquares
            s.update()

        for shape in @shapes
            shape.update()


            
        @centralButton.update()
        
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
            dist = NumUtil.distanceBetweenPoints nearestCircle.sprite.position, shape.sprite.position
            
            if dist < 400 and nearestCircle
                @linesObj.lineStyle( 1, shape.color, NumUtil.map(dist, 0, 400, .8, 0) )
                @linesObj.moveTo( nearestCircle.sprite.position.x, nearestCircle.sprite.position.y );
                @linesObj.lineTo( shape.sprite.x , shape.sprite.y);
        
        for shape in @smallShapes

            nearestCircle = @getNearestCircle( shape, @smallCircles, 0 )
            dist = NumUtil.distanceBetweenPoints nearestCircle.sprite.position, shape.sprite.position
            
            if dist < 100 and nearestCircle
                @linesObj.lineStyle( 1, shape.color, NumUtil.map(dist, 0, 100, .2, 0) )
                @linesObj.moveTo( nearestCircle.sprite.position.x, nearestCircle.sprite.position.y );
                @linesObj.lineTo( shape.sprite.x , shape.sprite.y);

         
        null


    getNearestCircle: ( shape, circles, constrainAlpha ) ->
        distance = 5000
        nearestCircle = null

        for circle in circles
            tempDist = NumUtil.distanceBetweenPoints circle.sprite.position, shape.sprite.position
            if tempDist < distance and shape.type != 'circle' and circle.sprite.alpha >= constrainAlpha
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
            if c.id != circle.id then c.disable()

        circle.goToCenterAndScaleUp()

        for triangle in @triangles
            triangle.canOrbit = true
            triangle.animate()
            # triangle.fadeTo( .9, 1.3 + Math.random() )

        for square in @squares
            square.canOrbit = true
            square.animate()
            # square.fadeTo( .9, 1.3 + Math.random() )

        null


    onCircleUnselected: ( circle ) =>
        @centralButton.stop()

        for c in @circles
            if c.id != circle.id then c.undisable()

        circle.goBackAndScaleDown()

        for shape in @shapes
            shape.canOrbit = false
            shape.isOrbiting = false
            shape.behavior = 'target'
            shape.fadeTo( .8, Math.random() )
            shape.spring = .07
            shape.sprite.scale.x = shape.sprite.scale.y = 1
            shape.attractionRadius = _.random(250, 270)


        @selectedShapes = []

        null


    onShapeSelected: ( shape ) =>
        @selectedShapes.push( shape )

        @centralButton.animate()

        if @selectedShapes.length == 10
            # @onCircleUnselected @currentSelectedCircle
            setTimeout =>
                for shape in @selectedShapes
                    shape.getAbsorbed()
            , 700
            


        null


    onShapeUnselected: ( shape ) =>

        null


    onShapeGotAbsorbed: ( shape ) =>
        TweenMax.to( @currentSelectedCircle.sprite.scale, .1, { x: @currentSelectedCircle.sprite.scale.x + .2, y: @currentSelectedCircle.sprite.scale.y + .2 } )

        @absorbedShapes.push( shape )

        if @absorbedShapes.length == 10
            @B().openOverlayContent 'door_locks'
            setTimeout =>
                @absorbedShapes = []
                @onCircleUnselected @currentSelectedCircle
            , 150
            

        null

module.exports = InteractiveCanvas
