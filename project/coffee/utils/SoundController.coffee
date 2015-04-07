class SoundController

  sounds: null

  isMuted: false
  loopVolume: .2
  sfxVolume: .2

  constructor: ( @B ) ->
    @sounds =
      'loop': document.querySelector('.audio-loop')
      'touchable': document.querySelector('.audio-touchable')
      'nontouchable': document.querySelector('.audio-nontouchable')
      'objectconnected': document.querySelector('.audio-objectconnected')
      'transition': document.querySelector('.audio-transition')

    @sounds['loop'].setAttribute 'loop', true

    @sounds['loop'].volume = @loopVolume

    @sounds['touchable'].volume = @sfxVolume
    @sounds['nontouchable'].volume = @sfxVolume
    @sounds['objectconnected'].volume = @sfxVolume
    @sounds['transition'].volume = @sfxVolume

    if @B().groupName and @B().soundParam is 'true'
      @sounds['loop'].play()

    # @play('loop')

    @initEvents()

    null


  initEvents: ->
    window.addEventListener 'keyup', @onKeyUp

    Backbone.on('SoundController:play', @play)
    Backbone.on('SoundController:stop', @stop)
    Backbone.on('SoundController:resumeLoop', @resumeLoop)
    Backbone.on('SoundController:stopLoop', @stopLoop)

    null

  onKeyUp: ( evt ) =>
    if evt.keyCode == 32 then @toggle()
    else if evt.keyCode == 40 then @setSfxVolume( @sfxVolume - .1 )
    else if evt.keyCode == 38 then @setSfxVolume( @sfxVolume + .1 )
    else if evt.keyCode == 87 then @setVolume( @loopVolume + .1 )
    else if evt.keyCode == 83 then @setVolume( @loopVolume - .1 )

    null

  toggle: ->
    if @isMuted
      @sounds['loop'].volume = @loopVolume
    else
      @sounds['loop'].volume = 0

    @isMuted = !@isMuted

    null

  play: ( soundName ) =>
    if @B().soundParam is 'true'
        @sounds[soundName].currentTime = 0
        @sounds[soundName].play()

    null

  stop: ( soundName ) =>
    @sounds[soundName].pause()

    null


  setVolume: ( value ) =>
    if value < 0 then value = 0
    else if value > 1 then value = 1

    @loopVolume = value

    @sounds['loop'].volume = @loopVolume

    null


  setSfxVolume: ->
    @sfxVolume = value

    if @sfxVolume < 0 then @sfxVolume = 0
    else if @sfxVolume > 1 then @sfxVolume = 1

    @sounds['touchable'].volume = @sfxVolume
    @sounds['nontouchable'].volume = @sfxVolume
    @sounds['objectconnected'].volume = @sfxVolume
    @sounds['transition'].volume = @sfxVolume

    null


  resumeLoop: ->
    @sounds['loop'].volume = @loopVolume

    null


  stopLoop: =>
    @sounds['loop'].volume = 0

    null





module.exports = SoundController
