AbstractModal = require './AbstractModal'
BreadCrumbs   = require '../components/Breadcrumbs'
ObjectsList   = require '../components/ObjectsList'

class OverlayContent extends AbstractModal

    name       : 'overlayContent'
    template   : 'overlay-content'
    cb         : null
    lang       : 'en'
    objects    : null

    events:
        'click ul>li'  : 'toggleLang'
        'click .close-button' : 'closeButton'
        'click .help-button' : 'openHelp'

    constructor : (@cb) ->
        breadcrumbsList = []

        node = @B().categories.findWhere category_name : @B().selectedCategoryId

        @objects = @B().objects.where "category" : node.get('category_name')

        for object in @objects
            timestamp = Date.now()
            object.attributes["video_titles_en_nocache"] = object.attributes["video_titles_en"] +  "?plop=#{timestamp}"

        @objects = @B().objectsContentHack or _.shuffle @objects
        @objectCarosel = new ObjectsList @objects
        @objectCarosel.on 'slideChange', @slideChange
        @objectCarosel.on 'beforeChange', @beforeChange

        @templateVars =
            content_en  : node.get('copy_en')
            content_cat : node.get('copy_cat')
            title_en    : node.get('name_en').toUpperCase()
            title_cat   : node.get('name_cat').toUpperCase()
            shape       : 'circle'
            icon        : node.get('icon_id')

        super()

        @containerContent = $(@$el.find('.container')[0])
        @title = $( @containerContent.find('.title-container')[0] )
        @titleSticky = $(@$el.find('.sticky-title')[0])

        Backbone.trigger( 'SoundController:stop', 'loop' )

        @initEvents()

        return null

        null

    openHelp : =>
        @containerContent.off 'scroll'
        @B().openHelp()

    initEvents : =>
        @containerContent.on 'scroll', @scrollWindow
        null

    scrollWindow : =>
        op = if @title.position().top < -70 then 1 else 0
        @titleSticky.css 'opacity', op

    beforeChange : () =>
        @breadCrumbs.animateOut()
        TweenMax.to $(@$el.find('.project-name-container>.project-name')[0]), .2, opacity: 0

        null

    setBreadcrumb : (object, delay = 0) =>

        @breadCrumbs = null
        breadcrumbsList = []

        selectableSources =  object.get('data_type').toLowerCase().split(" ").join("").split(";")
        breadcrumbsList.push @B().dataSources.findWhere type : i for i in selectableSources

        selectablePurposes = object.get('purpose_type').toLowerCase().split(" ").join("").split(";")
        for i in selectablePurposes
            breadcrumbsList.push @B().purposes.findWhere type : i

        @breadCrumbs = new BreadCrumbs breadcrumbsList
        @bcContainer.empty()
        @bcContainer.append @breadCrumbs.$el
        @breadCrumbs.animate delay
        null

    slideChange : (slideID, delay = 0) =>
        a = @B().objects.findWhere id : String(slideID)

        pn = $(@$el.find('.project-name-container>.project-name')[0])
        pn2 = $(@$el.find('.project-name-container>.project-name')[1])
        pn.text a.get('name_en')
        pn2.text a.get('name_cat')

        TweenMax.to $(@$el.find('.project-name-container>.project-name')[0]), .2, opacity: 1

        @setBreadcrumb a, delay
        null

    closeButton : (e) =>
        @containerContent.off 'scroll'
        @B().router.navigateTo @B().groupName()

        null

    toggleLang : (e) =>
        @$el.find('li').each (a, b) => $(b).attr('data-selected', false)

        if e
            $(e.currentTarget).attr 'data-selected', true
            @B().langSelected = $(e.currentTarget).attr('data-lang')
        else
            $(@$el.find('li[data-lang="' + @B().langSelected + '"]')).attr 'data-selected', true

        @$el.find('[data-lang]').not("li").each (a, b) =>
            $(b).css
                display : if $(b).attr('data-lang') is @B().langSelected then 'inline-block' else 'none'

        @breadCrumbs.toggleLang()

        null

    init : =>
        @$el.find('.list-container').append @objectCarosel.$el
        @bcContainer = $(@$el.find('.breadcrumbs')[0])

        @slideChange @objects[0].get('id'), .9

        @toggleLang()
        @animate()

        null

    animate : =>
        margin = 30

        c = $(@$el.find('.container-shape')[0])
        TweenMax.to c, 0, scaleX: 0, scaleY: 0
        TweenMax.to c, 1, scaleX: 1, scaleY: 1, ease: Back.easeOut.config(18), opacity: 1, delay: .2

        TweenMax.to c, .5, "margin-top": 40, delay: 1.1

        t = $(@$el.find('.title-container')[0])
        TweenMax.to t, .5, 'margin-top' : margin, opacity: 1, delay: 1.3

        TweenMax.to @$el.find('hr'), .5, opacity: 1, delay: 1.5

        cont = $(@$el.find('.content')[0])
        TweenMax.to cont, .5, 'margin-top' : 40, opacity: 1, delay: 1.6

        pnc = $(@$el.find('.project-name-container')[0])
        TweenMax.to pnc, .5, 'margin-top' : 40, opacity: 1, delay: 1.5

        bts = $(@$el.find('.lang-buttons')[0])
        TweenMax.to bts, .5, 'margin-top' : 30, opacity: 1, delay: 1.8

        cb = $(@$el.find('.close-button')[0])
        TweenMax.to cb, .5, 'margin-top' : 8, opacity: 1, delay: 2.2

        @objectCarosel.animate 2.5
        null

module.exports = OverlayContent
