BasicShape = require './BasicShape'

class CentralButton extends BasicShape

    lines : null
    color : '0xe79d33'

    rotation: 0

    isAnimating: false

    init : =>

        super()

        textureMap =
            'environment': '0B7kWGoq62sNjbUtrNWVYVUJNQlE'
            'home': '0B7kWGoq62sNjU1BNdHR4MmM1eXM'
            'body_mind': '0B7kWGoq62sNjS1FnRGF6ZTJxQkk'
            'culture': '0B7kWGoq62sNjZzRHcUswdGNUQVU'
            'diy': '0B7kWGoq62sNjcUIzb1pxakk0a0k'
            'social': '0B7kWGoq62sNjVlR1TTJDYzhUSjg'

        @sprite.alpha = 1

        @background = new PIXI.Graphics()
        @background.beginFill @color
        @background.drawCircle( 0, 0, @radius() )
        @background.alpha = .3

        @ripple1 = new PIXI.Graphics()
        @ripple1.beginFill @color
        @ripple1.drawCircle( 0, 0, @radius() )
        @ripple1.alpha = 0

        @ripple2 = new PIXI.Graphics()
        @ripple2.beginFill @color
        @ripple2.drawCircle( 0, 0, @radius() )
        @ripple2.alpha = 0

        @sprite.addChild( @background )
        @sprite.addChild( @ripple1 )
        @sprite.addChild( @ripple2 )

        currentAngle = 0
        nbPoints = 50
        step = 360 / nbPoints


        for i in [ 0 ... nbPoints ]
            x = ( 0  ) + 100 * Math.cos( currentAngle )
            y = ( 0  ) + 100 * Math.sin( currentAngle )

            @g.beginFill( @color )
            @g.drawCircle x, y, 1.5

            currentAngle += step

        textureName = "https://googledrive.com/host/" + textureMap[@B().groupName]
        texture = new PIXI.Texture.fromImage( textureName )
        @icon = new PIXI.Sprite( texture )
        @icon.scale.x = @icon.scale.y = .4
        @icon.anchor.x = .5
        @icon.anchor.y = .6
        @sprite.addChild( @icon )


        

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
        

    animate : ( initialScale = 1 ) =>
        scale = 1.8
        TweenMax.fromTo(@ripple1.scale, 1, {x: initialScale, y: initialScale}, {x: scale, y: scale, ease: Circ.easeOut} )
        # TweenMax.fromTo(@ripple2.scale, 1, {x: initialScale, y: initialScale, delay: .15}, {x: scale, y: scale, delay: .3} )

        TweenMax.fromTo(@ripple1, 1.3, {alpha: 1}, {alpha: 0} )
        # TweenMax.fromTo(@ripple2, 1.3, {alpha: 1, delay: .15}, {alpha: 0, delay: .3} )

        null


    stop: =>
        return
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
