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

    clickBreadcrumb: (e) =>
        t = $(e.currentTarget)
        @B().selectedDataType = t.attr('data-type')
        @B().selectedDataId = t.attr('data-id')

        @B().appView.modalManager.hideOpenModal()
        @B().appView.modalManager.showModal 'overlayDataContent'
        null

module.exports = Breadcrumbs
