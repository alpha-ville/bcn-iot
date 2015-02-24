AbstractView = require '../AbstractView'

class ObjectsList extends AbstractView

    template : 'objects-list'
    carousel : null

    constructor : (list) ->
        @templateVars =
            projects : list
            path : "/img/video/"

        super()
        null

    animate : (delay) =>
        margin = 30
        TweenMax.to @$el, .5, 'margin-top' : margin, opacity: 1, delay: 1.2
        null

    afterChange : (event, slick, currentSlide, nextSlide) =>
        @trigger 'slideChange', $(slick.$slides[currentSlide]).attr 'id'
        null

    init : =>
        setTimeout =>
            @$el.slick
              dots          : false
              infinite      : true
              speed         : 300
              arrows        : true
              slidesToShow  : 1

            @$el.on 'afterChange', @afterChange
        , 100
              # centerMode    : true
              # centerPadding : '130px'
              # useCSS        : true
              # variableWidth : true
          # autoplay      : true
          # autoplaySpeed : 2000


module.exports = ObjectsList
