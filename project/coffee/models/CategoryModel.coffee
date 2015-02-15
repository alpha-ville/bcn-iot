AbstractModel = require './AbstractModel'

class CategoryModel extends AbstractModel

    defaults :
        id            : null
        group         : null
        category_name : null
        name_en       : null
        name_cat      : null
        icon_id       : null
        copy_en       : null
        copy_cat      : null

module.exports = CategoryModel
