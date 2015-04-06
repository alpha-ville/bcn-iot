AbstractView    = require '../../AbstractView'
Scene           = require './Scene'
CentralButton   = require './shapes/CentralButton'
Circle          = require './shapes/Circle'
Triangle        = require './shapes/Triangle'
Square          = require './shapes/Square'
NumUtil         = require '../../../utils/NumUtil'
NodeShape       = require './shapes/NodeShape'
HelpButton      = require './shapes/HelpButton'
HomeTootip      = require '../../components/HomeTootip'
Pointer         = require './Pointer'

class InteractiveCanvas extends AbstractView

    template         : 'interactive-element'

    pointer          : null

    shapes           : null
    selectedShapes   : null

    circles          : null
    triangles        : null
    squares          : null
    gardenNodes      : null

    smallCircles     : null
    smallTriangle    : null
    smallSquares     : null
    smallShapes      : null


    linesObj         : null
    linesAlphaScale  : 0

    scene            : null

    deltaTime        : 0
    lastTime         : Date.now()

    absorbedShapes   : null
    openOverlayTimer : null

    tooltip          : null

    step             : 0
    stepTimer        : null
    step2Timer       : null
    step1Timer       : null


    init : =>
        PIXI.dontSayHello = true
        @w = window.innerWidth
        @h = window.innerHeight

        @scene = new Scene container: @$el[0]

        @shapes             = []
        @selectedShapes     = []
        @circles            = []
        @triangles          = []
        @squares            = []
        @gardenNodes        = []
        @triangleAndSquares = []
        @activeShapes       = []
        @absorbedShapes     = []

        @addLines()
        @addDecorations()
        console.log @B().groupName
        if @B().groupName
            @addShapes()
            @addHelpButton()
            @addPointer()
            @initTooltip()
            @bindEvents()

        @update()

        null


    initTooltip: ->
        @tooltip = new HomeTootip()

        @$el[0].appendChild @tooltip.el

        @tooltip.setDefaultText( @groupName, @groupName )

        null


    addHelpButton: ->
        @helpButton = new HelpButton( null, 50, @scene )
        @helpButton.behavior = 'basic'
        @helpButton.move 300, 300
        @scene.addChild( @helpButton.sprite )

        null


    addPointer: ->
        @pointer = new Pointer()

        @scene.addChild( @pointer.sprite )

        null


    addDecorations: ->

        @smallShapes = []

        if @B().groupName then nbSpread = 50 else nbSpread = 15

        @smallCircles = []
        for i in [ 0 ... nbSpread ]
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
        for i in [ 0 ... nbSpread * 2 ]
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
        for i in [ 0 ... nbSpread * 2 ]
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
        ###

        the filtered data for you
        @TODO william look at this

        ###

        @groupName = (@B().getQueryVariable 'group') or 'home'
        filteredCategories = @B().categories.where group : @groupName

        @B().groupName = @groupName

        @centralButton = new CentralButton null, 240, @scene
        @centralButton.move @w/2, @h/2
        @scene.addChild @centralButton.sprite
        # @centralButton.animate()

        objs =
            "circle"   : Circle
            "triangle" : Triangle
            "square"   : Square

        size = 100

        # circles
        for i in [ 0 ... filteredCategories.length ]
            data = filteredCategories[i]
            object = new Circle(data, size, @scene)
            object.sprite.alpha = .8
            object.move _.random(120, @w - 120), _.random(120, @h - 120)
            # object.isPulsating = true
            object.vel[0] *= 1 +  Math.random()
            object.vel[1] *= 1 +  Math.random()
            @shapes.push( object )
            @circles.push( object )
            @scene.addChild object.sprite

        for j in [ 0 ... @B().purposes.models.length ]
            data = @B().purposes.models[j]
            object = new Triangle(data, size - 10, @scene)
            object.sprite.alpha = .7
            object.move _.random(120, @w - 120), _.random(120, @h - 120)
            @shapes.push( object )
            @triangles.push( object )
            @triangleAndSquares.push(object)
            @scene.addChild object.sprite

        for k in [ 0 ... @B().dataSources.models.length ]
            data = @B().dataSources.models[k]
            object = new Square(data, size - 20, @scene)
            object.sprite.alpha = .7
            object.move _.random(120, @w - 120), _.random(120, @h - 120)
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

        @tooltip?.update()
        @centralButton?.update()
        @helpButton?.update()

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
                    if shape.isOrbiting then lineWidth = 2 else lineWidth = .8
                    @linesObj.lineStyle( lineWidth, 0x000000, NumUtil.map(dist, 0, 400, .6, 0) )
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
        window.addEventListener('click', @onClick)

        @B().appView.on @B().appView.EVENT_UPDATE_DIMENSIONS, @setDims

        Backbone.Events.on( 'centralButtonTouched', @onCentralButtonTouched )
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


    onClick: ( evt ) =>

        clearInterval( @stepTimer )
        @stepTimer = setTimeout =>
            @gotoStep( @step - 1 )
        , 30000

        @pointer.sprite.position.x = evt.pageX
        @pointer.sprite.position.y = evt.pageY
        @pointer.animate()

        null


    onCircleSelected: ( circle ) =>

        if @currentSelectedCircle then return

        @currentSelectedCircle = circle

        @tooltip.transitionIn @currentSelectedCircle.config.get('name_en'), @currentSelectedCircle.config.get('name_cat')

        @gotoStep(2)

        # @step2Timer = setTimeout =>
        #     @gotoStep(1)
        # , 30000



        # for c in @circles
        #     c.isDisable = true
        #     c.isPulsating = false
        #     if c.id != circle.id then c.disable()

        @currentSelectedCircle.isDisable = false
        @currentSelectedCircle.goToCenterAndScaleUp()

        @activateShapes()

        null


    onCircleUnselected: ( circle, playSound = true ) =>
        if @step == 1
            @clearTimer( 1 )
        else if @step == 2
            @clearTimer( 2 )


        @centralButton.stop()

        @tooltip.transitionOut()

        circle.goBackAndScaleDown playSound

        for shape in @activeShapes
            shape.stopBouncing()

        for shape in @shapes
            if shape.type != 'circle' then shape.fadeTo( .2 )
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

        @activeShapes = []
        @selectedShapes = []
        @absorbedShapes = []
        @currentSelectedCircle = null

        @gotoStep(1)


        null


    activateShapes: ->
        @activeShapes = []
        copySquares = @squares.slice()
        copyTriangles = @triangles.slice()

        rand1 = Math.floor Math.random() * copySquares.length
        rand2 = rand1
        rand2 = Math.floor Math.random() * copySquares.length while rand2 == rand1
        # if Math.random() < .5 then @activeShapes.push( copySquares[rand1] )
        @activeShapes.push( copySquares[rand1] )
        if Math.random() < .5 then @activeShapes.push( copySquares[rand2] )

        rand1 = Math.floor Math.random() * copyTriangles.length
        rand2 = rand1
        rand2 = Math.floor Math.random() * copyTriangles.length while rand2 == rand1
        # @activeShapes.push( copyTriangles[rand1] )
        if Math.random() < .5 then @activeShapes.push( copyTriangles[rand2] )

        for shape in @activeShapes
            if shape.type == 'triangle' then shape.fadeTo( .6 ) else shape.fadeTo( .8 )
            shape.startBouncing()
            shape.canOrbit = true
            @scene.removeChild(  shape.sprite )
            @scene.addChild(  shape.sprite )

        null


    onShapeSelected: ( shape ) =>
        if @step == 1
            @clearTimer( 1 )
        else if @step == 2
            @clearTimer( 2 )

        @selectedShapes.push( shape )

        if @selectedShapes.length == @activeShapes.length then isTheLast = true else isTheLast = false

        shape.getAbsorbed( isTheLast )

        shape.isPulsating = false
        shape.sprite.alpha = 1
        shape.sprite.scale.x = shape.sprite.scale.y = 1

        null



    onShapeGotAbsorbed: ( shape ) =>
        @centralButton.animate()

        scale = @currentSelectedCircle.sprite.scale.x + .5
        TweenMax.to( @currentSelectedCircle.sprite.scale, 1, { x: scale, y: scale, ease: Elastic.easeOut, onComplete: =>
            # @scene.removeChild( @currentSelectedCircle.sprite )
            # @scene.addChild( @currentSelectedCircle.sprite )
         } )

        @absorbedShapes.push( shape )

        if @absorbedShapes.length == @activeShapes.length
            @tooltip.hide()
            category = @currentSelectedCircle.config.get('category_name')
            @B().openOverlayContent category

            if @openOverlayTimer then clearInterval( @openOverlayTimer )

            @openOverlayTimer = setTimeout =>
                Backbone.trigger( 'SoundController:play', 'transition' )
                @absorbedShapes = []
                @onCircleUnselected @currentSelectedCircle, false

            , 300


        null


    onCentralButtonTouched: =>

        if @step == 0
            @gotoStep(1)
        if !@currentSelectedCircle
            for circle in @circles
                circle.bounce()

        null


    gotoStep: ( step ) =>
        ### -------------------------
        - STEP0
        Everything is visible,
        Waiting an action on central button
        -------------------------- ###
        if step == 0
            @step = 0
            for circle in @circles
                circle.stopBouncing()

            for shape in @shapes
                shape.fadeTo( .8 )

        ### -------------------------
        - STEP1
        Central button has been touched,
        Circles start pulsating like hell
        Other shapes fadeOut
        -------------------------- ###
        if step == 1

            clearInterval( @stepTimer )
            @stepTimer = setTimeout =>
                @gotoStep( 0 )
            , 30000

            @step = 1
            if @currentSelectedCircle then @onCircleUnselected( @currentSelectedCircle )
            for shape in @shapes
                shape.stopBouncing()
                if shape.type != 'circle' then shape.sprite.alpha = .2

            for shape in @activeShapes
                shape.stopBouncing()


            for circle in @circles
                circle.sprite.alpha = .8
                circle.startBouncing()
                @scene.removeChild(  circle.sprite )
                @scene.addChild(  circle.sprite )





        ### -------------------------
        - STEP2
        One circle has been touched, it goes to center
        Other shapes start pulsating like hell
        -------------------------- ###
        if step == 2
            @step = 2
            for circle in @circles
                circle.stopBouncing()
                circle.sprite.alpha = .1

            for shape in @triangleAndSquares
                shape.sprite.alpha = .1

            clearInterval( @stepTimer )
            @stepTimer = setTimeout =>
                @gotoStep( 1 )
            , 30000

        null

    clearTimer: ( timerId ) =>
        return
        if timerId == 1 then currentTimer = @step1Timer
        else if timerId == 2 then currentTimer = @step2Timer

        window.setTimeout =>
            @gotoStep( timerId - 1 )
        , 30000

        null


module.exports = InteractiveCanvas
