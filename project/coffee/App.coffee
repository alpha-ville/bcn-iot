Templates            = require './data/Templates'
Router               = require './router/Router'
Nav                  = require './router/Nav'
AppView              = require './AppView'
ObjectsCollection    = require './collections/ObjectsCollection'
CategoriesCollection = require './collections/CategoriesCollection'
DataSourceCollection = require './collections/DataSourceCollection'
PurposeCollection    = require './collections/PurposeCollection'
CreditsCollection    = require './collections/CreditsCollection'
GroupsCollection    = require './collections/GroupsCollection'

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
        @soundParam = if(location.href.indexOf("localhost") > -1) then true else @getQueryVariable 'sound'
        @initObjects()
        null

    initObjects : =>

        @templates = new Templates "/data/templates#{(if @LIVE then '.min' else '')}.xml", @objectComplete

        @storage = Tabletop.init
            key: "1HIWOpkgxY5oJ9PjKQ3QxAWV_GMFWEIiszFpi37TMLaI"
            callback : (data) =>
                @categories  = new CategoriesCollection data['new-categories'].elements
                @purposes    = new PurposeCollection data['new-purpose'].elements
                @dataSources = new DataSourceCollection data['new-data'].elements
                @objects     = new ObjectsCollection data['new-objects'].elements
                @credits     = new CreditsCollection data['credits-copy'].elements
                @groups      = new GroupsCollection data['groups'].elements

                @objectComplete()

        # if new objects are added don't forget to change the `@objectComplete` function

        null

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
        @appView.modalManager.hideOpenModal()
        @appView.modalManager.showModal 'overlayHelp'
        null

    openOverlaySoon: =>
        # @appView.modalManager.hideOpenModal()
        @appView.modalManager.showModal 'overlaySoon'
        Backbone.Events.trigger( 'stopExperience' )
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

module.exports = App
