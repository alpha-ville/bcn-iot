AbstractModel = require './AbstractModel'

class GroupModel extends AbstractModel

    # tabletop:
    #   instance: @B().storage
    #   sheet: 'new-categories'

    sync: Backbone.tabletopSync

module.exports = GroupModel
