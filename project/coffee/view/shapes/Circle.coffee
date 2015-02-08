BasicShape = require './BasicShape'

class Circle extends BasicShape

    lines : null
    color : 0xe79d33

    init : =>

        @lines = []

        for i in [0...4]
            lS = new PIXI.Sprite()
            l = new PIXI.Graphics()
            l.beginFill @color, .8
            # l.lineStyle 2, @color
            l.drawCircle 0, 0, @radius()
            lS.addChild l
            @sprite.addChild lS
            @lines.push lS

        @g.drawCircle 0, 0, @radius()
        null

    animate : =>
        for i in [0...@lines.length]
            @animateLine @lines[i], i
        null

    animateLine : (line, i) =>
        scale = 1.7
        TweenMax.to line, 2, alpha: 0, delay: i / 2, width: scale, height: scale, repeat: -1
        null

module.exports = Circle
