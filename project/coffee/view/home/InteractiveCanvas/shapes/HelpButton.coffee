BasicShape = require './BasicShape'

class HelpButton extends BasicShape

    # color : '0x61ab63'
    color : '0x000000'


    init : =>
        super()

        @offset = 200

        @sprite.alpha = 1

        @g.beginFill @color

        @g.drawCircle 0, 0, 35

        @text = new PIXI.Text("?", { font: "20px Arial", fill: "white", align: "left" });
        @text.position.x = -5
        @text.position.y = -10

        @sprite.addChild( @text )

        null


    onMouseUp: ->
        Backbone.trigger( 'hideHomeTooltip' )
        Backbone.trigger( 'SoundController:play', 'touchable' )

        @B().openHelp()

        null
        

module.exports = HelpButton
