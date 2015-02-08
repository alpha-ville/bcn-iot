AbstractModal = require './AbstractModal'

class OverlayContent extends AbstractModal

    name     : 'overlayContent'
    template : 'overlay-content'
    cb       : null

    events:
        'click ul>li' : "toggleLang"
        # 'tap ul>li' : "toggleLang"

    constructor : (@cb) ->

        @templateVars =
            content : 'asdasd'
            video : null

        super()

        return null

    toggleLang : (e) =>
        @$el.find('li').each (a, b) =>
            $(b).removeAttr('data-selected')

        $(e.currentTarget).attr 'data-selected', true
        null

    init : =>

        null

module.exports = OverlayContent
