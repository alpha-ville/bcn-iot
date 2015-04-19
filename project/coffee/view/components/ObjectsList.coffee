AbstractView = require '../AbstractView'

class ObjectsList extends AbstractView

    template   : 'objects-list'
    videoPlayer : null

    constructor : (list) ->
        @templateVars =
            projects : list

        super()

        @loadVideos()
        null

    animate : (delay) =>
        margin = 30
        TweenMax.to @$el, .5, 'margin-top' : margin, opacity: 1, delay: 1.2
        null

    afterChange : (event, slick, currentSlide, nextSlide) =>
        @trigger 'slideChange', $(slick.$slides[currentSlide]).attr 'id'
        @addVideoJS()
        null

    beforeChange : (event, slick, currentSlide, nextSlide) =>
        Backbone.trigger( 'SoundController:play', 'touchable' )
        @B().objectsContentHackOrder = nextSlide
        @$el.find('video').each ->
            @.pause()
            @.currentTime = 0

        @trigger 'beforeChange'
        null

    addVideoJS : =>
        return unless @$el.find('.video-js').length > 0
        @videoPlayer = videojs @$el.find('.video-js')[0]
        @videoPlayer.on 'play', @onPlay
        @videoPlayer.on 'ended', @onStop
        @videoPlayer.on 'pause', @onStop

        null


    loadVideos: =>
        $("video").each (index) ->
            $(@).get(0).load()
            $(@).get(0).addEventListener "canplaythrough", ->
                this.play()
                this.pause()

        null

    dispose : =>
        @videoPlayer.dispose()
        null

    onStop : =>
        @B().appView.soundControlller.resumeLoop()
        null

    onPlay : =>
        @B().appView.soundControlller.stopLoop()
        null

    init : =>

        setTimeout =>

            @$el.slick
              dots          : false
              infinite      : true
              speed         : 1000
              arrows        : true
              slidesToShow  : 1

            if @B().objectsContentHackOrder
                @$el.slick('slickGoTo', @B().objectsContentHackOrder)

            @addVideoJS()
            @$el.on 'afterChange', @afterChange
            @$el.on 'beforeChange', @beforeChange
        , 100
              # centerMode    : true
              # centerPadding : '130px'
              # useCSS        : true
              # variableWidth : true
          # autoplay      : true
          # autoplaySpeed : 2000


module.exports = ObjectsList
