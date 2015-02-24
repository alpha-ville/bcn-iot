DataSourceModel    = require '../models/DataSourceModel'
AbstractCollection = require './AbstractCollection'

class DataSourceCollection extends AbstractCollection

    model : DataSourceModel
    sync: Backbone.tabletopSync

    constructor : ->
        super()
        @tabletop =
            instance: @B().storage
            sheet: 'new-data'

module.exports = DataSourceCollection
