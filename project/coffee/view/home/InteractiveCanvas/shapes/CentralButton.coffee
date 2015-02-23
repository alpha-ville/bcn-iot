BasicShape = require './BasicShape'

class CentralButton extends BasicShape

    lines : null
    color : '0xe79d33'

    rotation: 0

    isAnimating: false

    init : =>

        super()

        @sprite.alpha = 1

        @lines = []

        for i in [0...2]
            lS = new PIXI.Sprite()
            l = new PIXI.Graphics()
            l.beginFill @color, .8
            # l.lineStyle 2, @color
            l.drawCircle 0, 0, @radius()
            lS.addChild l
            lS.alpha = .2;
            @sprite.addChild lS
            @lines.push lS

        # @g.drawCircle 0, 0, @radius()

        currentAngle = 0
        nbPoints = 50
        step = 360 / nbPoints



        for i in [ 0 ... nbPoints ]
            x = ( 0  ) + 120 * Math.cos( currentAngle )
            y = ( 0  ) + 120 * Math.sin( currentAngle )

            @g.beginFill( @color )
            @g.drawCircle x, y, 1.5

            currentAngle += step


        scale = 1.7
        @ripplesAnimation = new TimelineMax({ repeat: -1 })
        @ripplesAnimation.add( TweenMax.to(@lines[0], 1.7, alpha: 0, delay: 0, width: scale, height: scale ) )
        @ripplesAnimation.add( TweenMax.to(@lines[1], 1.7, alpha: 0, delay: -1.4, width: scale, height: scale ) )

        @ripplesAnimation.stop()

        null


    update: ->
        @rotation += .003

        if @rotation > 360 then @rotation = 0

        @g.rotation = @rotation

        null
        

    animate : =>
        if @isAnimating then return

        @isAnimating = true
        

        for i in [0...@lines.length]
            @lines[i].children[0].alpha = 5

        @ripplesAnimation.play()

        null


    stop: =>
        if !@isAnimating then return

        @isAnimating = false
        @ripplesAnimation.time(1)
        @ripplesAnimation.stop()

        for i in [0...@lines.length]
            @lines[0].scale.x = @lines[0].scale.y = 1
            @lines[1].scale.x = @lines[1].scale.y = 1
            @lines[i].children[0].alpha = 4

        null


module.exports = CentralButton
