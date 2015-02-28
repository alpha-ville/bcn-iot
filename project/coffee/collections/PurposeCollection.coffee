PurposeModel    = require '../models/PurposeModel'
AbstractCollection = require './AbstractCollection'

class PurposeCollection extends AbstractCollection

    model : PurposeModel
    # sync: Backbone.tabletopSync

    # constructor : ->
    #     super()
    #     @tabletop =
    #         instance: @B().storage
    #         sheet: 'new-purpose'

module.exports = PurposeCollection
