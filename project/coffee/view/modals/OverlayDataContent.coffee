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

        node = (@B()[@B().selectedDataType]).findWhere id : String(@B().selectedDataId)

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
        Backbone.trigger( 'SoundController:play', 'nontouchable' )
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
        @animate()
        null

    animate : =>
        margin = 30

        c = $(@$el.find('.container-shape')[0])
        TweenMax.to c, 0, scaleX: 0, scaleY: 0, delay: 0
        TweenMax.to c, 1, scaleX: 1, scaleY: 1, ease: Back.easeOut.config(12), opacity: 1, delay: .5

        t = $(@$el.find('.title-container')[0])
        TweenMax.to t, .5, 'margin-top' : margin, opacity: 1, delay: 1

        cont = $(@$el.find('.content')[0])
        TweenMax.to cont, .5, 'margin-top' : margin, opacity: 1, delay: 1.4

        bts = $(@$el.find('.lang-buttons')[0])
        TweenMax.to bts, .5, 'margin-top' : margin, opacity: 1, delay: 1.4

        bts = $(@$el.find('.lang-buttons')[0])
        TweenMax.to bts, .5, 'margin-top' : margin, opacity: 1, delay: 1.4

        cb = $(@$el.find('.close-button')[0])
        TweenMax.to cb, .5, 'margin-top' : margin, opacity: 1, delay: 1.4

        null



module.exports = OverlayDataContent
