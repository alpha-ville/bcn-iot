BasicShape = require './BasicShape'

class Triangle extends BasicShape

    color: 0x2773be

    init : =>
        super()

        h = @w * (Math.sqrt(3)/2)
        @g.moveTo 0, 0
        @g.lineTo -@w/2, h
        @g.lineTo @w/2, h

        @sprite.pivot = new PIXI.Point 0, h/2

        

        textures = [
          "img/icons/placeholder_white.png"
          "img/icons/placeholder2.png"
          "img/icons/placeholder3.png"
          "img/icons/placeholder4.png"
        ]

        if @w == 60
          texture = new PIXI.Texture.fromImage( textures[ Math.floor( Math.random() * 4 ) ] )
          @icon = new PIXI.Sprite( texture )
          @icon.anchor.x = @icon.anchor.y = .5
          
          @icon.position.x = 0
          @icon.position.y = 35
          @icon.scale.x = @icon.scale.y = .5

          @sprite.addChild( @icon )

        @sprite.alpha = .3

        null

    onMouseUp: =>
      super()

      if !@canOrbit then return
      Backbone.Events.trigger( 'shapeSelected', @ )

      null

module.exports = Triangle
