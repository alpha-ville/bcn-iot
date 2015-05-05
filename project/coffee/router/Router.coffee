class Router extends Backbone.Router

    @EVENT_HASH_CHANGED : 'EVENT_HASH_CHANGED'

    FIRST_ROUTE : true

    routes :
        '(/)(:area)(/:sub)(/)' : 'hashChanged'
        '*actions'             : 'navigateTo'

    area   : null
    sub    : null
    params : null

    start : =>
        startRoute = window.location.pathname.substr( 1, window.location.pathname.length );

        if startRoute != ''

            @B().preloaderView.stopPlaying( =>

                @B().preloaderView.startExperience( -1 )

                Backbone.history.start
                    pushState : true
                    root      : '/'

            )
        else
            @B().preloaderView.stopPlaying()
            Backbone.history.start
                pushState : true
                root      : '/'



        null

    hashChanged : (@area = null, @sub = null) =>

        # console.log ">> EVENT_HASH_CHANGED @area = #{@area}, @sub = #{@sub} <<"

        # if !@area then @area = @B().nav.sections.HOME
        # @area = ""

        # console.log @area, @sub

        @trigger Router.EVENT_HASH_CHANGED, "", @sub, @params

        switch true
            when !@area and !@sub
                @showHome()
                break

            when @area is 'about'
                Backbone.Events.trigger('hideArrows')
                @B().appView.modalManager.hideOpenModal()
                @B().appView.modalManager.showModal 'overlayHelp'
                break

            when @area and !@sub
                Backbone.Events.trigger('showArrows')
                Backbone.trigger( 'SoundController:play', 'nontouchable' )
                Backbone.trigger( 'SoundController:play', 'loop' )
                Backbone.Events.trigger( 'groupSelected', @area )
                @B().resetIDs()
                @B().appView.modalManager.hideOpenModal()
                break

            else
                Backbone.Events.trigger('hideArrows')
                @B().openOverlayContent @sub

        null

    showHome : =>
        @B().openOverlaySoon()
        @B().objectsContentHack = null
        @B().objectsContentHackOrder = null
        # Backbone.Events.trigger( 'showHomeTooltip')
        Backbone.Events.trigger( 'showRoot')
        null

    navigateTo : (where = '', trigger = true, replace = false, @params) =>
        if where.charAt(0) isnt "/"
            where = "/#{where}"
        if where.charAt( where.length-1 ) isnt "/"
            where = "#{where}/"

        if !trigger
            @trigger Router.EVENT_HASH_CHANGED, where, null, @params
            return

        @navigate where, trigger: true, replace: replace

        Backbone.Events.trigger( 'Router:navigate', where)
        Backbone.Events.trigger( 'Tooltip:setCategory', @area )

        null

    B : =>

        return window.B

module.exports = Router
