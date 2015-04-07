BasicShape = require './BasicShape'

class Triangle extends BasicShape

    type: 'triangle'

    color: 0x2773be

    init : =>
        super()

        h = @w * (Math.sqrt(3)/2)
        @g.moveTo 0, 0
        @g.lineTo -@w/2, h
        @g.lineTo @w/2, h

        @sprite.pivot = new PIXI.Point 0, h/2
        @g.moveTo 0, 0
        @g.lineTo -@w/2, h
        @g.lineTo @w/2, h

        @ripple1 = new PIXI.Graphics()
        @ripple1.beginFill @color
        @ripple1.moveTo 0, 0
        @ripple1.lineTo -@w/2, h
        @ripple1.lineTo @w/2, h
        @ripple1.pivot = new PIXI.Point 0, 0

        @ripple2 = new PIXI.Graphics()
        @ripple2.beginFill @color
        @ripple2.moveTo 0, 0
        @ripple2.lineTo -@w/2, h
        @ripple2.lineTo @w/2, h
        @ripple2.pivot = new PIXI.Point 0, 0



        textures = [
          "https://googledrive.com/host/0Bw4Qy0dXirckbkwzcjA0SENiSlU"
          "https://googledrive.com/host/0Bw4Qy0dXirckXy03VGxLWHp6dTg"
          "https://googledrive.com/host/0Bw4Qy0dXirckazhvLS1MWXNBaTA"
          "https://googledrive.com/host/0Bw4Qy0dXirckaTY0Q2laRmRmN1U"
        ]

        @sprite.alpha = .2

        # if not in the background
        if @w == 60
          texture = new PIXI.Texture.fromImage( textures[ Math.floor( Math.random() * 4 ) ] )
          @icon = new PIXI.Sprite( texture )
          @icon.anchor.x = @icon.anchor.y = .5

          @icon.position.x = 0
          @icon.position.y = 35
          @icon.scale.x = @icon.scale.y = .5

          @sprite.addChild( @icon )

          scale = 1.7
          @ripplesAnimation = new TimelineMax({ repeat: -1 })
          @ripplesAnimation.add( TweenMax.to(@ripple1, 1, alpha: 0, delay: 0, width: @w * scale, height: @w * scale ) )
          @ripplesAnimation.add( TweenMax.to(@ripple1.position, 1, x: 0, y: -35, delay: -1 ) )
          @ripplesAnimation.stop()



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
      @sprite.addChild @ripple2

      @ripplesAnimation.play()

      null


    stopAnimate: ->
      return
      @sprite.removeChild @ripple1
      @sprite.removeChild @ripple2

      @ripplesAnimation.stop()

      null

module.exports = Triangle
