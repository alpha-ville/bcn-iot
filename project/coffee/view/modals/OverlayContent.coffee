AbstractModal = require './AbstractModal'
BreadCrumbs   = require '../components/BreadCrumbs'
ObjectsList   = require '../components/ObjectsList'

class OverlayContent extends AbstractModal

    name     : 'overlayContent'
    template : 'overlay-content'
    cb       : null
    lang     : 'en'

    events:
        'click ul>li' : "toggleLang"
        # 'tap ul>li' : "toggleLang"

    constructor : (@cb) ->

        node = @B().categories.findWhere category_name : @B().selectedObjectId

        breadcrumbsList = []
        breadcrumbsList.push @B().dataSources.findWhere id : i for i in @B().selectedSourceIds
        breadcrumbsList.push @B().purposes.findWhere id : a for a in @B().selectedPurposeIds

        @breadCrumbs = new BreadCrumbs breadcrumbsList

        objects = @B().objects.where "category" : node.get('category_name')
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

    changeContent : =>


    init : =>
        @toggleLang()
        @$el.find('.breadcrumbs').append @breadCrumbs.$el
        @$el.find('.container').append @objectCarosel.$el

        null

module.exports = OverlayContent
