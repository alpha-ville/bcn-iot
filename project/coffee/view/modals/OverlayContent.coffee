AbstractModal = require './AbstractModal'

class OverlayContent extends AbstractModal

    name     : 'overlayContent'
    template : 'overlay-content'
    cb       : null
    lang     : 'en'

    events:
        'click ul>li' : "toggleLang"
        # 'tap ul>li' : "toggleLang"

    constructor : (@cb) ->

        node = (@B().objects.where object_id : @B().selectedObjectId)[0]

        @templateVars =
            content_en  : node.get('copy_en')
            content_cat : node.get('copy_cat')
            video       : node.get('video')
            shape       : node.get('data_type').toLowerCase()
            icon        : node.get('icon')
            title       : node.get('value_type').toUpperCase()

        super()

        return null

    toggleLang : (e) =>
        @$el.find('li').each (a, b) =>
            $(b).removeAttr('data-selected')

        if e
            $(e.currentTarget).attr 'data-selected', true
            @B().langSelected = $(e.currentTarget).attr('data-lang')
        else
            $(@$el.find('li[data-lang="' + @B().langSelected + '"]')).attr 'data-selected', true

        @$el.find('.content p').each (a, b) =>
            $(b).css
                display : if $(b).attr('data-lang') is @B().langSelected then 'block' else 'none'

        null

    init : =>
        @toggleLang()
        null

module.exports = OverlayContent
