AbstractView = require '../AbstractView'

class HomeTooltip extends AbstractView

    template : 'home-tooltip'

    events :
        "click" : "clickBreadcrumb"

    constructor : (@list) ->
        # @templateVars =
        #     list : @list

        super()

        null

    show: =>
        if @el.classList.contains('hide') then @el.classList.remove('hide')

        null

    hide: =>
        if !@el.classList.contains('hide') then @el.classList.add('hide')

        null

module.exports = HomeTooltip
