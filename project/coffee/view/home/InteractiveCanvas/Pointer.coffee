class Pointer

  sprite: null
  position: null
  lineWidth: 40

  constructor: ->
    @sprite = new PIXI.Sprite()

    @g = new PIXI.Graphics()
    @g.beginFill 'rgba(0,0,0,.3)'
    @g.drawCircle( 0, 0, 15 )
    @g.alpha = 0

    @g2 = new PIXI.Graphics()
    @g2.beginFill 'rgba(0,0,0,.3)'
    @g2.drawCircle( 0, 0, 15 )
    @g2.alpha = 0

    @position = []

    @sprite.addChild( @g )
    @sprite.addChild( @g2 )

    null


  animate: ->
    TweenMax.fromTo( @g, .8, {alpha: .2}, {alpha: 0} )
    TweenMax.fromTo( @g.scale, .8, {x: 0, y: 0}, {x: 2, y: 2} )
    
    TweenMax.fromTo( @g2, .8, {alpha: .2, delay: .55}, {alpha: 0, delay: .15} )
    TweenMax.fromTo( @g2.scale, .8, {x: 0, y: 0, delay: .55}, {x: 2, y: 2, delay: .15} )

    null


module.exports = Pointer