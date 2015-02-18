BasicShape = require './BasicShape'

class Square extends BasicShape

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

        @sprite.alpha = .3

        textures = [
          "img/icons/placeholder2.png"
          "img/icons/placeholder3.png"
          "img/icons/placeholder4.png"
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

        null

    onMouseUp: =>
      super()

      if !@canOrbit then return
      Backbone.Events.trigger( 'shapeSelected', @ )

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



module.exports = Square
