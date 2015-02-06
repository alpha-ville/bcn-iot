BasicShape = require './BasicShape'

class Triangle extends BasicShape

    init : =>
        @g.beginFill 0xFF0000
        @g.moveTo 0, 0
        @g.lineTo -@w/2, @h
        @g.lineTo @w/2, @h
        null

module.exports = Triangle
