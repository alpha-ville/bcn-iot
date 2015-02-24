ObjectModel        = require '../models/ObjectModel'
AbstractCollection = require './AbstractCollection'

class ObjectsCollection extends AbstractCollection

    model : ObjectModel
    sync: Backbone.tabletopSync

    constructor : ->
        super()
        @tabletop =
            instance: @B().storage
            sheet: 'new-objects'

module.exports = ObjectsCollection
