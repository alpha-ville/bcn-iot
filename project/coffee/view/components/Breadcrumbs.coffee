AbstractView = require '../AbstractView'

class Breadcrumbs extends AbstractView

    template : 'breadcrumbs'

    events :
        "click" : "clickBreadcrumb"

    constructor : (@list) ->
        @list = _.shuffle(@list)

        @templateVars =
            list : @list

        super()
        null

    animate : (delay) =>
        @$el.children().each (i, e) =>
            s = $(e).parent()
            index = Number(s.attr('data-index'))
            TweenMax.to s, .6, opacity: 1, delay: delay + (.05 * index)
        null

    clickBreadcrumb: (e) =>
        t = $(e.currentTarget)
        @B().selectedDataType = t.attr('data-type').toString()
        @B().selectedDataId = t.attr('data-id')

        @B().appView.modalManager.hideOpenModal()
        @B().appView.modalManager.showModal 'overlayDataContent'
        null

module.exports = Breadcrumbs
