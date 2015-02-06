BasicShape = require './BasicShape'

class Circle extends BasicShape

    circ  : Math.PI * 2

    init : =>
        @g.beginFill 0xFF0000
        @g.drawCircle 0, 0, @radius()
        null

module.exports = Circle
