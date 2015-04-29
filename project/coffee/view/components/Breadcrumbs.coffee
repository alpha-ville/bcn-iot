AbstractView = require '../AbstractView'

class Breadcrumbs extends AbstractView

    template : 'breadcrumbs'

    # events :
    #     "click" : "clickBreadcrumb"

    constructor : (@list) ->
        # @list = _.shuffle(@list)

        # console.log @list

        @templateVars =
            list : @list

        super()

        @toggleLang()

        null

    animate : (delay) =>

        @$el.children().each (i, e) =>
            s = $(e).parent()
            index = Number(s.attr('data-index'))
            TweenMax.to s, 0, y: -20
            TweenMax.to s, .5, opacity: 1, y : 0, delay: delay + (.1 * index)
        null

    toggleLang : () =>

        browser = bowser

        @$el.find('[data-lang]').each (a, b) =>
            style = if $(b).attr('data-inline') isnt undefined then 'inline-flex' else 'block'
            if(style is 'inline-flex')
                switch(browser.name.toLowerCase())
                    when "safari" then style = '-webkit-inline-flex'
                    when "msie" then style = '-ms-inline-flex'
                    else
                        style = "inline-flex"

            $(b).css
                display : if $(b).attr('data-lang') is @B().langSelected then style else 'none'

        null

    animateOut : =>
        @$el.children().each (i, e) =>
            s = $(e).parent()
            index = Number(s.attr('data-index'))
            TweenMax.to s, .3, opacity: 0, y: 20, delay: (.08 * index)

    clickBreadcrumb: (e) =>
        return
        Backbone.Events.trigger('OverlayData:open')
        Backbone.trigger( 'SoundController:play', 'touchable' )

        t = $(e.currentTarget)
        @B().selectedDataType = t.attr('data-type').toString()
        @B().selectedDataId = t.attr('data-id')

        # console.log t.find('.name-container > p[data-lang="en"]').text(), @B().selectedDataId, @B().selectedDataType

        @B().objectsContentHack = @B().appView.modalManager.modals.overlayContent.view.objects
        @B().openOverlayData()
        null

    onClickBreadcrumb: =>

        null

module.exports = Breadcrumbs
