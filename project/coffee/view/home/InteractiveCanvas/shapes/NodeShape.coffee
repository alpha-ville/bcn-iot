BasicShape = require './BasicShape'

class NodeShape extends BasicShape

    color : null

    init : =>

        colorRange = [
            '0xe79d33'
            '0x2773be'
            '0xd02a40'
        ]

        @sprite.alpha = 0.7

        @color = colorRange[ Math.floor( Math.random() * 3 ) ]
        @g.beginFill @color

        @g.drawCircle 0, 0, @radius()

        null
        

module.exports = NodeShape
