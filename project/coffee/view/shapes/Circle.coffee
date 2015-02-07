BasicShape = require './BasicShape'

class Circle extends BasicShape

    init : =>
        @g.drawCircle 0, 0, @radius()
        null

module.exports = Circle
