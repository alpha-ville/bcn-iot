BasicShape = require './BasicShape'

class HelpButton extends BasicShape

    color : '0x61ab63'


    init : =>
        super()

        @sprite.alpha = 1

        @g.beginFill @color

        @g.drawCircle 0, 0, @radius()

        @text = new PIXI.Text("?", { font: "20px Arial", fill: "white", align: "left" });
        @text.position.x = -5
        @text.position.y = -10

        @sprite.addChild( @text )

        null


    onMouseUp: ->
        super()

        @B().openHelp()

        null
        

module.exports = HelpButton
