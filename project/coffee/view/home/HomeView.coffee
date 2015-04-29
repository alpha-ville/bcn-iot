AbstractViewPage  = require '../AbstractViewPage'
InteractiveCanvas = require './InteractiveCanvas/InteractiveCanvas'

class HomeView extends AbstractViewPage

    template : 'page-home'

    logoEl: null
    arrowLeftEl: null
    arrowRightEl: null

    isVisible: false
    areArrowsVisible: true

    constructor : ->

        # @templateVars =
        #   desc : @B().locale.get "home_desc"

        @interactive = new InteractiveCanvas

        super()

        @
            .addChild(@interactive)

        @logoEl = @el.querySelector( '.logo' )
        @arrowLeftEl = @el.querySelector( '.arrow-left' )
        @arrowRightEl = @el.querySelector( '.arrow-right' )

        @addListeners()

        return null


    addListeners: ->
        Backbone.Events.on( 'startExperience', @transitionIn )
        Backbone.Events.on( 'showArrows', @showArrows )
        Backbone.Events.on( 'hideArrows', @hideArrows )
        @logoEl.addEventListener( 'click', @onLogoClicked )
        @arrowLeftEl.addEventListener( 'click', @onArrowClicked )
        @arrowRightEl.addEventListener( 'click', @onArrowClicked )

        null


    onLogoClicked: =>
        @B().router.navigateTo( '' )

        null


    onArrowClicked: ( evt ) =>
        if !@isVisible then return

        # prev or next has been clicked ?
        if evt.target.className == 'arrow-left' then direction = -1 else direction = 1

        # get current area id
        currentAreaId = 0
        for i in [ 0 ... @B().groups.models.length ]
            if @B().groups.models[ i ].attributes.group == @B().router.area
                currentAreaId = i

        # define the area id to go
        newAreaId = currentAreaId + direction
        if direction == -1 and currentAreaId == 0 then newAreaId = 5
        if direction == 1 and currentAreaId == 5 then newAreaId = 0

        newArea = @B().groups.models[ newAreaId ].attributes.group

        # fire !
        @changeSection( newArea )

        null


    changeSection: ( area ) ->
        @B().router.navigateTo( area )

        null


    transitionIn: =>
        @isVisible = true

        @logoEl.classList.add('transitionIn')
        @arrowLeftEl.classList.add('transitionIn')
        @arrowRightEl.classList.add('transitionIn')


        null


    transitoutOut: =>
        @isVisible = false

        @logoEl.classList.remove('transitionIn')
        @arrowLeftEl.classList.remove('transitionIn')
        @arrowRightEl.classList.remove('transitionIn')

        null


    showArrows: =>
        if @areArrowsVisible then return

        @areArrowsVisible = true

        @arrowLeftEl.classList.add('transitionIn')
        @arrowRightEl.classList.add('transitionIn')


    hideArrows: =>
        if !@areArrowsVisible then return

        @areArrowsVisible = false

        @arrowLeftEl.classList.remove('transitionIn')
        @arrowRightEl.classList.remove('transitionIn')

        null


    update : =>
        @interactive?.update()

        return null

module.exports = HomeView
