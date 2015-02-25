AbstractModel = require './AbstractModel'

class CategoryModel extends AbstractModel

    # tabletop:
    #   instance: @B().storage
    #   sheet: 'new-categories'

    sync: Backbone.tabletopSync

module.exports = CategoryModel
