NumUtil = require '../../utils/NumUtil'
Letter = require './Letter'

class PreloaderView

    el: null
    refLetters: null
    letters: null

    isLoading: null

    exploreBtn: null

    shadowHelpBtn: null
    shadowHelpBtnStyle: null
    shadowHelpBtnScale: 0


    constructor: ->
        @el = document.querySelector( '#preloader-anim' )
        @exploreBtn = @el.querySelector( '.explore' )
        @by = @el.querySelector( '.by' )
        @subtitle = @el.querySelector( '.subtitle' )
        @partners = @el.querySelector( '.partners' )
        @shadowHelpBtn = @el.querySelector( '.shadowHelp' )
        @shadowHelpBtnStyle = @shadowHelpBtn.style


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


        @addListeners()


        null



    addListeners: ->
        Backbone.Events.on( 'showRoot', @transitionIn)
        @shadowHelpBtn.addEventListener( 'click', @onShadowHelpBtnClicked )
        @shadowHelpBtn.addEventListener( 'mouseenter', @onShadowHelpBtnOver )
        @shadowHelpBtn.addEventListener( 'mouseleave', @onShadowHelpBtnOut )

        null


    show: ->

        null


    hide: ->

        null


    stop: ->
        TweenMax.to( @subtitle, .3, { opacity: 1, delay: 1.5, onComplete: @onFirstTransitionComplete} )



        for letter in @letters
            letter.stop()

        null


    onFirstTransitionComplete: =>
        if @cb
            setTimeout =>
                @cb()
            , 1500
        else
            Backbone.trigger('SoundController:play', 'intro')
            @exploreBtn.style.cursor = 'pointer'
            TweenMax.to( @exploreBtn, .2, { opacity: 1, delay: 1 } )
            @exploreBtn.addEventListener 'click', => @startExperience()

            TweenMax.to( @by, .3, { opacity: 1, delay: 2 } )
            TweenMax.to( @partners, .3, { opacity: 1, delay: 3 } )

        null


    transitionIn: =>
        @el.style.display = 'block';

        TweenMax.to( @el, .3, { opacity: 1, delay: .1 } )

        null


    transitionOut: ( @cb ) =>
        TweenMax.to( @el, .3, { opacity: 0, onComplete: @onTransitionOutComplete } )

        null


    onTransitionOutComplete: =>
        @el.style.display = 'none'
        @el.remove()

        if @cb then @cb()

        null


    transitionInShadowHelpBtn: ->
        @shadowHelpBtnTween = new TweenMax( @, 1.5, { shadowHelpBtnScale: 1, ease: Elastic.easeOut, delay: 4 } )

        null



    stopPlaying: ( @cb ) ->
        setTimeout =>
            @stop()
        , 2000

        null


    update: ( canvasHelpBtn ) =>
        for letter in @letters
            letter.update()

        # @letters[0].update()

        if canvasHelpBtn

            if @shadowHelpBtnScale == 0
                @transitionInShadowHelpBtn()

            transform = "translate(#{canvasHelpBtn.pos[0] - 35}px, #{canvasHelpBtn.pos[1]- 35}px) rotate(#{canvasHelpBtn.sprite.rotation}rad) scale(#{@shadowHelpBtnScale})"

            @shadowHelpBtnStyle.webkitTransform = transform
            @shadowHelpBtnStyle.MozTransform = transform
            @shadowHelpBtnStyle.msTransform = transform
            @shadowHelpBtnStyle.OTransform = transform
            @shadowHelpBtnStyle.transform = transform



        null


    onShadowHelpBtnClicked: =>
        @transitionOut =>
            @B().router.navigateTo( 'about' )


        null


    onShadowHelpBtnOver: =>
        @shadowHelpBtnTween = new TweenMax( @, 1, { shadowHelpBtnScale: 1.2, ease: Elastic.easeOut } )

        null


    onShadowHelpBtnOut: =>
        @shadowHelpBtnTween = new TweenMax( @, 1, { shadowHelpBtnScale: 1, ease: Elastic.easeOut } )

        null


    startExperience: ( step = -2 ) =>
        @transitionOut()
        Backbone.Events.off( 'showRoot', @transitionIn)
        Backbone.Events.trigger( 'startExperience', step )

        null


    B: ->

        return window.B



module.exports = PreloaderView
