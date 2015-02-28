AbstractView = require '../AbstractView'
NumUtil = require('../../utils/NumUtil.coffee');

class HomeTooltip extends AbstractView

    template : 'home-tooltip'

    events :
        "click" : "clickBreadcrumb"

    labels: null
    labelFr: null
    labelEn: null

    constructor : (@list) ->
        # @templateVars =
        #     list : @list

        super()

        @labels = []

        @labelFr = @el.querySelector('.fr')
        @labels.push( @labelFr )

        # for easy testing
        window.addEventListener( 'keyup', @onKeyUp )

        null

    onKeyUp: ( evt ) =>
        if evt.keyCode != 84 then return

        @transitionOut( 'PLOP' )

    buildSpans: ->
        for label in @labels
            roughHTML = label.innerHTML
            spanHTML = ''

            for letter in roughHTML
                spanHTML += '<span>' + letter + '</span>'

            label.innerHTML = spanHTML

        null

    show: =>
        if @el.classList.contains('hide') then @el.classList.remove('hide')

        null

    hide: =>
        if !@el.classList.contains('hide') then @el.classList.add('hide')

        null


    transitionOut: ( copyFr ) ->
        

        null

module.exports = HomeTooltip
