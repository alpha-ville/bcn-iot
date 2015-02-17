BasicShape = require './BasicShape'

class Square extends BasicShape

    color : 0xd02a40

    init : =>
        @g.drawRect 0,0, @w, @h

        @sprite.pivot = new PIXI.Point @w/2, @h/2

        @sprite.alpha = .3

        null

    onMouseUp: =>
      super()

      if !@canOrbit then return
      Backbone.Events.trigger( 'shapeSelected', @ )

      null



module.exports = Square
