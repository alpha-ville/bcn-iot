AbstractModel = require './AbstractModel'

class PurposeModel extends AbstractModel

    defaults :
        model : 'purposes'

    # tabletop:
    #   instance: @B().storage
    #   sheet: 'new-purpose'

    sync: Backbone.tabletopSync

module.exports = PurposeModel
