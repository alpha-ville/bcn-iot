AbstractView = require '../AbstractView'

class ObjectsList extends AbstractView

    template : 'objects-list'

    constructor : (list) ->
        @templateVars =
            projects : list
            path : "/img/video/"

        super()
        null

    init : =>
        setTimeout =>
            @$el.slick
              dots          : false
              infinite      : true
              speed         : 300
              arrows        : true
              slidesToShow  : 3
              centerPadding : '30px'
              useCSS : true
              variableWidth : true
              centerMode    : true
        , 100
          # autoplay      : true
          # autoplaySpeed : 2000


module.exports = ObjectsList
