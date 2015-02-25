class SoundController

  audioNode: null

  isMuted: false
  currentVolume: .1

  constructor: ->
    @audioLoopNode = document.querySelector('.audioLoop')

    @audioLoopNode.setAttribute 'loop', true

    @audioLoopNode.volume = @currentVolume
    @audioLoopNode.play()

    @initEvents()

    null


  initEvents: ->
    window.addEventListener 'keyup', @onKeyUp

    null

  onKeyUp: ( evt ) =>
    if evt.keyCode == 32 then @toggle()
    else if evt.keyCode == 40 then @setVolume( @currentVolume - .1 )
    else if evt.keyCode == 38 then @setVolume( @currentVolume + .1 )

    null

  toggle: ->
    if @isMuted
      @audioLoopNode.volume = @currentVolume
    else 
      @audioLoopNode.volume = 0

    @isMuted = !@isMuted

    null


  setVolume: ( value ) =>
    @currentVolume = value

    if @currentVolume < 0 then @currentVolume = 0
    else if @currentVolume > 1 then @currentVolume = 1

    @audioLoopNode.volume = @currentVolume

    null


module.exports = SoundController