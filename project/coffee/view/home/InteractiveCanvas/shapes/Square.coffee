BasicShape = require './BasicShape'

class Square extends BasicShape

    color : 0xd02a40

    init : =>
        super()

        @g.drawRect 0,0, @w, @h

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

        null

    onMouseUp: =>
      super()

      if !@canOrbit then return
      Backbone.Events.trigger( 'shapeSelected', @ )

      null



module.exports = Square
