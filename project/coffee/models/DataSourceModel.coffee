AbstractModel = require './AbstractModel'

class DataSourceModel extends AbstractModel

    defaults :
        model    : 'dataSources'
        id       : null
        shape    : null
        type     : null
        name_en  : null
        name_cat : null
        icon_id  : null
        copy_en  : null
        copy_cat : null

module.exports = DataSourceModel
