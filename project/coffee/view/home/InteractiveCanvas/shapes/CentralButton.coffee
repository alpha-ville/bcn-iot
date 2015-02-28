BasicShape = require './BasicShape'

class CentralButton extends BasicShape

    lines : null
    color : '0xe79d33'

    rotation: 0

    isAnimating: false

    init : =>

        super()

        @sprite.alpha = 1

        l = new PIXI.Graphics()
        l.beginFill @color, .3
        l.drawCircle 0, 0, @radius()
        @sprite.addChild l

        @lines = []

        for i in [0...2]
            lS = new PIXI.Sprite()
            l = new PIXI.Graphics()
            l.beginFill @color, .8
            # l.lineStyle 2, @color
            l.drawCircle 0, 0, @radius()
            lS.addChild l
            lS.alpha = .2;
            # @sprite.addChild lS
            @lines.push lS

        # @g.drawCircle 0, 0, @radius()

        currentAngle = 0
        nbPoints = 50
        step = 360 / nbPoints


        for i in [ 0 ... nbPoints ]
            x = ( 0  ) + 100 * Math.cos( currentAngle )
            y = ( 0  ) + 100 * Math.sin( currentAngle )

            @g.beginFill( @color )
            @g.drawCircle x, y, 1.5

            currentAngle += step

        texture = new PIXI.Texture.fromImage( "https://googledrive.com/host/0B7kWGoq62sNjU1BNdHR4MmM1eXM" )
        @icon = new PIXI.Sprite( texture )
        @icon.scale.x = @icon.scale.y = .4
        @icon.anchor.x = .5
        @icon.anchor.y = .6
        @sprite.addChild( @icon )


        scale = 1.7
        @ripplesAnimation = new TimelineMax({ repeat: -1 })
        @ripplesAnimation.add( TweenMax.to(@lines[0], 1.7, alpha: 0, delay: 0, width: scale, height: scale ) )
        @ripplesAnimation.add( TweenMax.to(@lines[1], 1.7, alpha: 0, delay: -1.4, width: scale, height: scale ) )

        @ripplesAnimation.stop()

        @sprite.isInteractive = false

        null


    onMouseUp: ->
        Backbone.Events.trigger( 'centralButtonTouched' )
        Backbone.trigger( 'SoundController:play', 'nontouchable' )

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
            @sprite.addChild( @lines[i] )
        

        for i in [0...@lines.length]
            @lines[i].children[0].alpha = 5

        @ripplesAnimation.play()

        null


    stop: =>
        if !@isAnimating then return

        @isAnimating = false
        @ripplesAnimation.time(1)
        @ripplesAnimation.stop()


        

        TweenMax.to( @lines[0].scale, 1, { x: 8, y: 8 } )
        TweenMax.fromTo( @lines[0], 2, { alpha: 5 }, { alpha: 0, delay: -1.3, onComplete: =>
            for i in [0...@lines.length]
                @lines[0].scale.x = @lines[0].scale.y = 1
                @lines[1].scale.x = @lines[1].scale.y = 1
                @lines[i].children[0].alpha = 8
                @sprite.isInteractive = false
                for i in [0...@lines.length]
                    @sprite.removeChild( @lines[i] )
         } )
        

        null


module.exports = CentralButton
