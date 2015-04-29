Templates            = require './data/Templates'
Router               = require './router/Router'
Nav                  = require './router/Nav'
AppView              = require './AppView'
Requester            = require './utils/Requester'
ObjectsCollection    = require './collections/ObjectsCollection'
CategoriesCollection = require './collections/CategoriesCollection'
DataSourceCollection = require './collections/DataSourceCollection'
PurposeCollection    = require './collections/PurposeCollection'
CreditsCollection    = require './collections/CreditsCollection'
GroupsCollection     = require './collections/GroupsCollection'
PreloaderView        = require './view/preloader/PreloaderView'

class App

    LIVE        : null
    objReady    : 0
    purposes    : null
    dataSources : null
    objects     : null
    categories  : null
    credits     : null

    BASE_PATH   : "/";

    objectsContentHack      : null
    objectsContentHackOrder : null

    prevPage : null

    storage      : null

    _toClean   : ['objReady', 'setFlags', 'objectComplete', 'init', 'initObjects', 'initSDKs', 'initApp', 'go', 'cleanup', '_toClean']

    constructor : (@LIVE) ->

        return null

    setFlags : =>

        ua = window.navigator.userAgent.toLowerCase()

        @IS_ANDROID    = ua.indexOf('android') > -1
        @IS_FIREFOX    = ua.indexOf('firefox') > -1
        @IS_CHROME_IOS = if ua.match('crios') then true else false # http://stackoverflow.com/a/13808053

        null

    objectComplete : =>
        @objReady++
        @initApp() if @objReady == 2

        null

    init : =>
        if(window.mobilecheck())
            $('#mobile-fallback').show()
            $('#preloader-anim').remove()
            return

        @preloaderView = new PreloaderView
        @update()

        @soundParam = if(location.href.indexOf("localhost") > -1) then true else @getQueryVariable 'sound'
        @initObjects()
        null

    initObjects : =>

        @templates = new Templates "/data/templates#{(if @LIVE then '.min' else '')}.xml", @objectComplete
        #url : '/data/cachedDatabase.json',

        Requester.request
            type : 'GET',
            url : "https://googledrive.com/host/0B0uHwEQ4FBZxeDI5UVV3RE9XOEk",
            done : (e) =>
                @categories  = new CategoriesCollection e.categories
                @purposes    = new PurposeCollection e.purpose
                @dataSources = new DataSourceCollection e.sources
                @objects     = new ObjectsCollection e.objects
                @credits     = new CreditsCollection e.credits
                @groups      = new GroupsCollection e.groups
                @objectComplete()

        # @generateJSON()

        # @categories  = new CategoriesCollection data['new-categories'].elements
        # @purposes    = new PurposeCollection data['web-new-purpose'].elements
        # @dataSources = new DataSourceCollection data['web-new-data'].elements
        # @objects     = new ObjectsCollection data['web-new-objects'].elements
        # @credits     = new CreditsCollection data['new-credits-copy'].elements
        # @groups      = new GroupsCollection data['groups'].elements

        # if new objects are added don't forget to change the `@objectComplete` function

        null

    generateJSON : =>
        @storage = Tabletop.init
            key: "1HIWOpkgxY5oJ9PjKQ3QxAWV_GMFWEIiszFpi37TMLaI"
            callback : (data) =>

                cachedData =
                    categories : data['new-categories'].elements
                    purpose    : data['web-new-purpose'].elements
                    sources    : data['web-new-data'].elements
                    objects    : data['web-new-objects'].elements
                    credits    : data['new-credits-copy'].elements
                    groups     : data['groups'].elements

                download = "data:application/octet-stream;charset=utf-8," + encodeURIComponent(JSON.stringify(cachedData))
                window.open download

    getQueryVariable : (variable) =>
       query = window.location.search.substring(1)
       vars = query.split("&")
       for i in vars
           pair = i.split("=")
           return pair[1] if(pair[0] == variable)
       return false

    initApp : =>
        @setFlags()

        @selectedCategoryId = "door_locks"
        @selectedObjectId = 1

        @langSelected = 'en'

        # source id to show on detailed screen
        @selectedDataType = null
        @selectedDataId   = null

        ### Starts application ###
        @router  = new Router
        @nav     = new Nav
        @appView = new AppView

        videojs.options.flash.swf = "data/video/video-js.swf"

        @go()

        # @appView.modalManager.showModal 'overlayHelp'

        null

    groupName : =>
        @router.area or "home"

    openOverlayContent : (@selectedCategoryId) =>
        @appView.modalManager.hideOpenModal()
        @appView.modalManager.showModal 'overlayContent'
        null

    openOverlayData : () =>
        @appView.modalManager.hideOpenModal()
        @appView.modalManager.showModal 'overlayDataContent'
        null

    openHelp: =>
        @prevPage = [@router.area, @router.sub]
        @router.navigateTo('about')
        null

    openOverlaySoon: =>
        # @appView.modalManager.hideOpenModal()
        #
        # @appView.modalManager.showModal 'overlaySoon'
        # Backbone.Events.trigger( 'stopExperience' )
        #
        # document.body.className = 'show-cursor'
        null

    resetIDs : =>
        @selectedCategoryId = ""
        selectedObjectId    = ""
        @langSelected       = 'en'
        null

    go : =>

        ### After everything is loaded, kicks off website ###
        @appView.render()

        ### remove redundant initialisation methods / properties ###
        @cleanup()

        null

    cleanup : =>

        for fn in @_toClean
            @[fn] = null
            delete @[fn]

        null


    update: =>
        requestAnimFrame @update

        @preloaderView.update()
        @appView?.update()

        if @appView?
            @preloaderView.update( @appView.wrapper.home.interactive.helpButton )

        null

module.exports = App
