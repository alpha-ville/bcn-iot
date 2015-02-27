class Pointer

  sprite: null
  position: null
  lineWidth: 40

  constructor: ->
    @sprite = new PIXI.Sprite()

    @g = new PIXI.Graphics()
    @g.beginFill 'rgba(0,0,0,.3)'
    @g.drawCircle( 0, 0, 15 )

    @g2 = new PIXI.Graphics()
    @g2.beginFill 'rgba(0,0,0,.3)'
    @g2.drawCircle( 0, 0, 15 )

    @position = []

    @sprite.addChild( @g )
    @sprite.addChild( @g2 )

    null


  animate: ->
    TweenMax.fromTo( @g, .4, {alpha: .2}, {alpha: 0} )
    TweenMax.fromTo( @g.scale, .4, {x: 1, y: 1}, {x: 2, y: 2} )
    
    TweenMax.fromTo( @g2, .4, {alpha: .2, delay: .2}, {alpha: 0, delay: .15} )
    TweenMax.fromTo( @g2.scale, .4, {x: 1, y: 1, delay: .2}, {x: 2, y: 2, delay: .15} )

    null


  onAnimate: =>
    @g.lineStyle( @lineWidth, '0x000000' )
    console.log @g

    null


module.exports = Pointer