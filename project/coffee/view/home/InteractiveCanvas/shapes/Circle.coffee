BasicShape = require './BasicShape'

class Circle extends BasicShape

    type: 'circle'

    lines : null
    color : 0xe79d33
    icon: null
    isSelected: false
    isDisable: false

    nbConnections: 0

    init : =>
        super()
        @g.drawCircle 0, 0, @radius()

        texture = new PIXI.Texture.fromImage("img/icons/placeholder_white.png")
        @icon = new PIXI.Sprite( texture )
        @icon.anchor.x = @icon.anchor.y = .5
        @icon.scale.x = @icon.scale.y = .5

        @sprite.addChild( @icon )

        @lines = []
 

        null


    onMouseUp: ->
        if @radius() != 50 then return

        if @isSelected
            Backbone.Events.trigger( 'circleUnselected', @ )
        else
            Backbone.Events.trigger( 'circleSelected', @ )



        null


    goToCenterAndScaleUp: ->
        Backbone.trigger( 'SoundController:play', 'touchable' )
        @behavior = 'none'
        @isSelected = true

        scale = 1 / ( @w / 250 )

        TweenMax.to( @sprite, 1.5, { alpha: 1 } )
        TweenMax.to( @sprite.position, 1.5, { x: window.innerWidth/2, y: window.innerHeight/2, ease: Elastic.easeOut } )
        TweenMax.to( @sprite.scale, .8, { x: scale, y: scale, delay: 1.7, ease: Elastic.easeOut } )

        null


    goBackAndScaleDown: ->
        Backbone.trigger( 'SoundController:play', 'nontouchable' )
        @behavior = 'target'
        @isSelected = false

        TweenMax.to( @sprite.scale, .8, { x: 1, y: 1, ease: Elastic.easeOut } )

        null


    disable: ->
        @sprite.interactive = false
        @alphaTween = new TweenMax( @sprite, .3, { alpha: 0.08, ease: Power4.easeIn } )

        null


    undisable: ->
        @sprite.interactive = true
        @alphaTween = new TweenMax( @sprite, .3, { alpha: 1, ease: Power4.easeIn, delay: Math.random() } )

        null

module.exports = Circle
