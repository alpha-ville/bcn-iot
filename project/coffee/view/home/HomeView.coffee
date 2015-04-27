AbstractViewPage  = require '../AbstractViewPage'
InteractiveCanvas = require './InteractiveCanvas/InteractiveCanvas'

class HomeView extends AbstractViewPage

    template : 'page-home'

    arrowLeftEl: null
    arrowRightEl: null

    constructor : ->

        # @templateVars =
        #   desc : @B().locale.get "home_desc"

        @interactive = new InteractiveCanvas

        super()

        @
            .addChild(@interactive)

        @arrowLeftEl = @el.querySelector( '.arrow-left' )
        @arrowRightEl = @el.querySelector( '.arrow-right' )

        @addListeners()

        return null


    addListeners: ->
        @arrowLeftEl.addEventListener( 'click', @onArrowClicked )
        @arrowRightEl.addEventListener( 'click', @onArrowClicked )

        null


    onArrowClicked: ( evt ) =>
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


    update : =>
        @interactive?.update()

        return null

module.exports = HomeView
