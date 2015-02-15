AbstractView    = require '../../AbstractView'
Scene           = require('./Scene.coffee');
Circle          = require './shapes/Circle'
Triangle        = require './shapes/Triangle'
Square          = require('./shapes/Square.coffee');
NumUtil         = require('../../../utils/NumUtil.coffee');
NodeShape       = require('./shapes/NodeShape.coffee');
 
class InteractiveCanvas extends AbstractView

    template : 'interactive-element'
    shapes   : null
    gardenNodes: null

    linesObj: null
    linesAlphaScale: 0

    scene: null

    deltaTime: 0
    lastTime: Date.now()


    init : =>

        PIXI.dontSayHello = true
        @w = window.innerWidth / window.devicePixelRatio
        @h = window.innerHeight / window.devicePixelRatio

        @scene = new Scene({
            container: @$el[0]
        })

        @shapes = []
        @gardenNodes = []

        @bindEvents()

        @addLines()
        @addGardenNodes()
        @addShapes()

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

        objs =
            "circle"   : Circle
            "triangle" : Triangle
            "square"   : Square

        @B().objects.each (data) =>
            size = _.random(10, 60)
            object = new objs[data.get('data_type').toLowerCase()](data, size, @scene)
            object.move _.random(@w), _.random(@h)
            @shapes.push( object )
            @scene.addChild object.sprite


        middle = new Circle null, 120, @scene
        middle.move @w/2, @h/2
        @scene.addChild middle.sprite
        middle.animate()


        null

    update : =>
        @deltaTime = Date.now() - @lastTime
        @lastTime = Date.now()

        @updateLines()

        for node in @gardenNodes
            node.update()

            #behavior on bounds
            if ( node.sprite.x > ( @w * window.devicePixelRatio ) + node.w )
                node.sprite.x = 0 - node.w
            else if ( node.sprite.x < 0 - node.w )
                node.sprite.x = ( @w * window.devicePixelRatio ) + node.w

            if ( node.sprite.y > ( @h * window.devicePixelRatio ) + node.h )
                node.sprite.y = 0 - node.h
            else if ( node.sprite.y < 0 - node.h )
                node.sprite.y = ( @h * window.devicePixelRatio ) + node.h

        for shape in @shapes
            shape.update()

            

        
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
                    @linesObj.lineStyle( 1, node2.color, NumUtil.map(dist, 0, 100, .3, 0) )
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

        # @$window.on 'resize orientationchange', @onResize

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


    onResize: () =>
        console.log @
        null


    onKeyup: ( evt ) =>
        if evt.keyCode != 32 then return

        null

module.exports = InteractiveCanvas
