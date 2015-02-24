CategoryModel        = require '../models/CategoryModel'
AbstractCollection = require './AbstractCollection'

class CategoriesCollection extends AbstractCollection

    model : CategoryModel
    sync: Backbone.tabletopSync

    constructor : ->
        super()

        @tabletop =
            instance: @B().storage
            sheet: 'new-categories'

module.exports = CategoriesCollection
