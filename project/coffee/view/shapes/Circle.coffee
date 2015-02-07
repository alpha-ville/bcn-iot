BasicShape = require './BasicShape'

class Circle extends BasicShape

    circ  : Math.PI * 2

    init : =>
        @g.drawCircle 0, 0, @radius()
        null

module.exports = Circle
