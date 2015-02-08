AbstractModel = require './AbstractModel'

class ObjectModel extends AbstractModel

    defaults :
        category    : null
        object_id   : null
        object_name : null
        icon        : null
        data_type   : null
        value_type  : null
        video       : null
        image       : null
        copy_en     : null
        copy_cat    : null

module.exports = ObjectModel
