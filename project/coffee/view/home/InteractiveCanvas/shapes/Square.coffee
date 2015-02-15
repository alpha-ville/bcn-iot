BasicShape = require './BasicShape'

class Square extends BasicShape

    color : 0xd02a40

    init : =>
        @g.drawRect 0,0, @w, @h

        @sprite.pivot = new PIXI.Point @w/2, @h/2
        null

module.exports = Square
