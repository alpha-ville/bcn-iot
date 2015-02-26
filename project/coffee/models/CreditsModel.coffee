AbstractModel = require './AbstractModel'

class CreditsModel extends AbstractModel

    # tabletop:
    #   instance: @B().storage
    #   sheet: 'new-data'

    sync: Backbone.tabletopSync

module.exports = CreditsModel
