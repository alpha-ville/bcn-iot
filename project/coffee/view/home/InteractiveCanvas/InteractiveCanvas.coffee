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


    linesObj: null
    linesAlphaScale: 0

    scene: null

    deltaTime: 0
    lastTime: Date.now()


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

        @bindEvents()

        @addLines()
        
        @addShapes()
        @addGardenNodes()

        @update()
        null

    addGardenNodes: ->
        for i in [ 0 ... 100 ]
            node = new NodeShape( null, 1.5, @scene )
            node.move _.random(@w), _.random(@h)
            node.behavior = 'basic'
            @gardenNodes.push( node )
            @scene.addChild( node.sprite )

        null

    addShapes : =>
        @centralButton = new CentralButton null, 120, @scene
        @centralButton.move @w/2, @h/2
        @scene.addChild @centralButton.sprite
        # @centralButton.animate()

        objs =
            "circle"   : Circle
            "triangle" : Triangle
            "square"   : Square

        # circles
        @B().categories.each (data) =>
            # console.log data
            size = _.random(20, 60)
            object = new Circle(data, size, @scene)
            object.move _.random(@w), _.random(@h)
            @shapes.push( object )
            @circles.push( object )
            @scene.addChild object.sprite

         # triangles
        @B().purposes.each (data) =>
            # console.log data
            size = _.random(20, 60)
            object = new Triangle(data, size, @scene)
            object.move _.random(@w), _.random(@h)
            @shapes.push( object )
            @triangles.push( object )
            @scene.addChild object.sprite

         # triangles
        @B().dataSources.each (data) =>
            # console.log data
            size = _.random(20, 60)
            object = new Square(data, size, @scene)
            object.move _.random(@w), _.random(@h)
            @shapes.push( object )
            @squares.push( object )
            @scene.addChild object.sprite
        


        null

    update : =>
        @deltaTime = Date.now() - @lastTime
        @lastTime = Date.now()

        @updateLines()

        for node in @gardenNodes
            node.update()

            # behavior on bounds
            if ( node.pos[0] > @w + node.w )
                node.vel[0] *= -1
            else if ( node.pos[0] < 0 )
                node.vel[0] *= -1

            if ( node.pos[1] > @h + node.h )
                node.vel[1] *= -1
            else if ( node.pos[1] < 0 )
                node.vel[1] *= -1

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

        for node in @gardenNodes
            
            for node2 in @gardenNodes

                dist = NumUtil.distanceBetweenPoints node.sprite.position, node2.sprite.position

                if dist < 100
                    @linesObj.lineStyle( 1, node2.color, NumUtil.map(dist, 0, 100, .2, 0) )
                    @linesObj.moveTo( node2.sprite.position.x, node2.sprite.position.y );
                    @linesObj.lineTo( node.sprite.x , node.sprite.y);
                
         
        null

    render : =>
        @scene.render()

        null

    bindEvents : =>
        #temporary
        window.addEventListener('keyup', @onKeyup)

        @B().appView.on @B().appView.EVENT_UPDATE_DIMENSIONS, @setDims

        Backbone.Events.on( 'circleSelected', @onCircleSelected )
        Backbone.Events.on( 'circleUnselected', @onCircleUnselected )
        Backbone.Events.on( 'shapeSelected', @onShapeSelected )
        Backbone.Events.on( 'shapeUnselected', @onShapeUnselected )

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
        null


    onKeyup: ( evt ) =>
        if evt.keyCode != 32 then return

        null


    onCircleSelected: ( circle ) =>
        for c in @circles
            if c.id != circle.id then c.disable()

        circle.goToCenterAndScaleUp()

        for triangle in @triangles
            triangle.canOrbit = true
            triangle.fadeTo( .9, 1.3 + Math.random() )

        for square in @squares
            square.canOrbit = true
            square.fadeTo( .9, 1.3 + Math.random() )

        null


    onCircleUnselected: ( circle ) =>
        @centralButton.stop()
        
        for c in @circles
            if c.id != circle.id then c.undisable()

        circle.goBackAndScaleDown()

        for triangle in @triangles
            triangle.canOrbit = false
            triangle.behavior = 'target'
            triangle.fadeTo( .3, Math.random() )

        for square in @squares
            square.canOrbit = false
            square.behavior = 'target'
            square.fadeTo( .3, Math.random() )

        null


    onShapeSelected: ( shape ) =>
        @selectedShapes.push( shape )

        @centralButton.animate()

        null


    onShapeUnselected: ( shape ) =>

        null

module.exports = InteractiveCanvas
