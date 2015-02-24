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

        @$el.find('[data-lang]').not("li").each (a, b) =>
            $(b).css
                display : if $(b).attr('data-lang') is @B().langSelected then 'block' else 'none'
        null

    animate : (delay) =>
        @$el.children().each (i, e) =>
            s = $(e).parent()
            index = Number(s.attr('data-index'))
            TweenMax.to s, .6, opacity: 1, 'margin-top' : 20, delay: delay + (.05 * index)
        null

    clickBreadcrumb: (e) =>
        t = $(e.currentTarget)
        @B().selectedDataType = t.attr('data-type').toString()
        @B().selectedDataId = t.attr('data-id')

        console.log t.find('.name-container > p[data-lang="en"]').text(), @B().selectedDataId, @B().selectedDataType

        @B().openOverlayData()
        null

module.exports = Breadcrumbs
