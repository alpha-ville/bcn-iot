BasicShape = require './BasicShape'

class Square extends BasicShape

    type: 'square'

    color : 0xd02a40

    init : =>
        super()

        @g.drawRect 0,0, @w, @h

        @ripple1 = new PIXI.Graphics()
        @ripple1.beginFill( @color )
        @ripple1.drawRect 0,0, @w, @h

        @ripple2 = new PIXI.Graphics()
        @ripple2.beginFill( @color )
        @ripple2.drawRect 0,0, @w, @h
        @ripple2.pivot = new PIXI.Point @w/2, @h/2

        @sprite.pivot = new PIXI.Point @w/2, @h/2

        # @sprite.alpha = .2

        textures = [
          "https://googledrive.com/host/0Bw4Qy0dXirckXy03VGxLWHp6dTg"
          "https://googledrive.com/host/0Bw4Qy0dXirckazhvLS1MWXNBaTA"
          "https://googledrive.com/host/0Bw4Qy0dXirckaTY0Q2laRmRmN1U"
        ]

        if @w == 60

          texture = new PIXI.Texture.fromImage( textures[ Math.floor( Math.random() * 3 ) ] )
          @icon = new PIXI.Sprite( texture )
          @icon.anchor.x = @icon.anchor.y = -.5
          @icon.position.x = -20
          @icon.position.y = -20
          @icon.scale.x = @icon.scale.y = .5

          @sprite.addChild( @icon )

          scale = 1.7
          console.log @ripple1
          @ripplesAnimation = new TimelineMax({ repeat: -1 })
          @ripplesAnimation.add( TweenMax.to(@ripple1, 1.7, alpha: 0, delay: 0, width: 80, height: 80 ) )
          # @ripplesAnimation.add( TweenMax.to(@ripple1.position, 1.7, delay: -1.7, x: -40, y: -40 ) )
          @ripplesAnimation.stop()
          @sprite.alpha = 1

        null

    onMouseUp: =>
      super()

      if !@canOrbit or @isOrbiting then return

      @isOrbiting = true

      Backbone.Events.trigger( 'shapeSelected', @ )
      Backbone.trigger( 'SoundController:play', 'touchable' )

      null


    animate: ->
      return
      @sprite.addChild @ripple1
      # @sprite.addChild @ripple2

      @ripplesAnimation.play()

      null


    stopAnimate: ->
      return
      @sprite.removeChild @ripple1
      # @sprite.removeChild @ripple2

      @ripplesAnimation.stop()

      null

    onResize: =>
      super
      null



module.exports = Square
