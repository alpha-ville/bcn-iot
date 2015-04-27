class Scene

  width: 0
  height: 0

  container: null

  stage: null
  renderer: null

  backgroundColor: 0xebebeb

  camera: null

  physics:
    engine: null
    world: null


  constructor: ( options ) ->
    @width = window.innerWidth
    @height = window.innerHeight
    @container = options.container

    @stage = new PIXI.Stage( @backgroundColor, {
        antialias : true
        transparent : false
        resolution: 1
        transparent: true
      } )

    @renderer = new PIXI.CanvasRenderer( @width, @height, { transparent: true } )

    @attachToContainer()

    null


  attachToContainer: ->
    @container.appendChild( @renderer.view )

    null


  addChild: ( child ) ->
    @stage.addChild( child )

    null


  removeChild: ( child ) ->
    @stage.removeChild( child )

    null


  swapChildren: ( child1, child2 ) ->
    @stage.swapChildren( child1, child2 )

    null


  update: ->

    null


  render: ->
    # console.log 'render'
    @renderer.render( @stage )

    null


  resize: ->
    @width = window.innerWidth
    @height = window.innerHeight

    @renderer.resize( @width, @height );
    # @renderer.view.style.height = @height + 'px';

    null


module.exports = Scene
