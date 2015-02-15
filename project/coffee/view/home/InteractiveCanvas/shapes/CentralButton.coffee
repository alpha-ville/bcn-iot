BasicShape = require './BasicShape'

class CentralButton extends BasicShape

    lines : null
    color : 0xe79d33

    init : =>

        super()

        @lines = []

        for i in [0...2]
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
        TweenMax.to line, 1.7, alpha: 0, delay: i - ( i * .7 ), width: scale, height: scale, repeat: -1
        null

module.exports = CentralButton
