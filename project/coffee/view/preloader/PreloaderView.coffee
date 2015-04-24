Letter = require './Letter'

class PreloaderView

    el: null
    letters: null

    isLoading: null

    exploreBtn: null


    constructor: ->
        @el = document.querySelector( '#preloader-anim' )
        @exploreBtn = @el.querySelector( '.explore' )
        @by = @el.querySelector( '.by' )
        @subtitle = @el.querySelector( '.subtitle' )

        pos =
            x: @el.getBoundingClientRect().left
            y: @el.getBoundingClientRect().top

        originPos = [
            373
            388
            412
            429
            453
            473
            495
            522
        ]

        domEl = @el.querySelectorAll( '.letter' )

        @letters = []
        for i in [ 0 ... domEl.length ]
            el = domEl[ i ]
            pos = originPos[ i ]
            letter = new Letter( el, pos )
            @letters.push( letter )


        @addListeners()

        setTimeout =>
            @transitionIn()
        , 3000


        null


    addListeners: ->
        @exploreBtn.addEventListener 'click', @startExperience

        null


    render: ->

        null


    show: ->

        null


    hide: ->

        null


    transitionIn: ->
        @el.display = 'block';

        TweenMax.to( @subtitle, .3, { opacity: 1 } )
        TweenMax.to( @by, .3, { opacity: 1 } )
        TweenMax.to( @exploreBtn, .3, { opacity: 1 } )

        for letter in @letters
            letter.stop()

        null


    transitionOut: ->
        TweenMax.to( @el, .3, { opacity: 0, onComplete: @onTransitionOutComplete } )

        null


    onTransitionOutComplete: =>
        @el.style.display = 'none'

        null


    playLoading: ->

        null


    stopPlaying: ->

        null


    update: =>
        for letter in @letters
            letter.update()

        # @letters[0].update()

        null


    startExperience: =>
        @transitionOut()
        Backbone.Events.trigger( 'startExperience' )

        null


module.exports = PreloaderView
