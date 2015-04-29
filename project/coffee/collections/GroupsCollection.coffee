GroupModel        = require '../models/GroupModel'
AbstractCollection = require './AbstractCollection'

class GroupsCollection extends AbstractCollection

    model : GroupModel
    # sync: Backbone.tabletopSync

    # constructor : ->
    #     super()

    #     @tabletop =
    #         instance: @B().storage
    #         sheet: 'new-categories'

module.exports = GroupsCollection
