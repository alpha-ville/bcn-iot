BasicShape = require './BasicShape'

class Circle extends BasicShape

    lines : null
    color : 0xe79d33

    init : =>
        super()
        @g.drawCircle 0, 0, @radius()

        null

module.exports = Circle
