BasicShape = require './BasicShape'

class Triangle extends BasicShape

    init : =>
        h = @w * (Math.sqrt(3)/2)
        @g.moveTo 0, 0
        @g.lineTo -@w/2, h
        @g.lineTo @w/2, h
        null

module.exports = Triangle
