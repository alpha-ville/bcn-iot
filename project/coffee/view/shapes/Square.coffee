BasicShape = require './BasicShape'

class Square extends BasicShape

    init : =>
        @g.drawRect 0, 0, @w, @h
        null

module.exports = Square
