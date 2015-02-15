AbstractView = require '../AbstractView'

class Breadcrumbs extends AbstractView

    template : 'breadcrumbs'

    constructor : (@list) ->
        @list = _.shuffle(@list)

        @templateVars =
            list : @list

        super()
        null

    init: =>
        null

module.exports = Breadcrumbs
