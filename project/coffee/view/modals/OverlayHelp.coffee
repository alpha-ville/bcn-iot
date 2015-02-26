AbstractModal = require './AbstractModal'

class OverlayHelp extends AbstractModal

    name     : 'overlayHelp'
    template : 'overlay-help'
    cb       : null

    events:
        'click ul>li' : "toggleLang"
        'click .close-button' : "closeButton"
        # 'tap ul>li' : "toggleLang"

    constructor : (@cb) ->
        # @templateVars =
        #     content_en  : node.get('copy_en')
        #     content_cat : node.get('copy_cat')
        #     title_en    : node.get('name_en').toUpperCase()
        #     title_cat   : node.get('name_cat').toUpperCase()
        #     shape       : node.get('shape')
        #     icon        : node.get('icon_id')

        super()

        return null

    closeButton : =>
        Backbone.trigger( 'showHomeTooltip' )
        @B().appView.modalManager.hideOpenModal()
        # @B().appView.modalManager.showModal 'overlayContent'
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

        delay = .2

        t = $(@$el.find('h1')[0])
        TweenMax.to t, .5, opacity: 1, delay: delay

        cont = @$el.find('p')
        TweenMax.to cont, .5, opacity: 1, delay: delay + .2

        cont = @$el.find('hr')
        TweenMax.to cont, .5, opacity: 1, delay: delay + .3

        bts = $(@$el.find('.lang-buttons')[0])
        TweenMax.to bts, .5, 'margin-top' : margin, opacity: 1, delay: delay + .7

        cb = $(@$el.find('.close-button')[0])
        TweenMax.to cb, .5, 'margin-top' : margin, opacity: 1, delay: delay + .7

        @$el.find('.container-shape-help .object-container').each (a, b) ->
            TweenMax.to b, 0, y : -20
            TweenMax.to b, .5, y : 0, opacity: 1, delay: (delay + (a * .1))

        null



module.exports = OverlayHelp
