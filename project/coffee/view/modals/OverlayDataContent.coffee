AbstractModal = require './AbstractModal'

class OverlayDataContent extends AbstractModal

    name     : 'overlayDataContent'
    template : 'overlay-content-data'
    cb       : null

    events:
        'click ul>li' : "toggleLang"
        'click .close-button' : "closeButton"
        # 'tap ul>li' : "toggleLang"

    constructor : (@cb) ->

        node = @B()[@B().selectedDataType].findWhere id : parseInt(@B().selectedDataId)

        @templateVars =
            content_en  : node.get('copy_en')
            content_cat : node.get('copy_cat')
            title_en    : node.get('name_en').toUpperCase()
            title_cat   : node.get('name_cat').toUpperCase()
            shape       : node.get('shape')
            icon        : node.get('icon_id')

        super()

        return null

    closeButton : =>
        @B().appView.modalManager.hideOpenModal()
        @B().appView.modalManager.showModal 'overlayContent'
        null

    toggleLang : (e) =>
        @$el.find('li').each (a, b) =>
            $(b).removeAttr('data-selected')

        if e
            $(e.currentTarget).attr 'data-selected', true
            @B().langSelected = $(e.currentTarget).attr('data-lang')
        else
            $(@$el.find('li[data-lang="' + @B().langSelected + '"]')).attr 'data-selected', true

        @$el.find('[data-lang]').not("li").each (a, b) =>
            $(b).css
                display : if $(b).attr('data-lang') is @B().langSelected then 'block' else 'none'

        null

    init : =>
        @toggleLang()
        null

module.exports = OverlayDataContent
