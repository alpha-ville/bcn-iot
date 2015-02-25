SoundController =

  audioNode: null

  init: ->
    @audioLoopNode = document.querySelector('.audioLoop')

    @audioLoopNode.setAttribute 'loop', true

    @audioLoopNode.volume = .1
    @audioLoopNode.play()

    null


module.exports = SoundController