AbstractModal = require './AbstractModal'
BreadCrumbs   = require '../components/Breadcrumbs'
ObjectsList   = require '../components/ObjectsList'

class OverlayContent extends AbstractModal

    name     : 'overlayContent'
    template : 'overlay-content'
    cb       : null
    lang     : 'en'

    events:
        'click ul>li' : "toggleLang"
        'click .close-button' : "closeButton"
        # 'tap ul>li' : "toggleLang"

    constructor : (@cb) ->

        node = @B().categories.findWhere category_name : @B().selectedObjectId

        breadcrumbsList = []
        breadcrumbsList.push @B().dataSources.findWhere id : i for i in @B().selectedSourceIds
        breadcrumbsList.push @B().purposes.findWhere id : a for a in @B().selectedPurposeIds

        @breadCrumbs = new BreadCrumbs breadcrumbsList

        objects = @B().objects.where "category" : node.get('category_name')
        objects = _.shuffle objects
        @objectCarosel = new ObjectsList objects

        @templateVars =
            content_en  : node.get('copy_en')
            content_cat : node.get('copy_cat')
            title_en    : node.get('name_en').toUpperCase()
            title_cat   : node.get('name_cat').toUpperCase()
            shape       : 'circle'
            icon        : node.get('icon_id')

        super()

        return null

    closeButton : =>
        @B().resetIDs()
        @B().appView.modalManager.hideOpenModal()
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
        @$el.find('.breadcrumbs').append @breadCrumbs.$el
        @$el.find('.container').append @objectCarosel.$el

        @animate()

        null

    animate : =>
        margin = 30

        c = $(@$el.find('.container-shape')[0])
        TweenMax.to c, 0, scaleX: 0, scaleY: 0
        TweenMax.to c, 1, scaleX: 1, scaleY: 1, ease: Back.easeOut.config(18), opacity: 1, delay: .5

        @breadCrumbs.animate .9

        t = $(@$el.find('.title-container')[0])
        TweenMax.to t, .5, 'margin-top' : margin, opacity: 1, delay: 1

        cont = $(@$el.find('.content')[0])
        TweenMax.to cont, .5, 'margin-top' : margin, opacity: 1, delay: 1.4

        bts = $(@$el.find('.lang-buttons')[0])
        TweenMax.to bts, .5, 'margin-top' : margin, opacity: 1, delay: 1.4

        bts = $(@$el.find('.lang-buttons')[0])
        TweenMax.to bts, .5, 'margin-top' : margin, opacity: 1, delay: 1.4

        @objectCarosel.animate 1.4
        null

module.exports = OverlayContent
