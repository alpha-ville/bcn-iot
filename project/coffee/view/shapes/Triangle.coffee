BasicShape = require './BasicShape'

class Triangle extends BasicShape

    color: 0x2773be

    init : =>
        h = @w * (Math.sqrt(3)/2)
        @g.moveTo 0, 0
        @g.lineTo -@w/2, h
        @g.lineTo @w/2, h

        @sprite.pivot = new PIXI.Point 0, h/2

        null

module.exports = Triangle
