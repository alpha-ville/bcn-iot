AbstractModel = require './AbstractModel'

class ObjectModel extends AbstractModel

    # tabletop:
    #   instance: window.B.storage
    #   sheet: 'new-objects'

    sync: Backbone.tabletopSync

module.exports = ObjectModel
