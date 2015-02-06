BasicShape = require './BasicShape'

class Square extends BasicShape

    circ  : Math.PI * 2

    init : =>
        @g.beginFill 0xFF0000
        @g.drawRect 0, 0, @w, @h
        null

module.exports = Square
