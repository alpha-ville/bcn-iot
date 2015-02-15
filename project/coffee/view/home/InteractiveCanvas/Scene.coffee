class Scene

  width: 0
  height: 0

  container: null

  stage: null
  renderer: null

  backgroundColor: 0x000000

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
        resolution: window.devicePixelRatio
      } )

    @renderer = PIXI.autoDetectRecommendedRenderer( @width, @height )

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


  update: ->

    null


  render: ->
    # console.log 'render'
    @renderer.render( @stage )

    null


  resize: ->
    @width = window.innerWidth
    @height = window.innerHeight

    @renderer.view.style.width = @width + 'px';
    @renderer.view.style.height = @height + 'px';

    null


module.exports = Scene