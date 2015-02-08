AbstractModel = require './AbstractModel'

class ObjectModel extends AbstractModel

    defaults :
        category   : null
        id         : null
        name       : null
        icon       : null
        data_type  : null
        data_value : null
        video      : null
        image      : null

module.exports = ObjectModel
