AbstractView    = require './view/AbstractView'
Preloader       = require './view/base/Preloader'
# Header        = require './view/base/Header'
Wrapper         = require './view/base/Wrapper'
# Footer        = require './view/base/Footer'
ModalManager    = require './view/modals/_ModalManager'
MediaQueries    = require './utils/MediaQueries'
SoundController = require './utils/SoundController'

class AppView extends AbstractView

    template : 'main'

    $window  : null
    $body    : null

    wrapper  : null
    footer   : null

    dims :
        w : null
        h : null
        o : null
        c : null

    events :
        'click a' : 'linkManager'

    clicks : 0

    EVENT_UPDATE_DIMENSIONS : 'EVENT_UPDATE_DIMENSIONS'

    MOBILE_WIDTH : 700
    MOBILE       : 'mobile'
    NON_MOBILE   : 'non_mobile'

    constructor : ->

        @$window = $(window)
        @$body   = $('body').eq(0)

        @soundControlller = new SoundController( @B )
        super()
        null

    disableTouch: =>
        @$window.on 'touchmove', @onTouchMove
        return

    enableTouch: =>
        @$window.off 'touchmove', @onTouchMove
        return

    onTouchMove: ( e ) ->
        e.preventDefault()
        return

    render : =>
        # @preloader    = new Preloader
        @modalManager = new ModalManager
        @wrapper      = new Wrapper

        @addChild @wrapper

        @bindEvents()
        @onAllRendered()

        return

    bindEvents : =>

        @on 'allRendered', @onAllRendered

        @onResize()

        @onResize = _.debounce @onResize, 300
        @$window.on 'resize orientationchange', @onResize

        # @wrapper.$el.on 'click', @showModalTest

        return

    onAllRendered : =>
        # console.log "onAllRendered : =>"
        @$body.prepend @$el
        @begin()
        return

    begin : =>
        @trigger 'start'
        @wrapper.begin()
        # @preloader.hide()
        @B().router.start()

        @updateMediaQueriesLog()
        return

    onResize : =>
        @getDims()
        @updateMediaQueriesLog()
        return

    updateMediaQueriesLog : =>
        if @header then @header.$el.find(".breakpoint").html "<div class='l'>CURRENT BREAKPOINT:</div><div class='b'>#{MediaQueries.getBreakpoint()}</div>"
        return

    getDims : =>

        w = window.innerWidth or document.documentElement.clientWidth or document.body.clientWidth
        h = window.innerHeight or document.documentElement.clientHeight or document.body.clientHeight

        @dims =
            w : w
            h : h
            o : if h > w then 'portrait' else 'landscape'
            c : if w <= @MOBILE_WIDTH then @MOBILE else @NON_MOBILE

        @trigger @EVENT_UPDATE_DIMENSIONS, @dims

        return

    linkManager : (e) =>

        href = $(e.currentTarget).attr('href')

        return false unless href

        @navigateToUrl href, e

        return

    navigateToUrl : ( href, e = null ) =>

        if(href.match("^(http|https)://"))
            @handleExternalLink href
            return

        route   = if href.match(@B().BASE_PATH) then href.split(@B().BASE_PATH)[1] else href
        section = if route.indexOf('/') is 0 then route.split('/')[1] else route

        if @B().nav.getSection section
            e?.preventDefault()
            @B().router.navigateTo route

        return

    handleExternalLink : (data) =>

        ###

        bind tracking events if necessary

        ###

        return

module.exports = AppView
