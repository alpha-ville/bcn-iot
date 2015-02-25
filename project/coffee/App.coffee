Templates            = require './data/Templates'
Router               = require './router/Router'
Nav                  = require './router/Nav'
AppView              = require './AppView'
ObjectsCollection    = require './collections/ObjectsCollection'
CategoriesCollection = require './collections/CategoriesCollection'
DataSourceCollection = require './collections/DataSourceCollection'
PurposeCollection    = require './collections/PurposeCollection'

class App

    LIVE        : null
    # BASE_PATH   : window.config.hostname
    # localeCode  : window.config.localeCode
    objReady    : 0
    purposes    : null
    dataSources : null
    objects     : null
    categories  : null

    storage : null

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
        @initApp() if @objReady >= 5

        null

    init : =>

        @initObjects()

        null

    initObjects : =>

        @templates = new Templates "/data/templates#{(if @LIVE then '.min' else '')}.xml", @objectComplete

        @storage = Tabletop.init
            key: "1HIWOpkgxY5oJ9PjKQ3QxAWV_GMFWEIiszFpi37TMLaI"
            callback : (data) =>

                @categories = new CategoriesCollection
                @categories.fetch success : @objectComplete

                @purposes = new PurposeCollection
                @purposes.fetch success : @objectComplete

                @dataSources = new DataSourceCollection
                @dataSources.fetch success : @objectComplete

                @objects = new ObjectsCollection
                @objects.fetch success : @objectComplete


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
        @selectedDataId = null

        ### Starts application ###
        @appView = new AppView
        @router  = new Router
        @nav     = new Nav

        @go()

        null

    openOverlayContent : (@selectedCategoryId) =>
        @appView.modalManager.hideOpenModal()
        @appView.modalManager.showModal 'overlayContent'
        null

    openOverlayData : () =>
        @appView.modalManager.hideOpenModal()
        @appView.modalManager.showModal 'overlayDataContent'
        null

    openHelp: =>
        @appView.modalManager.showModal 'overlayHelp'

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
