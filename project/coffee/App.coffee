Analytics            = require './utils/Analytics'
Share                = require './utils/Share'
Templates            = require './data/Templates'
Router               = require './router/Router'
Nav                  = require './router/Nav'
AppView              = require './AppView'
MediaQueries         = require './utils/MediaQueries'
ObjectsCollection    = require './collections/ObjectsCollection'
CategoriesCollection = require './collections/CategoriesCollection'
DataSourceCollection = require './collections/DataSourceCollection'
PurposeCollection    = require './collections/PurposeCollection'

class App

    LIVE       : null
    BASE_PATH  : window.config.hostname
    localeCode : window.config.localeCode
    objReady   : 0

    _toClean   : ['objReady', 'setFlags', 'objectComplete', 'init', 'initObjects', 'initSDKs', 'initApp', 'go', 'cleanup', '_toClean']

    constructor : (@LIVE) ->

        return null

    setFlags : =>

        ua = window.navigator.userAgent.toLowerCase()

        MediaQueries.setup();

        @IS_ANDROID    = ua.indexOf('android') > -1
        @IS_FIREFOX    = ua.indexOf('firefox') > -1
        @IS_CHROME_IOS = if ua.match('crios') then true else false # http://stackoverflow.com/a/13808053

        null

    objectComplete : =>

        @objReady++
        @initApp() if @objReady >= 6

        null

    init : =>

        @initObjects()

        null

    initObjects : =>

        @templates = new Templates "/data/templates#{(if @LIVE then '.min' else '')}.xml", @objectComplete
        @analytics = new Analytics "/data/tracking.json", @objectComplete

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

    initApp : =>

        @setFlags()

        @selectedObjectId = "door_locks"
        @selectedSourceIds = [1, 5, 4]
        @selectedPurposeIds = [2, 3]
        @langSelected = 'en'

        # source id to show on detailed screen
        @selectedDataType = null
        @selectedDataId = null

        ### Starts application ###
        @appView = new AppView
        @router  = new Router
        @nav     = new Nav
        @share   = new Share

        @go()

        null

    selectObject     : (@selectedObjectId) => null
    selectSourceIDs  : (id) => @selectedSourceIds.push id
    selectPurposeIDs : (id) => @selectedPurposeIds.push id
    resetIDs         : =>
        @selectedObjectId = ""
        @selectedSourceIds = []
        @selectedPurposeIds = []
        @langSelected = 'en'

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
