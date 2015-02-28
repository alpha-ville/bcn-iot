CreditsModel    = require '../models/CreditsModel'
AbstractCollection = require './AbstractCollection'

class CreditsCollection extends AbstractCollection

    model : CreditsModel
    # sync: Backbone.tabletopSync

    # constructor : ->
    #     super()
    #     @tabletop =
    #         instance: @B().storage
    #         sheet: 'credits-copy'

module.exports = CreditsCollection
