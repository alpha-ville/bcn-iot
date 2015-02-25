AbstractModel = require './AbstractModel'

class DataSourceModel extends AbstractModel

    # tabletop:
    #   instance: @B().storage
    #   sheet: 'new-data'

    sync: Backbone.tabletopSync

    defaults :
        model    : 'dataSources'

module.exports = DataSourceModel
