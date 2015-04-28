Letter = require './Letter'

class PreloaderView

    el: null
    refLetters: null
    letters: null

    isLoading: null

    exploreBtn: null


    constructor: ->
        @el = document.querySelector( '#preloader-anim' )
        @exploreBtn = @el.querySelector( '.explore' )
        @by = @el.querySelector( '.by' )
        @subtitle = @el.querySelector( '.subtitle' )
        @partners = @el.querySelector( '.partners' )


        pos =
            x: @el.getBoundingClientRect().left
            y: @el.getBoundingClientRect().top

        originPos = [
            373
            384
            408
            425
            449
            469
            491
            518
        ]

        domEl = @el.querySelectorAll( '.letter' )

        @letters = []
        for i in [ 0 ... domEl.length ]
            el = domEl[ i ]
            pos = originPos[ i ]
            letter = new Letter( el, pos - 373 )
            @letters.push( letter )





        null



    addListeners: ->
        @exploreBtn.addEventListener 'click', => @startExperience()

        null


    show: ->

        null


    hide: ->

        null


    transitionIn: ->
        @el.display = 'block';

        TweenMax.to( @subtitle, .3, { opacity: 1, delay: 1.5, onComplete: @onFirstTransitionComplete} )



        for letter in @letters
            letter.stop()

        null


    onFirstTransitionComplete: =>
        if @cb
            setTimeout =>
                @cb()
            , 2000
        else
            @exploreBtn.style.cursor = 'pointer'
            TweenMax.to( @exploreBtn, .2, { opacity: 1, delay: 1 } )
            @addListeners()

            TweenMax.to( @by, .3, { opacity: 1, delay: 2 } )
            TweenMax.to( @partners, .3, { opacity: 1, delay: 3 } )

        null


    transitionOut: ->
        TweenMax.to( @el, .3, { opacity: 0, onComplete: @onTransitionOutComplete } )

        null


    onTransitionOutComplete: =>
        @el.style.display = 'none'

        null



    stopPlaying: ( @cb ) ->
        setTimeout =>
            @transitionIn()
        , 2000

        null


    update: =>
        for letter in @letters
            letter.update()

        # @letters[0].update()

        null


    startExperience: ( step = -2 ) =>
        console.log step
        @transitionOut()
        Backbone.Events.trigger( 'startExperience', step )

        null


module.exports = PreloaderView
